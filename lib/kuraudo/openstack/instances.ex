defimpl Kuraudo.Instances, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack
  import Kuraudo.Utils.Data

  def all(driver) do
    url = get_url(driver, :compute, "/servers/detail")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_servers_list(driver)
  end

  def search_by_id(driver, id) do
    url = get_url(driver, :compute, "/servers/#{id}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_server(driver)
  end

  def wait(driver, instance, status // :active) do
    instance = search_by_id(driver, instance.id)
    if instance.status == binary_to_atom(String.downcase("#{status}")) do
      instance
    else
      :timer.sleep(1000)
      instance = search_by_id(driver, instance.id)
      wait(driver, instance, status)
    end
  end

  def reboot(driver, instance, type // :soft) do
    body = Jsonex.encode [reboot: [type: String.upcase("#{type}")]]
    perform_action(driver, instance, body)
  end

  def update(driver, instance, options) do
    url = get_url(driver, :compute, "/servers/#{instance.id}")
    header = get_header(driver)
    body = Jsonex.encode [server: options]

    call(driver, :put, url, header, [], body)
    |> check_os_error
    |> parse_server(driver)
  end

  def pause(driver, instance) do
    body = Jsonex.encode [pause: :null]
    perform_action(driver, instance, body)
  end

  def unpause(driver, instance) do
    body = Jsonex.encode [unpause: :null]
    perform_action(driver, instance, body)
  end

  def suspend(driver, instance) do
    body = Jsonex.encode [suspend: :null]
    perform_action(driver, instance, body)
  end

  def resume(driver, instance) do
    body = Jsonex.encode [resume: :null]
    perform_action(driver, instance, body)
  end

  def start(driver, instance) do
    body = Jsonex.encode ["os-start": :null]
    perform_action(driver, instance, body)
  end

  def stop(driver, instance) do
    body = Jsonex.encode ["os-stop": :null]
    perform_action(driver, instance, body)
  end

  def delete(driver, instance) do
    url = get_url(driver, :compute, "/servers/#{instance.id}")
    header = get_header(driver)

    call(driver, :delete, url, header) # TODO: (what?)
    |> check_os_error
    true
  end

  def create(driver, name, flavor, image, options // []) do
    url = get_url(driver, :compute, "/servers")
    header = get_header(driver)
    uoptions = []                                     # TODO: with options
    body = Jsonex.encode [server: [
      name: "#{name}",
      flavorRef: "#{flavor.id}",
      imageRef: "#{image.id}"
    ] ++ uoptions]

    call(driver, :post, url, header, [], body)
    |> check_os_error
    |> parse_server(driver)
  end

  def add_security_group(driver, instance, sg) do
    url = get_url(driver, :compute, "/servers/#{instance.id}/action")
    header = get_header(driver)
    body = Jsonex.encode [addSecurityGroup: [name: sg.name]]

    call(driver, :post, url, header, [], body)
    |> check_os_error

    search_by_id(driver, instance.id)
  end

  def remove_security_group(driver, instance, sg) do
    url = get_url(driver, :compute, "/servers/#{instance.id}/action")
    header = get_header(driver)
    body = Jsonex.encode [removeSecurityGroup: [name: sg.name]]

    call(driver, :post, url, header, [], body)
    |> check_os_error
    
    search_by_id(driver, instance.id)
  end

  defp parse_server(response, driver) do
    Jsonex.decode(response.body)
    |> Dict.get("server")
    |> node_to_server(driver)
  end

  defp parse_servers_list(response, driver) do
    Jsonex.decode(response.body)
    |> Dict.get("servers")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_server(node, driver)] end)
  end

  defp node_to_server(node, driver) do
    Kuraudo.Resource.Instance[
      id: Dict.get(node, "id"),
      name: Dict.get(node, "name"),
      adminPass: Dict.get(node, "adminPass"),
      accessIPv4: Dict.get(node, "accessIPv4"),
      accessIPv6: Dict.get(node, "accessIPv6"),
      addresses: Dict.get(node, "addresses"), # TODO
      metadata: Dict.get(node, "metadata"), # TODO
      status: Dict.get(node, "status") |> to_atom_or_nil,
      created: Dict.get(node, "created") |> get_calendar_date_or_nil,
      updated: Dict.get(node, "updated") |> get_calendar_date_or_nil,
      flavor_id: Dict.get(node, "flavor") |> get_id_or_nil,
      image_id: Dict.get(node, "image") |> get_id_or_nil,
      user_id: Dict.get(node, "user_id"),
      tenant_id: Dict.get(node, "tenant_id"),
      security_groups_id: Dict.get(node, "security_groups") |> get_security_groups_id(driver),
      hostId: Dict.get(node, "hostId")
    ]
  end

  defp get_security_groups_id(nodes, driver) do
    case nodes do
      nil -> nil
      data -> Enum.reduce(data, [], fn(node, list) -> list ++ [Kuraudo.SecurityGroups.search_by_name(driver, Dict.get(node, "name")).id] end)
    end
  end

  defp perform_action(driver, instance, body) do
    url = get_url(driver, :compute, "/servers/#{instance.id}/action")
    header = get_header(driver)

    call(driver, :post, url, header, [], body)
    |> check_os_error
    true
  end
end
