defimpl Kuraudo.ObjectStore, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack
  import Kuraudo.Utils.Data

  def buckets(driver) do
    url = get_url(driver, :"object-store")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_buckets_list(driver)
  end

  def bucket_by_name(driver, bucketname) do
    url = get_url(driver, :"object-store")
    header = get_header(driver)

    call(driver, :get, url, header, [prefix: bucketname])
    |> check_os_error
    |> parse_buckets_list(driver)
    |> Enum.first
  end

  def create_bucket(driver, bucketname, acls // []) do
    url = get_url(driver, :"object-store", "/#{bucketname}")

    acls_headers = Enum.reduce(acls, [], fn({key, data}, list) ->
      case key do
        :read -> list ++ [{:"X-Container-Read", ".r:" <> Enum.join(data, ",")}]
        :write -> list ++ [{:"X-Container-Write", Enum.join(data, ",")}]
        _ -> list
      end
    end)

    header = get_header(driver, acls_headers)

    call(driver, :put, url, header)
    |> check_os_error

    bucket_by_name(driver, bucketname)
  end

  def upload(driver, bucket, filename, metadata // []) do
    url = get_url(driver, :"object-store", "/#{bucket.name}/#{Path.basename(filename)}")
    header = get_header(driver, [{:"Content-Type", :mimetypes.filename(filename)}])
    body = case File.read(filename) do 
      {:ok, binary} -> binary
      {:error, reason} -> raise Kuraudo.FileError, driver: "OpenStack", message: reason
    end
    
    call(driver, :put, url, header, [], body)
    |> check_os_error

    if length(metadata) > 0 do
      metadatas = Enum.reduce(metadata, [], fn({key, value}, list) -> 
          list ++ [{:"X-Object-Meta-#{key}", "#{value}"}]
      end)
      header = get_header(driver, metadatas)
      call(driver, :post, url, header)
      |> check_os_error
    end

    bucket_by_name(driver, bucket.name)
  end

  def download(driver, bucket, output_path, objects // []) do
    Enum.each(objects, fn(object) -> download_file(object, driver, bucket, output_path) end)
  end

  def delete(driver, bucket, []) do
    delete(driver, bucket, :all)
    url = get_url(driver, :"object-store", "/#{bucket.name}")
    header = get_header(driver)

    call(driver, :delete, url, header)
    |> check_os_error

    true
  end

  def delete(driver, bucket, :all) do
    files = Enum.reduce(bucket.objects, [], fn(object, list) -> list ++ [object.name] end)
    if length(files) > 0 do
      delete(driver, bucket, files)
    else
      bucket
    end
  end

  def delete(driver, bucket, files) when is_list(files) and length(files) > 0 do
    Enum.each(files, fn(file) ->
      url = get_url(driver, :"object-store", "/#{bucket.name}/#{file}")
      header = get_header(driver)

      call(driver, :delete, url, header)
      |> check_os_error
    end)

    bucket_by_name(driver, bucket.name)
  end

  defp download_file({object, filename}, driver, bucket, output_path) do
    url = get_url(driver, :"object-store", "/#{bucket.name}/#{object}")
    header = get_header(driver, [{:"Accept", "*/*"}])

    output_file = Path.join(output_path || ".", filename || object)

    call(driver, :get, url, header)
    |> check_os_error
    |> save_file(output_file)
  end

  defp save_file(response, path) do
    case File.write(path, response.body) do
      :ok -> true
      {:error, reason} -> raise Kuraudo.FileError, driver: "OpenStack", message: reason
    end
  end

  defp parse_buckets_list(response, driver) do
    Jsonex.decode(response.body)
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_bucket(node, driver)] end)
  end

  defp node_to_bucket(node, driver) do
    content = get_bucket_content(Dict.get(node, "name"), driver)

    Kuraudo.Resource.Bucket[
      name: Dict.get(node, "name"),
      bytes: Dict.get(node, "bytes"),
      read: Dict.get(content, :read, []),
      write: Dict.get(content, :write, []),
      objects: Dict.get(content, :objects, [])
    ]
  end

  defp get_bucket_content(bucketname, driver) do
    url = get_url(driver, :"object-store", "/#{bucketname}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_bucket_content(bucketname, driver)
  end

  defp parse_bucket_content(response, bucketname, driver) do
    read = Dict.get(response.headers, :"X-Container-Read", "") 
    read = (Regex.captures(%r/\.r:(?<read>.*)/g, read) || []) 
    |> Dict.get(:read, "") 
    |> String.split(",") 
    |> Enum.filter(fn(e) -> e != "" end)

    write = Dict.get(response.headers, :"X-Container-Write", "") 
    |> String.split(",")
    |> Enum.filter(fn(e) -> e != "" end)

    objects = Jsonex.decode(response.body)
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_object(node, bucketname, driver)] end)

    [read: read, write: write, objects: objects]
  end

  defp node_to_object(node, bucketname, driver) do
    metadatas = get_object_content(Dict.get(node, "name"), bucketname, driver)

    Kuraudo.Resource.Bucket.Object[
      hash: Dict.get(node, "hash"),
      last_modified: Dict.get(node, "last_modified") |> get_calendar_date_or_nil,
      bytes: Dict.get(node, "bytes"),
      name: Dict.get(node, "name"),
      content_type: Dict.get(node, "content_type"),
      metadatas: metadatas
    ]
  end

  defp get_object_content(name, bucketname, driver) do
    url = get_url(driver, :"object-store", "/#{bucketname}/#{name}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_object_content
  end

  defp parse_object_content(response) do
    Enum.reduce(response.headers, [], fn({key, value}, list) -> 
    if "#{key}" =~ %r/X-Object-Meta-.*/ do
      meta_key = (Regex.captures(%r/X-Object-Meta-(?<meta>.*)/g, "#{key}") || []) 
      |> Dict.get(:meta, "")
      list ++ [{meta_key, value}]
    else
      list
    end
    end)
  end
end
