defmodule :"Elixir.Travenger.Repo.Migrations.Modify-foreign-key-member-id-in-memberships" do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE memberships DROP CONSTRAINT memberships_member_id_fkey")

    alter table(:memberships) do
      modify(:member_id, references(:members))
    end
  end

  def down do
    execute("ALTER TABLE memberships DROP CONSTRAINT memberships_member_id_fkey")

    alter table(:memberships) do
      modify(:member_id, references(:users))
    end
  end
end
