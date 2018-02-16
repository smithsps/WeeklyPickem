defmodule WeeklyPickem.Model.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Model.Team
  #alias WeeklyPickem.Model.Match

  schema "teams" do
    field :name, :string
    field :region, :string
    field :acronym, :string

    #has_many :matches, Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Team{} = team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name, :region, :acronym])
    |> validate_inclusion(:region, ["NA", "EU", "KR", "LAN", "LAS", "OCE", "SEA",
                                    "LMS", "TUR", "JPN", "CN", "BR", "CIS" ],
                                    message: "Invalid region")
    |> unique_constraint(:name, message: "Team name already exists")
  end
end
