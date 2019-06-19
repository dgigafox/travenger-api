defmodule TravengerWeb.Api.TravelTypes do
  @moduledoc """
  GraphQL types for Accounts context
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Travenger.Repo

  object(:event) do
    field(:id, :id)
    field(:title, :string)
    field(:description, :string)
    field(:organizer, :organizer, resolve: assoc(:organizer))
  end

  object(:event_invitation) do
    field(:id, :id)
    field(:status, :invitation_status)
    field(:accepted_at, :naive_datetime)
    field(:cancelled_at, :naive_datetime)
    field(:rejected_at, :naive_datetime)
    field(:inserted_at, :naive_datetime)
  end

  object(:organizer) do
    field(:id, :id)
    field(:user_id, :integer)
  end
end
