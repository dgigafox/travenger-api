defmodule Travenger.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add(:user_id, references(:users))
      timestamps()
    end
  end
end
