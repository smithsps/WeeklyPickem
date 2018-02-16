defmodule WeeklyPickem.Repo.Migrations.TeamAcronymRegion do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :acronym, :string
      add :region, :string
    end
  end
end
