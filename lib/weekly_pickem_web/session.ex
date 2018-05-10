defmodule WeeklyPickemWeb.Session do
  @moduledoc false

  import Plug.Conn
  import Joken

  def init(opts), do: opts

  def call(conn, _) do
    session = check_token(conn)
    put_private(conn, :absinthe, %{session: session})
  end


  def check_token(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
    else

      _ -> %{}
    end
  end

  defp authorize(auth_token) do
    _token = auth_token
    |> token
    |> with_signer(hs512(secret()))
    |> verify!
  end

  defp secret() do
    Application.get_env(:weekly_pickem, :secrets)[:user_token_seed]
  end


end
