defmodule Travenger.Helpers.Validators do
  @moduledoc """
  Generic validators for changeset
  """
  import Ecto.Changeset

  @doc """
  Checks if the status is valid based on the defined collection
  """
  def validate_status(%{data: %{status: s}} = ch, valid) when is_list(valid) do
    case s in valid do
      true -> ch
      _ -> add_error(ch, :status, "is already #{s}")
    end
  end
end
