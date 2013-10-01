defrecord Kuraudo.Resource.SecurityGroup,
  id: nil,          # Security group ID
  name: nil,        # Security group name
  description: nil, # Security group description
  tenant_id: nil,   # Security group tenant ID
  rules: []         # Security group Rules

defrecord Kuraudo.Resource.SecurityGroup.Rule,
  id: nil,
  security_group_id: nil,
  protocol: nil,
  from_port: nil,
  to_port: nil,
  cidr: nil
