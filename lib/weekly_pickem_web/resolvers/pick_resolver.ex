defmodule WeeklyPickemWeb.Resolvers.PickResolver do

  use Timex

  alias WeeklyPickem.Model.Pick
  alias WeeklyPickem.Model.Match

  def submit_user_pick(_root, args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution,
         match <- WeeklyPickem.Repo.get(Match, args.match_id)
    do
      match_time = Timex.parse!(DateTime.to_iso8601(match.time), "{ISO:Extended}")

      if Timex.before?(Timex.now, match_time) do
        if true do
          
          result = 
            case WeeklyPickem.Repo.get_by(Pick, 
              %{user_id: current_user_id, match_id: match.id}
            )
            do
              nil -> %Pick{}
              old_pick -> old_pick
            end
            |> Pick.changeset( %{
              user_id: current_user_id, 
              match_id: match.id, 
              team_id: args.team_id
            })
            |> WeeklyPickem.Repo.insert_or_update

          case result do
            {:ok, pick} -> {:ok, %{team_id: pick.team_id, match_id: pick.match_id}}
            {:error, _changeset} -> {:error, "Error while placing pick into database ;-;"}
          end

        else 
          {:error, "Invalid team id for pick."}
        end

      else 
        {:error, "Match has already been scheduled to start."}
      end

    else
      #{:error, _} -> {:error, "Invalid match for pick."}
      _ -> {:error, "User is not logged in or invalid match."}
    end
  end


end