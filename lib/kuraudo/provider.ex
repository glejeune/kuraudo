defprotocol Kuraudo.Provider do
  @doc """
  Initialize the connection to the provider for the given driver. Return the updated driver

  ## Example
      driver = Kuraudo.AWS.Driver[
        access_key_id: "my_aws_access_key_id", 
        secret_access_key: "myV3rYv3RYs3cr3t4cC3SsK3Y"
      ]
      
      driver = Kuraudo.Provider.connect(driver)
  """
  def connect(driver)
end
