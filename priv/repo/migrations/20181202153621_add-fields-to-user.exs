defmodule :"Elixir.Travenger.Repo.Migrations.Add-fields-to-user" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:provider, :string)
      add(:name, :string)
      add(:image_url, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:gender, :integer)
    end
  end
end
