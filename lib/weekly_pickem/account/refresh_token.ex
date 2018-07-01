defmodule WeeklyPickem.Account.RefreshToken do
  use Ecto.Schema

  import Ecto.Changeset
  import Joken

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Account.RefreshToken

  schema "tokens" do
    field :user_id, :id
    field :token, :string
    field :expiration, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(%RefreshToken{} = token, attrs) do
    token
    |> cast(attrs, [:user_id, :token, :expiration])
    |> validate_required([:user_id, :token, :expiration])
  end

  def create_refresh_token(user_id) do
    token = :crypto.strong_rand_bytes(64) |> Base.encode64(padding: false)
    expiration = current_time() + 30 * 24 * 60

    new_refresh_token = %RefreshToken{
      user_id: user_id,
      token: token,
      expiration: expiration
    }
    |> Repo.insert()

    case new_refresh_token do
      {:ok, token} -> %{token: token.token, expiration: token.expiration}
      _error -> %{error: "Unexpected, could not create refresh token."}
    end
  end

  def refresh_access(refresh_token) do
    case Repo.get_by(RefreshToken, token: refresh_token) do
      nil -> {:error, "Invalid refresh token."}

      refresh_token ->
        if current_time() > refresh_token.expiration do
          {:ok, %{token: create_access_token(refresh_token.user_id)}}
        else
          case Repo.delete(refresh_token) do
            _result -> {:error, "Invalid refresh token."}
          end
        end
    end
  end

  def remove_refresh_token(refresh_token) do
    case Repo.get_by(RefreshToken, token: refresh_token) do
      {:ok, id} -> Repo.delete(id)
      _error -> {:error, ""}
    end
  end

  def create_access_token(user_id) do
    new_token = %{user_id: user_id}
    |> token
    |> with_exp(current_time() + 5 * 60)
    |> with_signer(hs512(secret()))
    |> sign
    |> get_compact

    %{token: new_token}
  end

  defp secret() do
    Application.get_env(:weekly_pickem, :secrets)[:user_tokens]
  end

end
