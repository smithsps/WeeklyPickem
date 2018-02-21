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
    with ["Bearer " <> token] <- get_req_header(conn, "Authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    token
    |> token
    |> with_signer(hs512(secret()))
    |> verify
  end

  defp secret() do
    #Application.get_env(:weekly_pickem_web, WeeklyPickemWeb.Session, :token_secret)
    "zd3I0iarTjuC9UneZ0xOdXNu5Odx2sLvs9CHEdwf8JrDLX6dQqn3NI2BC5Q2pSms2I49HoXIFJIkNEgoT4YVIA=="
  end


end
