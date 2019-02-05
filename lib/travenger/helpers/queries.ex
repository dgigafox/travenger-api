defmodule Travenger.Helpers.Queries do
  @moduledoc """
  Travenger generic queries
  """

  import Ecto.Query

  def where_id(query, %{id: id}) do
    where(query, [q], q.id == ^id)
  end

  def where_user_id(query, %{user_id: user_id}) do
    where(query, [q], q.user_id == ^user_id)
  end

  def where_group_id(query, %{group_id: gid}) do
    where(query, [q], q.group_id == ^gid)
  end

  def where_role(query, %{role: role}) do
    where(query, [q], q.role == ^role)
  end

  def where_member_user_id(query, %{user_id: uid}) do
    where(query, [q, m], m.user_id == ^uid)
  end

  def join_membership_member(query, _) do
    join(query, :inner, [q], _ in assoc(q, :member))
  end
end
