defmodule WeeklyPickemWeb.Resolvers.UserResolver do

  import Joken

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Model.User
  alias WeeklyPickem.Model.RefreshToken


  def create_user(_root, args, _resolution) do
    case repo_create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, user} -> {:error, map_errors_to_list_of_strings(user.errors)}
      _error -> {:error, "Undefined error occured."}
    end
  end

  defp repo_create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def login_user(_root, args, _resolution) do
    case get_user_by_email(args.email) do

      # To help prevent user enumeration, we simulate the time that would be
      # checking a password, even if the user does not exist.
      nil ->
        Argon2.no_user_verify
        {:error, "Invalid username or password."}

      user ->
        if Argon2.verify_pass(args.password, user.password) do
          {:ok,
            %{refresh_token: create_refresh_token(user.id),
              access_token: create_access_token(user.id),
              user: user
            }
          }
        else
          {:error, "Invalid username or password."}
        end
    end
  end

  def refresh_access(_root, args, _resolution) do
    case get_refresh_token(args.refresh_token) do
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

  # For security, shouldn't we always return he same message?
  def logout_user(_root, args, _resolution) do
    with {:ok, token} <- Repo.get_by(RefreshToken, token: args.refresh_token),
         Repo.delete(token.id)
    do
      {:ok, %{message: "Logout successful."}}
    else
      _error -> {:ok, %{message: "Logout successful."}}
    end
  end

  defp create_access_token(user_id) do
    new_token = %{user_id: user_id}
    |> token
    |> with_exp(current_time() + 5 * 60)
    |> with_signer(hs512(secret()))
    |> sign
    |> get_compact

    %{token: new_token}
  end

  defp create_refresh_token(user_id) do
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

  defp get_refresh_token(refresh_token) do
    Repo.get_by(RefreshToken, token: refresh_token)
  end

  defp get_user_by_email(email)  do
    Repo.get_by(User, email: email)
  end

  defp secret() do
    #Application.get_env(:weekly_pickem_web, WeeklyPickemWeb.Session, :token_secret)
    "zd3I0iarTjuC9UneZ0xOdXNu5Odx2sLvs9CHEdwf8JrDLX6dQqn3NI2BC5Q2pSms2I49HoXIFJIkNEgoT4YVIA=="
  end

  defp map_errors_to_list_of_strings(errors) do
    Enum.flat_map(errors, fn ({_field, error}) ->
      {msg, opts} = error
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
      ["#{msg}"]
    end)
  end

end
