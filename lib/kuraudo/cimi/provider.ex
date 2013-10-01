defimpl Kuraudo.Provider, for: Kuraudo.CIMI.Driver do
  import Kuraudo.CIMI

  def connect(driver) do
    url = get_url(driver)
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_cimi_error
    |> parse_entry_points(driver)
  end
  defp parse_entry_points(response, driver) do
    xml = Kuraudo.Utils.Xml.from_string(response.body) 

    entry_point = [
      resourceMetadata: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/resourceMetadata") 
        |> Kuraudo.Utils.Xml.attr("href"),
      machines: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/machines")
        |> Kuraudo.Utils.Xml.attr("href"),
      machineTemplates: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/machineTemplates")
        |> Kuraudo.Utils.Xml.attr("href"),
      machineImages: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/machineImages")
        |> Kuraudo.Utils.Xml.attr("href"),
      credentials: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/credentials")
        |> Kuraudo.Utils.Xml.attr("href"),
      volumes: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/volumes")
        |> Kuraudo.Utils.Xml.attr("href"),
      volumeTemplates: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/volumeTemplates")
        |> Kuraudo.Utils.Xml.attr("href"),
      volumeImages: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/volumeImages")
        |> Kuraudo.Utils.Xml.attr("href"),
      addressTemplates: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/addressTemplates")
        |> Kuraudo.Utils.Xml.attr("href"),
      volumeConfigs: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/volumeConfigs")
        |> Kuraudo.Utils.Xml.attr("href"),
      machineConfigs: Kuraudo.Utils.Xml.first(xml, "/CloudEntryPoint/machineConfigs")
        |> Kuraudo.Utils.Xml.attr("href")
    ]

    driver.entry_point(entry_point)
  end
end
