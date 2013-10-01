defimpl Kuraudo.Images, for: Kuraudo.AWS.Driver do
  import Kuraudo.AWS

  def all(driver) do
    url = get_url(driver)
    body = get_params(driver, "DescribeImages", [])
    header = get_header(driver, [])

    call(driver, :post, url, header, [], body) 
    |> check_aws_error
    |> parse_images_list
  end

  def search_by_id(driver, id) do
    url = get_url(driver)
    body = get_params(driver, "DescribeImages", [{:"ImageId.0", id}])
    header = get_header(driver, [])

    call(driver, :post, url, header, [], body) 
    |> check_aws_error
    |> parse_images_list
    |> Enum.first
  end

  defp parse_images_list(response) do
    Kuraudo.Utils.Xml.from_string(response.body)
    |> Kuraudo.Utils.Xml.all("/DescribeImagesResponse/imagesSet/item")
    |> Enum.reduce([], fn(node, list) -> list ++ [node_to_image(node)] end)
  end
  defp node_to_image(node) do
    Kuraudo.Resource.Image[
      id: Kuraudo.Utils.Xml.first(node, "/item/imageId")
        |> Kuraudo.Utils.Xml.text,
      name: Kuraudo.Utils.Xml.first(node, "/item/name")
        |> Kuraudo.Utils.Xml.text,
      description: Kuraudo.Utils.Xml.first(node, "/item/description")
        |> Kuraudo.Utils.Xml.text,
      location: Kuraudo.Utils.Xml.first(node, "/item/imageLocation")
        |> Kuraudo.Utils.Xml.text,
      status: Kuraudo.Utils.Xml.first(node, "/item/imageState")
        |> Kuraudo.Utils.Xml.text
        |> binary_to_atom,
      is_public: (Kuraudo.Utils.Xml.first(node, "/item/isPublic")
        |> Kuraudo.Utils.Xml.text) == "true",
      owner_name: Kuraudo.Utils.Xml.first(node, "/item/imageOwnerAlias")
        |> Kuraudo.Utils.Xml.text,
      owner_id: Kuraudo.Utils.Xml.first(node, "/item/imageOwnerId")
        |> Kuraudo.Utils.Xml.text
        |> binary_to_integer,
      type: Kuraudo.Utils.Xml.first(node, "/item/imageType")
        |> Kuraudo.Utils.Xml.text
        |> binary_to_atom,
      hypervisor: Kuraudo.Utils.Xml.first(node, "/item/hypervisor")
        |> Kuraudo.Utils.Xml.text,
      architecture: Kuraudo.Utils.Xml.first(node, "/item/architecture")
        |> Kuraudo.Utils.Xml.text,
      os_family: Kuraudo.Utils.Xml.first(node, "/item/platform")
        |> Kuraudo.Utils.Xml.text
    ]
  end
end
