defmodule Travenger.Repo.Migrations.CreateEventRegistrations do
  use Ecto.Migration

  def change do
    create table(:event_registrations) do
      add(:status, :integer)
      add(:participant_id, references(:joiners))
      add(:event_id, references(:events))

      timestamps()
    end
  end
end
