defmodule Travenger.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:title, :string)
      add(:description, :string)
      add(:start_date, :naive_datetime)
      add(:end_date, :naive_datetime)
      add(:status, :integer)

      timestamps()
    end
  end
end
