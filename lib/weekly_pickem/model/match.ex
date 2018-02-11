defmodule WeeklyPickem.Model.Match do
  use Ecto.Schema
  import Ecto.Changeset
  alias WeeklyPickem.Model.Match


  schema "matches" do
    field :cutoff, :utc_datetime
    field :time, :utc_datetime
    field :team0_id, :id
    field :time1_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Match{} = match, attrs) do
    match
    |> cast(attrs, [:time, :cutoff])
    |> validate_required([:time, :cutoff])
  end
end
