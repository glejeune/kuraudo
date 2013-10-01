defimpl Kuraudo.Flavors, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack

  @type os_driver :: Kuraudo.OpenStack.Driver.t
  @type os_flavor :: Kuraudo.Flavors.t

  @spec all(os_driver) :: list(os_flavor)
  def all(driver) do
    url = get_url(driver, :compute, "/flavors/detail")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_flavors_list
  end

  @spec search_by_id(os_driver, String.t) :: os_flavor
  def search_by_id(driver, id) do
    url = get_url(driver, :compute, "/flavors/#{id}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_flavor
  end

  defp parse_flavor(response) do
    Jsonex.decode(response.body)
    |> Dict.get("flavor")
    |> node_to_flavor
  end

  defp parse_flavors_list(response) do
    Jsonex.decode(response.body)
    |> Dict.get("flavors")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_flavor(node)] end)
  end

  defp node_to_flavor(node) do
    Kuraudo.Resource.Flavor[
      id: Dict.get(node, "id"),
      name: Dict.get(node, "name"),
      disk: Dict.get(node, "disk"),
      vcpus: Dict.get(node, "vcpus"),
      ram: Dict.get(node, "ram")
    ]
  end
end
