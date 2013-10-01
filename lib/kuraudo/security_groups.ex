defprotocol Kuraudo.SecurityGroups do
  def all(driver)
  def search_by_id(driver, id)
  def search_by_name(driver, name)
  def create(driver, name, description // nil)
  def delete(driver, sg)
  def add_rule(driver, sg, protocol, from_port, to_port, cidr)
  def delete_rule(driver, rule)
end
