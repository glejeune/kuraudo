defmodule Kuraudo.CIMI do
  @moduledoc false

  import Kuraudo.Utils.Common
  defdelegate [
    call(driver, verb, url, header, params, body),
    call(driver, verb, url, header, params),
    call(driver, verb, url, header)
  ], to: Kuraudo.Utils.Common

  def get_header(driver, headers // []) do
    case driver.auth_method do
      :basic -> [ 
        {:"Authorization", "Basic " <> to_b(Base64.encode(to_b(driver.username) <> ":" <> to_b(driver.password)))} 
      ] 
      _ -> raise "TODO"
    end ++ [
      {:"User-Agent", "Kuraudo/#{driver.name}/#{Kuraudo.version} (Elixir #{System.version})"},
      {:"Accept", "application/xml"}
    ] ++ headers
  end

  defp raise_cimi(response) do
    xml = Kuraudo.Utils.Xml.from_string(response.body)
    code = Kuraudo.Utils.Xml.first(xml, "/error/code") 
      |> Kuraudo.Utils.Xml.text
    message = Kuraudo.Utils.Xml.first(xml, "/error/message") 
      |> Kuraudo.Utils.Xml.text
    provider = Kuraudo.Utils.Xml.first(xml, "/error/backend") 
      |> Kuraudo.Utils.Xml.attr("driver")

    raise Kuraudo.ProviderError, provider: "CIMI|#{provider}", code: code, message: message
  end

  def check_cimi_error(response) do
    case response.status_code do
      200 -> response
      202 -> response
      403 -> raise_cimi(response)
      400 -> raise_cimi(response)
      401 -> raise_cimi(response)
      404 -> raise Kuraudo.HTTPError, message: "Invalide URL"
      _ -> raise Kuraudo.HTTPError, message: "HTTP ERROR ##{response.status_code}"
    end
  end

  def get_url(driver, entrypoint // :root, path // "") do
    case entrypoint do
      :root -> case driver.port do
        nil -> "#{driver.scheme}://#{driver.host}#{driver.path}"
        _ -> "#{driver.scheme}://#{driver.host}:#{driver.port}#{driver.path}"
      end
      ep -> case Dict.get(driver.entry_point, ep) do
        nil -> raise Kuraudo.ProviderError, provider: driver.name, code: 0, message: "Can't find machineImages entry point"
        url -> url
      end
    end <> path
  end

end
