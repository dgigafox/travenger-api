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
end
