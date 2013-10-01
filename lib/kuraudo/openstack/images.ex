defimpl Kuraudo.Images, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack
  import Kuraudo.Utils.Data

  def all(driver) do
    url = get_url(driver, :image, "/images")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_images_list
  end

  def search_by_id(driver, id) do
    url = get_url(driver, :image, "/images/#{id}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_image
  end

  def delete(driver, image) do
    url = get_url(driver, :image, "/images/#{image.id}")
    header = get_header(driver)

    call(driver, :delete, url, header)
    |> check_os_error
    true
  end

  def create(driver, name, file, disk_format, options // []) do
    url = get_url(driver, :image, "/images")
    header = get_header(driver)
    body = Dict.merge(
      [container_format: "bare"], 
      Enum.reduce(options, [name: name, disk_format: "#{disk_format}"], fn({key, value}, body) ->
        case key do
          :id -> body ++ [id: value]
          :is_public -> body ++ [visibility: visibility(value)]
          :is_protected -> body ++ [protected: value]
          :tags -> body ++ [tags: value]
          :container_format -> body ++ [container_format: "#{value}"]
        end
      end) 
    ) |> Jsonex.encode

    response = call(driver, :post, url, header, [], body)
    |> check_os_error
    |> parse_image

    url = get_url(driver, :image, "/images/#{response.id}/file")
    header = get_header(driver, [{:"Content-Type", "application/octet-stream"}])
    body = case File.read(file) do 
      {:ok, binary} -> binary
      {:error, reason} -> raise Kuraudo.FileError, driver: "OpenStack", message: reason
    end
    call(driver, :put, url, header, [], body)
    |> check_os_error

    search_by_id(driver, response.id)
  end

  defp visibility(true) do
    "public"
  end

  defp visibility(false) do
    "private"
  end

  ######################################### WIP #########################################

  defp parse_image(response) do
    Jsonex.decode(response.body)
    |> node_to_image
  end

  defp parse_images_list(response) do
    Jsonex.decode(response.body)
    |> Dict.get("images")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_image(node)] end)
  end

  defp node_to_image(node) do
    Kuraudo.Resource.Image[
      id: Dict.get(node, "id"),
      status: Dict.get(node, "status"),
      name: Dict.get(node, "name"),
      properties: Dict.get(node, "tags"),
      container_format: Dict.get(node, "container_format"),
      created_at: Dict.get(node, "created_at")
        |> get_calendar_date_or_nil,
      disk_format: Dict.get(node, "disk_format"),
      updated_at: Dict.get(node, "updated_at")
        |> get_calendar_date_or_nil,
      size: Dict.get(node, "size"),
      is_public: Dict.get(node, "visibility") == "public",
      is_protected: Dict.get(node, "protected"),
      min_disk: Dict.get(node, "min_disk", 0),
      size: Dict.get(node, "size"),
      min_ram: Dict.get(node, "min_ram", 0)
    ]
  end

end
