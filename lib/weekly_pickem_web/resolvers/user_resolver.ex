defmodule WeeklyPickemWeb.Resolvers.UserResolver do
  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Model.Query
  alias WeeklyPickem.Model.User


  def create_user(_root, args, _info) do
    case create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, user} ->
        {:error, map_errors_to_list_of_strings(user.errors)}
      _error -> {:error, "Undefined error occured."}
    end
  end


  ### Repository Queries
  defp create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp get_user_by_email(email)  do
    Repo.get_by(User, email: email)
  end

  defp get_user_by_id(id)  do
    Repo.get_by(User, id: id)
  end

  defp map_errors_to_list_of_strings(errors) do
    Enum.flat_map(errors, fn ({field, error}) ->
      {msg, opts} = error
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
      ["#{msg}"]
    end)
  end

end
