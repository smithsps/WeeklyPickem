defmodule WeeklyPickemWeb.Middleware.Authentication do

  def call(resolution, %{context: %{current_user: current_user}}) do
    resolution
  end

  def call(resolution, _) do
    resolution
    |> Absinthe.Resolution.put_result({:error, "Unauthenticated"})
  end
end
