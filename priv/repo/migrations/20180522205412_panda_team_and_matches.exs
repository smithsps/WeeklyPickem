defmodule WeeklyPickem.Repo.Migrations.PandaTeamAndMatches do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :panda_id, :string
      add :league, :string
      remove :region
    end

    alter table (:matches) do
      add :panda_id, :string
      add :winner, :id
      remove :cutoff
    end
  end
end
