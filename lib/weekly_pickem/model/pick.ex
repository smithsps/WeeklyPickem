defmodule WeeklyPickem.Model.Pick do
  use Ecto.Schema
  import Ecto.Changeset
  alias WeeklyPickem.Model.Pick


  schema "picks" do
    field :user_id, :id
    field :match_id, :id
    field :pick_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Pick{} = pick, attrs) do
    pick
    |> cast(attrs, [])
    |> validate_required([])
  end
end
