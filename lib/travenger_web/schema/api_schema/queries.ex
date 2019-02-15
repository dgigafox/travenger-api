defmodule TravengerWeb.ApiSchema.Queries do
  @moduledoc """
  GraphQL fields for client API Queries
  """

  use Absinthe.Schema.Notation

  alias Travenger.Community
  alias TravengerWeb.Api.CommunityResolver

  object :queries do
    field :groups, :paginated_groups do
      arg(:user_id, :id)
      arg(:page, :integer)
      arg(:page_size, :integer)

      resolve(&CommunityResolver.list_groups/2)
    end

    field :group, :group do
      arg(:id, non_null(:id))

      resolve(fn params, _ ->
        {:ok, Community.get_group(params.id)}
      end)
    end
  end
end
