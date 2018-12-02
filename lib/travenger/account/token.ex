defmodule Travenger.Account.Token do
  @moduledoc """
  Functions for generating and decoding tokens
  """

  import Travenger.Account.Guardian

  alias Travenger.Account.User

  # token's default time-to-live
  @ttl {30, :days}

  @doc """
  Generates a User authorization token
  """
  def generate_auth_token(%User{} = user) do
    encode_resource(user, %{auth: 1})
  end

  # Private Functions
  defp encode_resource(resource, type, ttl \\ @ttl) do
    resource
    |> encode_and_sign(type, ttl: ttl)
    |> encode_resource()
  end

  defp encode_resource({:ok, token, _claims}), do: {:ok, token}
  defp encode_resource(_), do: {:error, "Error encoding resource"}
end
