defmodule TravengerWeb.ApiSchema.Queries do
  @moduledoc """
  GraphQL fields for client API Queries
  """

  use Absinthe.Schema.Notation

  alias TravengerWeb.Api.CommunityResolver

  object :queries do
    field :groups, :paginated_groups do
      arg(:user_id, :id)
      arg(:page, :integer)
      arg(:page_size, :integer)

      resolve(&CommunityResolver.list_groups/2)
    end
  end
end
