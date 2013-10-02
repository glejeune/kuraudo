defmodule Kuraudo.OpenStack do
  @moduledoc false

  defdelegate [
    call(driver, verb, url, header, params, body),
    call(driver, verb, url, header, params),
    call(driver, verb, url, header)
  ], to: Kuraudo.Utils.Common

  def get_header(driver, header // []) do
    case driver.token_id do
      nil -> []
      id -> [
        {:"X-Auth-Token", id},
        {:"X-Storage-Token", id},
        {:"X-Auth-Project-Id", driver.tenant_name}
      ]
    end ++ Dict.merge([
      {:"User-Agent", "Kuraudo/#{driver.name}/#{Kuraudo.version} (Elixir #{System.version})"},
      {:"Connection", "Keep-Alive"},
      {:"Accept", "application/json"},
      {:"Content-Type", "application/json"}
    ], header)
  end

  defp raise_os(response) do
    if Dict.get(response.headers, :"Content-Type") =~ %r"application/json.*" do
      response_dict = Jsonex.decode(response.body)
      code = (
        Dict.get(response_dict, "error") || Dict.get(response_dict, "conflictingRequest")
      ) |> Dict.get("code")
      message = (
        Dict.get(response_dict, "error") || Dict.get(response_dict, "conflictingRequest")
      ) |> Dict.get("message")
      raise Kuraudo.ProviderError, provider: "OpenStack", code: code, message: message 
    else
      raise Kuraudo.ProviderError, provider: "OpenStack", code: response.status_code, message: response.body
    end
  end

  def check_os_error(response) do
    case response.status_code do
      200 -> response
      201 -> response
      202 -> response
      204 -> response
      403 -> raise_os(response)
      400 -> raise_os(response)
      401 -> raise_os(response)
      404 -> raise Kuraudo.HTTPError, message: "Invalide URL"
      409 -> raise_os(response)
      _ -> raise Kuraudo.HTTPError, message: "HTTP ERROR ##{response.status_code}"
    end
  end

  def get_url(driver, endpoint // :identity, path // "") do
    case endpoint do
      :identity -> driver.auth_url
      ep -> case Dict.get(driver.service_catalog, "#{ep}") do
        nil -> raise Kuraudo.ProviderError, provider: driver.name, code: 0, message: "Can't find #{endpoint} URL in catalog"
        url -> url
      end
    end <> path
  end
end
