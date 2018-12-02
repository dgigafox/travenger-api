defmodule Travenger.Account.Guardian do
  @moduledoc """
  Generates and validates token
  """
  use Guardian, otp_app: :travenger

  alias Travenger.Account.User

  @auth_token_attrs ~w(id)a

  @doc """
  Generates authorization token for User
  """
  def subject_for_token(%User{} = user, %{"auth" => 1}) do
    {:ok, Map.take(user, @auth_token_attrs)}
  end
end
