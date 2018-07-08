defmodule WeeklyPickem.Web.Resolvers.UserResolver do

  alias WeeklyPickem.Account.User
  alias WeeklyPickem.Account.Registration
  alias WeeklyPickem.Account.RefreshToken


  def create_user(_root, args, _resolution) do
    Registration.create_new_user(args)
  end

  def login_user(_root, args, _resolution) do
    with %User{} = user <- User.get_user_by_email(args.email) do
      if Argon2.verify_pass(args.password, user.password) do
        {:ok,
          %{refresh_token: RefreshToken.create_refresh_token(user.id),
            access_token: RefreshToken.create_access_token(user.id),
            current_user: user
          }
        }
      else
        {:error, "Invalid username or password."}
      end

    else 
      # To help prevent user enumeration, we simulate the time that would be
      # checking a password, even if the user does not exist.
      _ ->
        Argon2.no_user_verify
        {:error, "Invalid username or password."}
    end
  end

  def refresh_access(_root, args, _resolution) do
    RefreshToken.refresh_access(args.refresh_token)
  end

  # For security, shouldn't we always return he same message?
  def logout_user(_root, args, _resolution) do
    with {:ok, _token} <- RefreshToken.remove_refresh_token(args.refresh_token)
    do
      {:ok, %{message: "Logout successful."}}
    else
      _error -> {:ok, %{message: "Logout successful."}}
    end
  end

  def current_user_id(_root, _args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution
    do
      {:ok, %{id: current_user_id}}
    else
      _ -> {:error, "User is not logged in."}
    end
  end

  def current_user_profile(_root, _args, resolution) do
    with %{context: %{current_user: current_user_id}} <- resolution
    do
      User.get_user_profile(current_user_id)
    else
      _ -> {:error, "User is not logged in."}
    end
  end

  def get_series_user_stats(_root, args, resolution) do
    with %{context: %{current_user: _current_user_id}} <- resolution
    do
      User.get_series_user_stats(args.series_tag)
    else
      _ -> {:error, "User is not logged in."}
    end
  end

end
