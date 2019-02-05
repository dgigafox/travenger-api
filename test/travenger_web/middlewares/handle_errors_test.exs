defmodule TravengerWeb.Middlewares.HandleErrorsTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset

  alias TravengerWeb.Middlewares.HandleErrors

  @unique_contraint_msg "belongs to pair"
  @invalid_msg "is invalid"

  describe "Handle Error Call receiving Absinthe resolution with changeset error" do
    test "parses and returns changeset errors as list of maps grouped by keys" do
      ch =
        {%{}, %{}}
        |> change()
        |> add_error(:symbol, @invalid_msg)
        |> add_error(:symbol, @unique_contraint_msg)
        |> add_error(:type, @invalid_msg)

      expected = %{
        errors: [
          %{key: :symbol, message: [@unique_contraint_msg, @invalid_msg]},
          %{key: :type, message: [@invalid_msg]}
        ]
      }

      assert HandleErrors.call(%{errors: [ch]}, []) == expected
    end
  end
end
