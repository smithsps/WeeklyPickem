defmodule WeeklyPickem.Repo.Migrations.AddSeriesTable do
  use Ecto.Migration

  def change do
    create table("series") do
      add :name, :string
      add :tag, :string
      add :start_date, :utc_datetime
      add :region, :string

      timestamps()
    end

    alter table("matches") do
      add :series_id, references(:series, on_delete: :nothing)
    end

    create index(:matches, [:series])

    alter table("teams") do
      remove :league
    end
  end
end
