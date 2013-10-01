defmodule Kuraudo.Utils.Common do
  @moduledoc false

  def to_b(x) when is_list(x), do: String.from_char_list!(x)
  def to_b(x) when is_binary(x), do: x

  def params_to_string(params) when is_list(params) do
    Enum.reduce(params, [], fn({key, value}, acc) -> 
      acc ++ [CGI.encode("#{key}") <> "=" <> CGI.encode("#{value}")] 
    end) 
    |> Enum.join("&") 
  end

  def format_url(params, url) when is_binary(url) and is_list(params) do
    params_to_string(params)
    |> format_url(url)
  end
  def format_url(params, url) when is_binary(url) and is_binary(params) do
    if String.length(params) > 0 do
      url <> "?" <> params
    else
      url
    end
  end
  def format_url(params, url) when is_binary(url) and nil == params do
    url
  end

  def call(driver, verb, url, header, params // [], body // "") do
    case verb do
      :post -> try do
        HTTPotion.post(format_url(params, url), body, header, [{:timeout, driver.http_timeout}])
      rescue
        exception -> raise Kuraudo.HTTPError, message: "HTTP Request Error: #{exception.message}"
      end
      :get -> try do
        HTTPotion.get(format_url(params, url), header, [{:timeout, driver.http_timeout}])
      rescue
        exception -> raise Kuraudo.HTTPError, message: "HTTP Request Error: #{exception.message}"
      end
      :head -> try do
        HTTPotion.head(format_url(params, url), header, [{:timeout, driver.http_timeout}])
      rescue
        exception -> raise Kuraudo.HTTPError, message: "HTTP Request Error: #{exception.message}"
      end
      :put -> try do
        HTTPotion.put(format_url(params, url), body, header, [{:timeout, driver.http_timeout}])
      rescue
        exception -> raise Kuraudo.HTTPError, message: "HTTP Request Error: #{exception.message}"
      end
      :delete -> try do
        HTTPotion.delete(format_url(params, url), header, [{:timeout, driver.http_timeout}])
      rescue
        exception -> raise Kuraudo.HTTPError, message: "HTTP Request Error: #{exception.message}"
      end
      _ -> raise Kuraudo.HTTPError, message: "Unsupported #{verb}"
    end
  end
end
