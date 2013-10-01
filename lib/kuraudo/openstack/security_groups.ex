defimpl Kuraudo.SecurityGroups, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack
  import Kuraudo.Utils.Data

  def all(driver) do
    url = get_url(driver, :compute, "/os-security-groups")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_security_group_list
  end

  def search_by_id(driver, id) do
    url = get_url(driver, :compute, "/os-security-groups/#{id}")
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_os_error
    |> parse_security_group
  end

  def search_by_name(driver, name) do
    Enum.find(all(driver), fn(sg) -> sg.name == name end)
  end

  def create(driver, name, description // nil) do
    url = get_url(driver, :compute, "/os-security-groups")
    header = get_header(driver)
    body = Jsonex.encode [security_group: [name: name, description: description||name]]

    call(driver, :post, url, header, [], body)
    |> check_os_error
    |> parse_security_group
  end

  def delete(driver, sg) do
    url = get_url(driver, :compute, "/os-security-groups/#{sg.id}")
    header = get_header(driver)

    call(driver, :delete, url, header)
    |> check_os_error
    true
  end

  def add_rule(driver, sg, protocol, from_port, to_port, cidr) do
    url = get_url(driver, :compute, "/os-security-group-rules")
    header = get_header(driver)
    body = Jsonex.encode [
      security_group_rule: [
        ip_protocol: protocol, 
        from_port: from_port, 
        to_port: to_port, 
        parent_group_id: sg.id, 
        cidr: cidr
      ]
    ]

    call(driver, :post, url, header, [], body)
    |> check_os_error

    search_by_id(driver, sg.id)
  end

  def delete_rule(driver, rule) do
    url = get_url(driver, :compute, "/os-security-group-rules/#{rule.id}")
    header = get_header(driver)

    call(driver, :delete, url, header)
    |> check_os_error

    search_by_id(driver, rule.security_group_id)
  end

  defp parse_security_group(response) do
    Jsonex.decode(response.body)
    |> Dict.get("security_group")
    |> node_to_security_group
  end

  defp parse_security_group_list(response) do
    Jsonex.decode(response.body)
    |> Dict.get("security_groups")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_security_group(node)] end)
  end

  defp node_to_security_group(node) do
    Kuraudo.Resource.SecurityGroup[
      id: Dict.get(node, "id"),
      name: Dict.get(node, "name"),
      description: Dict.get(node, "description"),
      tenant_id: Dict.get(node, "tenant_id"),
      rules: Dict.get(node, "rules") |> Enum.reduce([], fn(node, list) -> list ++ [node_to_rule(node)] end)
    ]
  end

  defp node_to_rule(node) do
    Kuraudo.Resource.SecurityGroup.Rule[
      id: Dict.get(node, "id"),
      security_group_id: Dict.get(node, "parent_group_id"),
      protocol: Dict.get(node, "ip_protocol"),
      from_port: Dict.get(node, "from_port"),
      to_port: Dict.get(node, "to_port"),
      cidr: Dict.get(node, "ip_range") |> get_or_nil("cidr")
    ]
  end
end
