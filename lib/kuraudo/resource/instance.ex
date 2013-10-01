defrecord Kuraudo.Resource.Instance,
  id: nil,         # instance ID
  name: nil,       # instance name
  adminPass: nil,  # admin password
  accessIPv4: nil, # IPv4 address
  accessIPv6: nil, # IPv6 address
  addresses: nil,  # list of addresses
  metadata: nil,   # metadata
  status: nil,     # Status
  created: nil,    # Creation date
  updated: nil,    # Last modification date
  flavor_id: nil,  # ID of the flavor used to create the VM
  image_id: nil,   # ID of the image used to create the VM
  user_id: nil,    # User ID (owner)
  tenant_id: nil,  # Tenant ID (Owner)
  security_groups_id: nil, # Liste of attached security groups ID
  hostId: nil
