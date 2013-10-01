defimpl Inspect, for: Kuraudo.OpenStack.Driver do
  import Inspect.Algebra
  def inspect(dict, _) do
    concat [ dict.name, " @ ", Kuraudo.OpenStack.get_url(dict) ]
  end
end
