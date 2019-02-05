defmodule TravengerWeb.ApiSchema do
  @moduledoc """
  GraphQL schema for TravengerWeb client API
  """

  use Absinthe.Schema

  alias __MODULE__
  alias TravengerWeb.Api
  alias TravengerWeb.Middlewares.HandleErrors

  import_types(Absinthe.Plug.Types)

  # root query fields
  import_types(ApiSchema.Queries)
  import_types(ApiSchema.Mutations)

  import_types(Api.CommunityTypes)

  # check for N+1 queries in the resolvers using dataloader
  # https://hexdocs.pm/absinthe/ecto.html#content

  query do
    import_fields(:queries)
  end

  mutation do
    import_fields(:mutations)
  end

  def middleware(middleware, _field, _object) do
    middleware ++ [HandleErrors]
  end
end
