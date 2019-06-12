defmodule Travenger.Repo.Migrations.AddOrganizerToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:organizer_id, references(:organizers))
    end
  end
end
