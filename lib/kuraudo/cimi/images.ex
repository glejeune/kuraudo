defimpl Kuraudo.Images, for: Kuraudo.CIMI.Driver do
  import Kuraudo.CIMI

  def all(driver) do
    url = get_url(driver, :machineImages)
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_cimi_error
    |> parse_images_list
  end

  def search_by_id(driver, id) do
    url = get_url(driver, :machineImages, "/" <> id)
    header = get_header(driver)

    call(driver, :get, url, header)
    |> check_cimi_error
    |> parse_image
  end

  defp parse_images_list(response) do
    Kuraudo.Utils.Xml.from_string(response.body)
    |> Kuraudo.Utils.Xml.all("/Collection/MachineImage")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_image(node)] end)
  end

  defp parse_image(response) do
    Kuraudo.Utils.Xml.from_string(response.body)
    |> Kuraudo.Utils.Xml.first("/MachineImage")
    |> node_to_image
  end

  defp node_to_image(node) do
    Kuraudo.Resource.Image[
      id: Kuraudo.Utils.Xml.first(node, "/MachineImage/id") 
        |> Kuraudo.Utils.Xml.text 
        |> String.split("/") 
        |> List.last,
      name: Kuraudo.Utils.Xml.first(node, "/MachineImage/name") 
        |> Kuraudo.Utils.Xml.text,
      description: Kuraudo.Utils.Xml.first(node, "/MachineImage/description") 
        |> Kuraudo.Utils.Xml.text,
      location: Kuraudo.Utils.Xml.first(node, "/MachineImage/id") 
        |> Kuraudo.Utils.Xml.text,
      created_at: Kuraudo.Utils.Xml.first(node, "/MachineImage/created") 
        |> Kuraudo.Utils.Xml.text
        |> Calendar.parse,
      status: Kuraudo.Utils.Xml.first(node, "/MachineImage/state") 
        |> Kuraudo.Utils.Xml.text
        |> String.downcase
        |> binary_to_atom,
      type: Kuraudo.Utils.Xml.first(node, "/MachineImage/type") 
        |> Kuraudo.Utils.Xml.text
        |> String.downcase
        |> binary_to_atom,
    ]
  end
end
