# Kuraudo (クラウド)

Kuraudo is a multi-cloud framework for [Elixir](http://elixir-lang.org).

> This is a _work in progress_, thus I can change/break/remove any parts at anytime. So **don't use this code** or only to play with it. 
>
> At this time, we only support OpenStack Grizzly
>
> **You have been warned !**

## Synopsis

    # start Kuraudo
    Kuraudo.start
    
    # create a driver for Amazon
    driver = Kuraudo.AWS.Driver[
        access_key_id: 'accesskey', 
        secret_access_key: 'secretkey'
    ] 
    
    # Initialize the connection to the provider
    driver = Kuraudo.Provider.connect(driver)

## Drivers

### Amazon

* `access_key_id` : Amazon access key ID (needed)
* `secret_access_key` : Amazon secret access key (needed)
* `api_version` : Amazon API version (default : "2013-02-01")
* `scheme` : Connection scheme (default : "https")
* `host` : Connection host (default : "ec2.amazonaws.com")
* `path` : Connection path (default : "/")
* `port` : Connection port (default : `nil`)
* `http_timeout` : HTTP timeout (ms) (default : 60000)

### OpenStack

* `username` : OpenStack user name (needed)
* `password` : OpenStack password (needed)
* `tenant_id` || `tenant_name` : OpenStack tenant ID or name (needed)
* `auth_method` : Type of authentication (:password, :key, :rax_kskey) (default : :password)
* `scheme` : Connection scheme (needed)
* `host` : Connection host (needed)
* `path` : Connection path (needed)
* `port` : Connection port (needed)
* `http_timeout` : HTTP timeout (ms) (default : 60000)

### CIMI

* `username` : User name (needed)
* `password` : Password (needed)
* `auth_method` : Authentification method (default : `:basic`)
* `scheme` : Connection scheme (needed)
* `host` : Connection host (needed)
* `path` : Connection path (needed)
* `port` : Connection port (needed)
* `http_timeout` : HTTP timeout (ms) (default : 60000)

## APIs

### Provider

* `Kuraudo.Provider.connect` : Initialize the connection to the provider for the given driver. Return the updated driver (OS, AWS, CIMI)

### Images

* `Kuraudo.Images.all(driver)` : Return the list of all availables images (OS, AWS, CIMI)
* `Kuraudo.Images.search_by_id(driver, id)` : Return the informations for the given image ID (OS, AWS, CIMI)
* `Kuraudo.Images.delete(driver, image)` : 
* `Kuraudo.Images.create(driver, name, uri, format, options // [])` : 

### Flavors

* `Kuraudo.Flavors.all(driver)` : Return the list of all availables flavors (OS) (TODO: AWS, CIMI)
* `Kuraudo.Flavors.search_by_id(driver, id)` : Return the informations for the given flavor ID (OS) (TODO: AWS, CIMI)

### SecurityGroups

* `Kuraudo.SecurityGroups.all(driver)` : List all security groups (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.search_by_id(driver, id)` : Return the informations for the given security group ID. (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.search_by_name(driver, name)` : Return the informations for the given security group name. (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.create(driver, name, description)` : Create a new security group. (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.delete(driver, sg)` : Delete the given security group. (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.add_rule(driver, sg, protocol, from_port, to_port, cidr)` : Add a rule to a security group. (OS) (TODO: AWS, CIMI)
* `Kuraudo.SecurityGroups.delete_rule(driver, rule)` : Delete a rule. (OS) (TODO: AWS, CIMI)

### ObjectStorage

* `Kuraudo.ObjectStore.buckets(driver)` : (OS) (TODO: AWS, CIMI)
* `Kuraudo.ObjectStore.bucket_by_name(driver, bucketname)` : (OS) (TODO: AWS, CIMI)
* `Kuraudo.ObjectStore.create_bucket(driver, bucketname, acls // [])` : (OS) (TODO: AWS, CIMI)
* `Kuraudo.ObjectStore.upload(driver, bucket, filename, metadata // [])` : (OS) (TODO: AWS, CIMI)
* `Kuraudo.ObjectStore.download(driver, bucket, output_path, objects // [])` : (OS) (TODO: AWS, CIMI)
* `Kuraudo.ObjectStore.delete(driver, bucket, files // [])` : (OS) (TODO: AWS, CIMI)

### Instances

* `Kuraudo.Instances.all(driver)` : Return the list of all availables instances (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.search_by_id(driver, id)` : Return the informations for the given instance ID (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.reboot(driver, instance, type)` : Reboot the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.update(driver, instance, options)` : Update the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.delete(driver, instance)` : Delete the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.create(driver, name, flavor, image, options)` : Create a new instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.wait(driver, instance, status)` : Wait while the instance is not in the given status (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.pause(driver, instance)` : Pause the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.unpause(driver, instance)` : Unpause the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.suspend(driver, instance)` : Suspend the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.resume(driver, instance)` : Resume the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.start(driver, instance)` : Start the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.stop(driver, instance)` : Stop the given instance (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.add_security_group(driver, instance, sg)` : Add a security group to an instance. (OS) (TODO: AWS, CIMI)
* `Kuraudo.Instances.remove_security_group(driver, instance, sg)` : Remove a security group from an instance. (OS) (TODO: AWS, CIMI)

### Network

### Volumes

## TODO

* Too many things...

## Licence

Copyright (c) 2013, Gregoire Lejeune All rights reserved. Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the University of California, Berkeley nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
