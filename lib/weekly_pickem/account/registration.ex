defmodule WeeklyPickem.Account.Registration do

  alias WeeklyPickem.Repo
  alias WeeklyPickem.Account.User

  def create_new_user(attrs) do
    new_user = 
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()

    case new_user do
      {:ok, user} -> {:ok, user}
      {:error, user} -> {:error, map_errors_to_list_of_strings(user.errors)}
      _error -> {:error, "Undefined error occured."}
    end
  end

  defp map_errors_to_list_of_strings(errors) do
    Enum.flat_map(errors, fn ({field, error}) ->
      {msg, _opts} = error
      # Enum.reduce(opts, msg, fn {key, value}, acc ->
      #   acc = String.replace(acc, "%{#{key}}", "TEST: " <>to_string(value))
      #   acc
      # end)
      ["#{field} #{msg}"]
    end)
  end

end