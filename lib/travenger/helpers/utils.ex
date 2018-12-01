defmodule Travenger.Helpers.Utils do
  @moduledoc """
  Generic helper utility functions
  """

  @doc """
  Converts map string keys to atom keys
  """
  def string_keys_to_atom(map) do
    for {key, val} <- map, into: %{} do
      {to_atom(key), val}
    end
  end

  @doc """
  Converts string to atom
  """
  def to_atom(string) when is_binary(string) do
    String.to_atom(string)
  end
end
