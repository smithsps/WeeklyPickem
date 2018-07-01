defmodule WeeklyPickem.Web.Resolvers.MatchResolver do
  alias WeeklyPickem.Esport.Match

  def all_matches(_root, _args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution
    do
      Match.get_all_matches(current_user_id)
    else
      _ -> {:error, "User is not logged in."}
    end
  end
end
  