defprotocol Kuraudo.Instances do
  @doc """
  Return the list of availables instances

  ## Example

      instance_list = Kuraudo.Instances.all(driver)
  """
  def all(driver)

  @doc """
  Return the informations for the given instance id

  ## Example

      instance = Kuraudo.Instances.search_by_id(driver, "aa-bb-cc")
  """
  def search_by_id(driver, id)

  @doc """
  Wait while the instance is not in the given status
  """
  def wait(driver, instance, status // :active)

  @doc """
  Reboot the given instance. `type` can be `:soft` (default) or `:hard`

  ## Example

      instance = Kuraudo.Instances.search_by_id(driver, "aa-bb-cc")
      Kuraudo.Instances.reboot(driver, instance, :soft)
  """
  def reboot(driver, instance, type // :soft)

  @doc """
  Update parameters for an instance

  Availables parameters are `name` and `adminPass`

  ## Example 

      instance = Kuraudo.Instances.search_by_id(driver, "aa-bb-cc")
      instance = Kuraudo.Instances.update(driver, instance, name: "new_name", adminPass: "s3cr3t")
  """
  def update(driver, instance, options)

  @doc """
  Create a new instance.

  ## Example

      image = Kuraudo.Images.search_by_id(driver, "my_1m4g3_1D")
      flavor = Kuraudo.Flavors.search_by_id(driver, "1")

      instance = Kuraudo.Instances.create(driver, "vm_name", flavor, image)
  """
  def create(driver, name, flavor, image, options // [])

  @doc """
  Pause the given instance
  """
  def pause(driver, instance)

  @doc """
  Unpause the given instance
  """
  def unpause(driver, instance)

  @doc """
  Suspend the given instance
  """
  def suspend(driver, instance)

  @doc """
  Resume the given instance
  """
  def resume(driver, instance)

  @doc """
  Start the given instance
  """
  def start(driver, instance)

  @doc """
  Stop the given instance
  """
  def stop(driver, instance)

  @doc """
  Delete the given instance
  """
  def delete(driver, instance)

  @doc """
  Add a security group to an instance

  ## Example 

      sg = Kuraudo.SecurityGroups.search_by_id(driver, 123)
      instance = Kuraudo.Instances.search_by_id(driver, 456)
      Kuraudo.Instances.add_security_group(driver, instance, sg)
  """
  def add_security_group(driver, instance, sg)

  @doc """
  Remove a Security Group from a server.

  ## Example 

      sg = Kuraudo.SecurityGroups.search_by_id(driver, 123)
      instance = Kuraudo.Instances.search_by_id(driver, 456)
      Kuraudo.Instances.remove_security_group(driver, instance, sg)
  """
  def remove_security_group(driver, instance, sg)
end
