defimpl Inspect, for: Kuraudo.CIMI.Driver do
  import Inspect.Algebra
  def inspect(dict, _) do
    concat [ dict.name, " @ ", Kuraudo.CIMI.get_url(dict) ]
  end
end
