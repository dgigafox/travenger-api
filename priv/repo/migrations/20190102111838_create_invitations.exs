defmodule Travenger.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add(:status, :integer)
      add(:member_id, references(:members))
      add(:group_id, references(:groups))
      add(:accepted_at, :naive_datetime)
      add(:cancelled_at, :naive_datetime)
      add(:rejected_at, :naive_datetime)
      timestamps()
    end
  end
end
