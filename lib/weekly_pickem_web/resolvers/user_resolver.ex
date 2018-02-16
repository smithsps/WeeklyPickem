defmodule WeeklyPickemWeb.Resolvers.UserResolver do

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Model.User


  def create_user(_root, args, _info) do
    case create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, user} -> {:error, map_errors_to_list_of_strings(user.errors)}
      _error -> {:error, "Undefined error occured."}
    end
  end

  def login_user(_root, args, _info) do
    case get_user_by_email(args.email) do

      # To help prevent user enumeration, we simulate the time that would be
      # checking a password, even if the user does not exist.
      nil ->
        Argon2.no_user_verify
        {:error, "Invalid username or password."}

      user ->
        if Argon2.verify_pass(args.password, user.password) do
          {:ok, user}
        else
          {:error, "Invalid username or password."}
        end
    end
  end

  defp create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp get_user_by_email(email)  do
    Repo.get_by(User, email: email)
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
