defmodule WeeklyPickem.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :time, :utc_datetime
      add :cutoff, :utc_datetime
      add :team_one, references(:teams, on_delete: :nothing)
      add :team_two, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:matches, [:team_one])
    create index(:matches, [:team_two])
  end
end
