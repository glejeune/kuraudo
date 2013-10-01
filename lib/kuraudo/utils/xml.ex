# from https://gist.github.com/sasa1977/5967224

defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl") do
  @recorddoc false
end
defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl") do
  @recorddoc false
end
 
defrecord Kuraudo.Utils.Xml, element: nil do
  @recorddoc false

  def from_string(xml_string, options // [quiet: true]) do
    {doc, []} = 
      xml_string
      |> to_unicode_char_list
      |> :xmerl_scan.string(options)
 
    from_element(doc)
  end
 
  defp from_element(element), do: __MODULE__.new(element: element)
  
  defmacrop empty_node, do: __MODULE__[element: nil]
 
  def all(node, path) do
    lc child_element inlist xpath(node, path) do 
      from_element(child_element)
    end
  end
 
  def first(node, path), do: node |> xpath(path) |> take_one |> from_element
  defp take_one([head | _]), do: head
  defp take_one(_), do: nil
 
  def node_name(empty_node()), do: nil
  def node_name(node), do: elem(node.element, 1)
 
  def attr(node, name), do: node |> xpath('./@#{name}') |> extract_attr
  defp extract_attr([:xmlAttribute[value: value]]), do: to_unicode_binary(value)
  defp extract_attr(_), do: nil
 
  def text(node), do: node |> xpath('./text()') |> extract_text
  defp extract_text([:xmlText[value: value]]), do: to_unicode_binary(value)
  defp extract_text(_), do: nil
  
  defp xpath(empty_node(), _), do: []
  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node.element)
  end
 
  defp to_unicode_binary(list) when is_list(list), do: :unicode.characters_to_binary(list)
  defp to_unicode_binary(any) when is_list(any), do: String.from_char_list!(any)
  defp to_unicode_binary(any), do: any
 
  defp to_unicode_char_list(input) do
    input
    |> to_unicode_binary
    |> to_char_list
  end
end
