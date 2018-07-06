defmodule WeeklyPickem.Repo.Migrations.AddStats do
  use Ecto.Migration

  def change do
    create table("team_stats") do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :series_id, references(:series, on_delete: :nothing)
      add :wins, :integer
      add :total, :integer

      timestamps()
    end

    create table("pick_stats") do
      add :user_id, references(:users, on_delete: :delete_all)
      add :series_id, references(:series, on_delete: :nothing)
      add :correct, :integer
      add :total, :integer

      timestamps()
    end


    execute "
      INSERT INTO team_stats (team_id, series_id, wins, total, inserted_at, updated_at) 
      SELECT wins.team as team_id, 2 as series_id, wins, total, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP 
      FROM
        (SELECT winner as team, COUNT(*) as wins FROM matches WHERE winner IS NOT null GROUP BY (series_id, winner)) wins
        JOIN
        (SELECT total.team_id as team, COUNT(*) as total
          FROM (
            SELECT team_one as team_id from matches WHERE winner IS NOT null
            UNION ALL
            SELECT team_two as team_id from matches WHERE winner IS NOT null
          ) total
        GROUP BY total.team_id
      ) total
      ON wins.team = total.team
    "

    execute "
      INSERT INTO pick_stats (user_id, series_id, correct, total, inserted_at, updated_at)
      SELECT user_id, 2 as series_id, COUNT(CASE WHEN winner = team_id THEN 1 ELSE null END) as correct, COUNT(*) as total, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM 
      (
        SELECT user_id, match_id, matches.winner, team_id FROM picks
        JOIN (
          SELECT id, winner FROM matches WHERE winner IS NOT null 
        ) matches
        ON match_id = matches.id
      ) picks
      GROUP BY user_id
    "

    execute "
      UPDATE teams SET name = 'Team SoloMid' WHERE acronym = 'TSM'
    "
  end
end
