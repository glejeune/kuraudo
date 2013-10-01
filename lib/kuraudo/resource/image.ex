defrecord Kuraudo.Resource.Image,
  id: nil,                 # image ID
  status: nil,             # image state
  name: nil,               # image name
  properties: [],          # hash of custom properties
  container_format: nil,   # container format
  created_at: nil,         # Calendar.Datetime 
  disk_format: nil,        # disk format
  updated_at: nil,         # Calendar.Datetime
  is_public: true,         # true or false
  is_protected: false,     # true or false
  min_disk: 0,             # 
  size: nil,               # image size
  min_ram: 0,              # ---
  description: nil,        # image description
  location: nil,           # image location
  owner_name: nil,         # owner name
  owner_id: nil,           # owner ID
  checksum: nil,           # image checksum
  type: :image,            # :image or :snapshot
  hypervisor: nil,         # hypervisor name
  architecture: nil,       # Image architecture
  os_family: nil           # :windows, :linux, ...
