defmodule TravengerWeb.Middlewares.HandleErrors do
  @moduledoc """
  Absinthe Middleware that handles errors returned by resolvers
  """

  @behaviour Absinthe.Middleware

  alias Ecto.Changeset

  def call(resolution, _) do
    with %{errors: [%Changeset{} = ch]} <- resolution do
      Map.put(resolution, :errors, transform_errors(ch))
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {k, v} -> %{key: k, message: v} end)
  end

  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
