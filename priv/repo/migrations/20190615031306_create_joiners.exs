defmodule Travenger.Repo.Migrations.CreateJoiners do
  use Ecto.Migration

  def change do
    create table(:joiners) do
      add(:user_id, references(:users))
      timestamps()
    end
  end
end
