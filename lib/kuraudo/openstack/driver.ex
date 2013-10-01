defrecord Kuraudo.OpenStack.Driver,
  name: "OpenStack",

  username: nil,
  password: nil,
  tenant_name: nil,
  tenant_id: nil,
  auth_method: :password, # :password (default), :key or :rax_kskey

  scheme: nil,
  host: nil,
  path: nil,
  port: nil,

  tenant_enabled: false,
  token_id: nil,
  expires: nil,

  service_catalog: [],

  http_timeout: Kuraudo.default_http_timeout

