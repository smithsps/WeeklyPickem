defmodule WeeklyPickem.Esport.Series do
  use Ecto.Schema

  schema "series" do
    field :name, :string
    field :start_date, :utc_datetime
    field :region, :string

    has_many :matches, Match

    timestamps()
  end
end