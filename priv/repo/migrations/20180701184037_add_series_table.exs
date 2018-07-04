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

    execute "
      INSERT INTO series (id, name, tag, start_date, region, inserted_at, updated_at)
      VALUES (1, 'Lifetime', 'lifetime', '1970-01-01 00:00:00', null, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    "

    execute "
      INSERT INTO series (id, name, tag, start_date, region, inserted_at, updated_at)
      VALUES (2, '2018 NA LCS Summer Split', 'na-lcs-summer-2018', '2018-06-16 00:00:00', 'NA', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    "

    alter table("matches") do
      add :series_id, references(:series, on_delete: :nothing)
    end

    create index(:matches, [:series])

    alter table("teams") do
      remove :league
    end
  end
end
