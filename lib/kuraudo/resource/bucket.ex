defrecord Kuraudo.Resource.Bucket,
  name: nil,  # bucket name
  bytes: nil, # bucket size
  read: [],   # read ACLs
  write: [],  # write ACLs
  objects: [] # List of Object in the bucket

defrecord Kuraudo.Resource.Bucket.Object,
  hash: nil,          # Object hash
  last_modified: nil, # last modification date
  bytes: nil,         # size
  name: nil,          # name
  content_type: nil,  # mime type
  metadatas: []       # Object metadatas
