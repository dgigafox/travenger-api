defmodule TravengerWeb.Api.CommunityTypes do
  @moduledoc """
  GraphQL types for Accounts context
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Travenger.Repo

  object(:group) do
    field(:id, :id)
    field(:name, :string)
    field(:description, :string)
    field(:image_url, :string)
  end

  object(:paginated_groups) do
    field(:entries, list_of(:group))
    field(:page_size, :integer)
    field(:page_number, :integer)
    field(:total_entries, :integer)
    field(:total_pages, :integer)
  end

  object(:invitation) do
    field(:id, :id)
    field(:status, :invitation_status)
    field(:accepted_at, :naive_datetime)
    field(:cancelled_at, :naive_datetime)
    field(:rejected_at, :naive_datetime)
    field(:inserted_at, :naive_datetime)
  end
end
