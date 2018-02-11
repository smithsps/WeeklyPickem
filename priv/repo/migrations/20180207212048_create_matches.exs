defmodule WeeklyPickem.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :time, :utc_datetime
      add :cutoff, :utc_datetime
      add :team0_id, references(:teams, on_delete: :nothing)
      add :time1_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:matches, [:team0_id])
    create index(:matches, [:time1_id])
  end
end
