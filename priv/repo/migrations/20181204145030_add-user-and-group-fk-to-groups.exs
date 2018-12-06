defmodule :"Elixir.Travenger.Repo.Migrations.Add-user-and-group-fk-to-groups" do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add(:member_id, references(:users))
      add(:group_id, references(:groups))
    end
  end
end
