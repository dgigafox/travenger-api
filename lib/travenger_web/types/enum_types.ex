defmodule TravengerWeb.EnumTypes do
  @moduledoc """
  GraphQL types for Enums
  """

  use Absinthe.Schema.Notation

  @desc "Invitation statuses"
  enum :invitation_status do
    value(:pending)
    value(:accepted)
    value(:cancelled)
    value(:rejected)
  end

  @desc "Join request statuses"
  enum :join_request_status do
    value(:pending)
    value(:accepted)
    value(:cancelled)
    value(:rejected)
  end
end
