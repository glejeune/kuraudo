defprotocol Kuraudo.Images do
  @doc """
  Return the list of availables images

  ## Example

      driver = Kuraudo.AWS.Provider[
        access_key_id: "my_aws_access_key_id", 
        secret_access_key: "myV3rYv3RYs3cr3t4cC3SsK3Y"
      ]
      driver = Kuraudo.Provider.connect(driver)

      images_list = Kuraudo.Images.all(driver)
  """
  def all(driver)

  @doc """
  Return the informations for the given image id

  ## Example

      driver = Kuraudo.AWS.Provider[
        access_key_id: "my_aws_access_key_id", 
        secret_access_key: "myV3rYv3RYs3cr3t4cC3SsK3Y"
      ]
      driver = Kuraudo.Provider.connect(driver)

      image = Kuraudo.Images.search_by_id(driver, "my_1m4g3_1D")
  """
  def search_by_id(driver, id)

  @doc """
  Create a new image

  * `name` : Name of the image
  * `uri` : URL or file where the data for this image already resides
  * `disk_format` : Disk format of image. Can be `:ami`, `:ari`, `:aki`, `:vhd`, `:vmdk`, `:raw`, `:qcow2`, `:vdi`, or `:iso`.
  
  Availables options are :

  * `id` : ID of image to reserve (default : generated)
  * `container_format` : Container format of image. Can be `:ami`, `:ari`, `:aki`, `:bare`, and `:ovf` (default : `:bare`)
  * `is_public` : boolean (default : true)
  * `is_protected` : boolean (default : false)
  * `properties` : hash

  ## Example

      image = Kuraudo.Images.create(
        driver,
        "Ubuntu 12.04 x86_64", 
        "/path/to/precise-server-cloudimg-amd64-disk1.img",
        :qcow2,
        tags: ["x86_64", "Ubuntu", "12.04"]
      )

  """
  def create(driver, name, file, disk_format, options // [])

  @doc """
  Delete the given image

  ## Example

      Kuraudo.Images.delete(driver, image)
  """
  def delete(driver, image)
end
