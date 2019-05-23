defmodule :"Elixir.Travenger.Repo.Migrations.Add-join-request-action-timestamps" do
  use Ecto.Migration

  def change do
    alter table(:join_requests) do
      add(:accepted_at, :naive_datetime)
      add(:cancelled_at, :naive_datetime)
      add(:rejected_at, :naive_datetime)
    end
  end
end
