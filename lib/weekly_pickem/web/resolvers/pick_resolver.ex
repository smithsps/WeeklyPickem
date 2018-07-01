defmodule WeeklyPickem.Web.Resolvers.PickResolver do

  alias WeeklyPickem.Pickem.Pick

  def submit_user_pick(_root, args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution do
      Pick.insert_or_update_pick(current_user_id, args.match_id, args.team_id)
    else
      _ -> {:error, "User is not logged in."}
    end
  end
end