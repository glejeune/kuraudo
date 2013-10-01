defprotocol Kuraudo.Flavors do
  @doc """
  Return the list of availables flavors

  ## Example

      flavor_list = Kuraudo.Flavors.all(driver)
  """
  def all(driver)

  @doc """
  Return the informations for the given flavor id

  ## Example

      flavor = Kuraudo.Flavors.search_by_id(driver, "1")
  """
  def search_by_id(driver, id)
end
