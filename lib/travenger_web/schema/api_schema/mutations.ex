defmodule TravengerWeb.ApiSchema.Mutations do
  @moduledoc """
  GraphQL fields for client API Mutations
  """

  use Absinthe.Schema.Notation

  alias TravengerWeb.Api.CommunityResolver
  alias TravengerWeb.Middlewares.AuthenticateUser

  object :mutations do
    field :create_group, :group do
      middleware(AuthenticateUser)
      arg(:name, non_null(:string))
      arg(:description, :string)
      arg(:image_url, :string)

      resolve(&CommunityResolver.create_group/2)
    end
  end
end
