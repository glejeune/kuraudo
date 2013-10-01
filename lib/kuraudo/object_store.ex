defprotocol Kuraudo.ObjectStore do
  @doc """
  Get all buckets
  """
  def buckets(driver)

  @doc """
  Find a bucket by name
  """
  def bucket_by_name(driver, bucketname)

  @doc """
  Create a new bucket

  ACLs format is :

      [
        read: ["*", "-.example.com", "account1:user", "account2"],  
        write: ["account1:user", "account2"]
      ]

  ## Example :

      bucket = create_bucket(driver, "test", [read: ["*", "tenant:bob"]])
  """
  def create_bucket(driver, bucketname, acls // [])

  @doc """
  Upload a file in the `bucket`

  Metadata format is :

      [key1: "value1", key2: "value2", ...]

  ## Example :

      bucket = upload_object(driver, bucket, "/path/to/file", [author: "Grégoire Lejeune"])
  """
  def upload(driver, bucket, filename, metadata // [])

  @doc """
  Download the entire content of a bucket or specified files

  You specify the list of objects with this format :

      ["object1.ext": nil, "object2.ext": "alternate.ext", ...]

  In this example, `object1.ext` will be saved with the same name, but `object2.ext` will be saved with the name `alternate.ext`

  If `output_path` is `nil`, objects will be saved in the current directory

  ## Example:

      Kuraudo.ObjectStore.download(driver, bucket, "/path/to/output", ["test.txt": "test.txt.save"])
  """
  def download(driver, bucket, output_path, objects // [])

  @doc """
  Delete files or bucket

  For file, you can pass :

  * `:all` : in this case, all files in the bucket are deleted, but not the bucket itself. 
  * an array of filename : in this case, only the files given in the array are deleted, but not the bucket itself, even if it is empty.
  * nothing or an empty array : in this case, the bucket is deleted. (default)
  
  """
  def delete(driver, bucket, files // [])
end
