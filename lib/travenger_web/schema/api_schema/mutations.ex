defmodule TravengerWeb.ApiSchema.Mutations do
  @moduledoc """
  GraphQL fields for client API Mutations
  """

  use Absinthe.Schema.Notation

  alias TravengerWeb.Api.CommunityResolver
  alias TravengerWeb.Middlewares.AuthenticateUser
  alias TravengerWeb.Middlewares.RequireGroupAdmin

  object :mutations do
    field :create_group, :group do
      middleware(AuthenticateUser)
      arg(:name, non_null(:string))
      arg(:description, :string)
      arg(:image_url, :string)

      resolve(&CommunityResolver.create_group/2)
    end

    field :invite_to_group, :invitation do
      middleware(AuthenticateUser)
      middleware(RequireGroupAdmin)
      arg(:user_id, non_null(:id))
      arg(:group_id, non_null(:id))

      resolve(&CommunityResolver.invite/2)
    end

    field :update_group, :group do
      middleware(AuthenticateUser)
      middleware(RequireGroupAdmin)
      arg(:group_id, non_null(:id))
      arg(:name, :string)
      arg(:description, :string)
      arg(:image_url, :string)

      resolve(&CommunityResolver.update_group/2)
    end

    field :join_group, :join_request do
      middleware(AuthenticateUser)
      arg(:group_id, non_null(:id))

      resolve(&CommunityResolver.join_group/2)
    end

    field :accept_group_invitation, :invitation do
      middleware(AuthenticateUser)
      arg(:invitation_id, non_null(:id))

      resolve(&CommunityResolver.accept_group_invitation/2)
    end
  end
end
