defmodule Kuraudo.Utils.Data do
  @moduledoc false

  def get_calendar_date_or_nil(data) do
    case data do
      nil -> nil
      data -> Calendar.parse(data)
    end
  end

  def get_or_nil(data, field) do
    case data do
      nil -> nil
      data -> Dict.get(data, field)
    end
  end

  def get_id_or_nil(data) do
    get_or_nil(data, "id")
  end

  def to_atom_or_nil(data) do
    case data do
      nil -> nil
      x -> String.downcase(x) |> binary_to_atom
    end
  end
end
