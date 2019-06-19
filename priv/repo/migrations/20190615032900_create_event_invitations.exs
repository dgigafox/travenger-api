defmodule Travenger.Repo.Migrations.CreateEventInvitations do
  use Ecto.Migration

  def change do
    create table(:event_invitations) do
      add(:status, :integer)
      add(:event_id, references(:events))
      add(:joiner_id, references(:joiners))
      add(:accepted_at, :naive_datetime)
      add(:cancelled_at, :naive_datetime)
      add(:rejected_at, :naive_datetime)
      timestamps()
    end
  end
end
