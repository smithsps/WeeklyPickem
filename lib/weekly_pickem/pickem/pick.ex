defmodule WeeklyPickem.Pickem.Pick do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias WeeklyPickem.Pickem.Pick


  schema "picks" do
    field :user_id, :id
    field :match_id, :id
    field :team_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Pick{} = pick, attrs) do
    pick
    |> cast(attrs, [:user_id, :match_id, :team_id])
    |> validate_required([:user_id, :match_id, :team_id])
  end

  def insert_or_update_pick(user_id, match_id, team_id) do
    with {:ok, match} <- WeeklyPickem.Repo.get(Match, match_id) do

      match_time = Timex.parse!(DateTime.to_iso8601(match.time), "{ISO:Extended}")

      if Timex.after?(Timex.now, match_time) do
        {:error, "Match has already been scheduled to start."}
      end

      if match.team_one != team_id and match.team_two != team_id do
        {:error, "Invalid team id for pick."}
      end

      result = 
        case WeeklyPickem.Repo.get_by(Pick, %{user_id: user_id, match_id: match.id}) do
          nil -> %Pick{}
          old_pick -> old_pick
        end
        |> Pick.changeset( %{
          user_id: user_id, 
          match_id: match.id, 
          team_id: team_id
        })
        |> WeeklyPickem.Repo.insert_or_update

      case result do
        {:ok, pick} -> {:ok, %{team_id: pick.team_id, match_id: pick.match_id}}
        {:error, _changeset} -> {:error, "Error while placing pick into database ;-;"}
      end

    else 
      _ -> {:error, "User is not logged in or invalid match."}
    end
  end
end
