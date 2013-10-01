defimpl Kuraudo.Provider, for: Kuraudo.OpenStack.Driver do
  import Kuraudo.OpenStack

  def connect(driver) do
    url = get_url(driver, :identity, "/tokens")

    header = get_header(driver)

    tenant = if driver.tenant_id do
      [tenantId: driver.tenant_id]
    else
      [tenantName: driver.tenant_name || driver.username]
    end

    body = case driver.auth_method do
      :password -> [
        auth: tenant ++ [
          passwordCredentials: [
            username: driver.username, 
            password: driver.password
          ]
        ]
      ]
      :key -> [
        auth: tenant ++ [
          apiAccessKeyCredentials: [
            accessKey: driver.username,
            secretKey: driver.password
          ]
        ]
      ]
      :rax_kskey -> [
        auth: [
          "RAX-KSKEY:apiKeyCredentials": [
            username: driver.username,
            apiKey: driver.password
          ]
        ]
      ]
      _ -> raise Kuraudo.DriverError, driver: "OpenStack", message: "Unrecognized auth method #{driver.auth_method}"
    end |> Jsonex.encode

    call(driver, :post, url, header, [], body)
    |> check_os_error
    |> parse_connect(driver)
  end
  defp parse_connect(response, driver) do
    response_dict = Jsonex.decode(response.body)
    expires = Dict.get(response_dict, "access") |> Dict.get("token") |> Dict.get("expires")
    token_id = Dict.get(response_dict, "access") |> Dict.get("token") |> Dict.get("id")
    tenant_enabled = Dict.get(response_dict, "access") |> Dict.get("token") |> Dict.get("tenant") |> Dict.get("enabled")
    tenant_id = Dict.get(response_dict, "access") |> Dict.get("token") |> Dict.get("tenant") |> Dict.get("id")
    tenant_name = Dict.get(response_dict, "access") |> Dict.get("token") |> Dict.get("tenant") |> Dict.get("name")

    service_catalog = Dict.get(response_dict, "access") |> Dict.get("serviceCatalog")

    catalog = Enum.reduce service_catalog, [], fn(endpoint, acc) ->
      url = Dict.get(endpoint, "endpoints") |> Enum.first |> Dict.get("publicURL")
      name = Dict.get(endpoint, "type")
      acc ++ [{name, url}]
    end

    driver.tenant_id(tenant_id).tenant_name(tenant_name).tenant_enabled(tenant_enabled).token_id(token_id).expires(expires).service_catalog(catalog)
  end
end
