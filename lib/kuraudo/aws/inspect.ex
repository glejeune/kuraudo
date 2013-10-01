defimpl Inspect, for: Kuraudo.AWS.Driver do
  import Inspect.Algebra
  def inspect(dict, _) do
    concat [ dict.name, " version ", dict.api_version, " @ ", Kuraudo.AWS.get_url(dict) ]
  end
end

