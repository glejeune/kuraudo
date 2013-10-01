defrecord Kuraudo.AWS.Driver, 
  name: "AWS",

  access_key_id: nil,
  secret_access_key: nil,
  api_version: "2013-02-01",

  scheme: "https",
  host: "ec2.amazonaws.com",
  path: "/",
  port: nil,

  endpoints: [
    ec2: "https://ec2.amazonaws.com/",
    s3: "https://s3.amazonaws.com/"
  ],

  http_timeout: Kuraudo.default_http_timeout

