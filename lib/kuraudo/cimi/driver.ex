defrecord Kuraudo.CIMI.Driver,
  name: "CIMI",

  username: nil,
  password: nil,
  auth_method: :basic,

  scheme: nil,
  host: nil,
  path: nil,
  port: nil,

  entry_point: [],

  http_timeout: Kuraudo.default_http_timeout

