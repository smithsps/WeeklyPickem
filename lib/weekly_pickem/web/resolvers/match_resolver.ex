defmodule WeeklyPickem.Web.Resolvers.MatchResolver do
  alias WeeklyPickem.Esport.Series

  def get_series(_root, args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution
    do
      Series.get_series(current_user_id, args.series_tag)
    else
      _ -> {:error, "User is not logged in."}
    end
  end
end
  