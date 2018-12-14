defmodule Travenger.Repo.Migrations.CreateMemberships do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :role, :integer

      timestamps()
    end

  end
end
