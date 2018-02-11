defmodule WeeklyPickem.Repo.Migrations.CreatePicks do
  use Ecto.Migration

  def change do
    create table(:picks) do
      add :user_id, references(:users, on_delete: :nothing)
      add :match_id, references(:matches, on_delete: :nothing)
      add :pick_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:picks, [:user_id])
    create index(:picks, [:match_id])
    create index(:picks, [:pick_id])
  end
end
