defmodule :"Elixir.Travenger.Repo.Migrations.Create-join-requests" do
  use Ecto.Migration

  def change do
    create table(:join_requests) do
      add(:status, :integer)
      add(:requester_id, references(:members))
      add(:group_id, references(:groups))

      timestamps()
    end
  end
end
