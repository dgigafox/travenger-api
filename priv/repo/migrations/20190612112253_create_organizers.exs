defmodule Travenger.Repo.Migrations.CreateOrganizers do
  use Ecto.Migration

  def change do
    create table(:organizers) do
      add(:user_id, references(:users))
      timestamps()
    end
  end
end
