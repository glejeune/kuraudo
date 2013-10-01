defexception Kuraudo.HTTPError, message: "Unknown HTTP error"
defexception Kuraudo.ProviderError, provider: nil, code: nil, message: "Unknown provider error"
defexception Kuraudo.DriverError, driver: nil, message: "Unsupported driver"
defexception Kuraudo.FileError, driver: nil, message: "IO error"
