defmodule :"Elixir.Travenger.Repo.Migrations.Modify-foreign-key-creator-id-in-groups" do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE groups DROP CONSTRAINT groups_creator_id_fkey")

    alter table(:groups) do
      modify(:creator_id, references(:members))
    end
  end

  def down do
    execute("ALTER TABLE groups DROP CONSTRAINT groups_creator_id_fkey")

    alter table(:groups) do
      modify(:creator_id, references(:users))
    end
  end
end
