defmodule Kuraudo.AWS do
  @moduledoc false

  import Kuraudo.Utils.Common
  defdelegate [
    call(driver, verb, url, header, params, body),
    call(driver, verb, url, header, params),
    call(driver, verb, url, header)
  ], to: Kuraudo.Utils.Common

  defp get_aws_auth_param(params, driver) do
    canonical = canonical_string(params, driver.host, 'POST', driver.path)
    aws_encode(driver.secret_access_key, canonical)
  end

  defp canonical_string(params, host, method, base) do
    sorted_params = Enum.sort(params, fn({k1, _}, {k2, _}) -> k1 < k2 end)
    sigquery = Enum.join(Enum.reduce(sorted_params, [], fn({k, v}, acc) -> acc ++ ["#{CGI.encode(atom_to_list(k))}=#{CGI.encode(bitstring_to_list(v))}"] end), "&") 
    "#{method}\n#{host}\n#{base}\n#{sigquery}"
  end

  defp aws_encode(aws_secret_access_key, str) do
    Digest.hmac(:sha256, aws_secret_access_key, str) |> Base64.encode |> list_to_bitstring |> URI.encode
  end

  def get_params(driver, action, params) do
    params = Dict.merge([
        "Action": to_b(action),
        "Version": to_b(driver.api_version),
        "SignatureVersion": "2",
        "SignatureMethod": "HmacSHA256",
        "AWSAccessKeyId": to_b(driver.access_key_id),
        "Timestamp": Calendar.strftime("%FT%TZ", Calendar.now())
      ], params)

    sig = get_aws_auth_param(params, driver)

    params_to_string(params) <> "&Signature=#{sig}"
  end

  def get_header(driver, header) do
    Dict.merge([
      {:"User-Agent", "Kuraudo/#{driver.name}/#{Kuraudo.version} (Elixir #{System.version}) "},
      {:"Content-Type", "application/x-www-form-urlencoded"}
    ], header)
  end

  defp raise_aws(response) do
    code = Kuraudo.Utils.Xml.from_string(response.body) 
      |> Kuraudo.Utils.Xml.first("//Code") 
      |> Kuraudo.Utils.Xml.text
    message = Kuraudo.Utils.Xml.from_string(response.body) 
      |> Kuraudo.Utils.Xml.first("//Message") 
      |> Kuraudo.Utils.Xml.text
    raise Kuraudo.ProviderError, provider: "AWS", code: code, message: message 
  end

  def check_aws_error(response) do
    case response.status_code do
      200 -> response
      403 -> raise_aws(response)
      400 -> raise_aws(response)
      401 -> raise_aws(response)
      404 -> raise Kuraudo.HTTPError, message: "Invalide URL"
      _ -> raise Kuraudo.HTTPError, message: "HTTP ERROR ##{response.status_code}"
    end
  end

  def get_url(driver, path // "") do
    case driver.port do
      nil -> "#{driver.scheme}://#{driver.host}#{driver.path}"
      _ -> "#{driver.scheme}://#{driver.host}:#{driver.port}#{driver.path}"
    end <> path
  end
end
