defmodule KuraudoOpenStackObjectStorageTest do
  use ExUnit.Case
  require Kuraudo.Test.Configuration

  setup_all do
    Kuraudo.start
    Kuraudo.Test.Configuration.load_test_configuration()
  end

  test "object store", env do
    Kuraudo.Test.Configuration.unless_skipe(env, :openstack) do
      driver = Kuraudo.OpenStack.Driver.new(Dict.get(env, :openstack))
      driver = Kuraudo.Provider.connect(driver)

      buckets = Kuraudo.ObjectStore.buckets(driver)
      assert(buckets)

      bucket = Kuraudo.ObjectStore.create_bucket(driver, "test_bucket", [read: ["*", "-.lejeun.es"]])
      assert(bucket)
      assert(length(bucket.objects) == 0)

      bucket = Kuraudo.ObjectStore.upload(driver, bucket, __FILE__, [author: "Greg"])
      assert(length(bucket.objects) == 1)

      Kuraudo.ObjectStore.download(driver, bucket, nil, 
        ["openstack_object_storage_test.exs": "downloaded_from_test_bucket.exs"])
      assert(File.exists?("downloaded_from_test_bucket.exs"))
      File.rm!("downloaded_from_test_bucket.exs")

      bucket = Kuraudo.ObjectStore.delete(driver, bucket, :all)
      assert(length(bucket.objects) == 0)

      assert(Kuraudo.ObjectStore.delete(driver, bucket))

      bucket = Kuraudo.ObjectStore.bucket_by_name(driver, "test_bucket")
      assert(!bucket)
    end
  end
end
