defmodule :"Elixir.Travenger.Repo.Migrations.Add-user-reference-in-groups" do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add(:creator_id, references(:users))
    end
  end
end
