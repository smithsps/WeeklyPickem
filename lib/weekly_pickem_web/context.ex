defmodule WeeklyPickemWeb.Context do
  @moduledoc false

  #@behavior Plug

  import Plug.Conn
  import Ecto.Query, only: [where: 2]

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Model.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  @doc """
  Return the current user context from auth header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    User
    |> where(token: ^token)
    |> Repo.one
    |> case do
      nil -> {:error, "invalid authorization token"}
      user -> {:ok, user}
     end
  end

end
