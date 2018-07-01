defmodule WeeklyPickem.Esport.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Esport.Team
  #alias WeeklyPickem.Esport.Match

  schema "teams" do
    field :panda_id, :string
    field :name, :string
    field :acronym, :string
    field :league, :string

    #has_many :matches, Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(%Team{} = team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name, :region, :acronym])
    # |> validate_inclusion(:region, ["NA", "EU", "KR", "LAN", "LAS", "OCE", "SEA",
    #                                 "LMS", "TUR", "JPN", "CN", "BR", "CIS" ],
    #                                 message: "Invalid region")
    |> unique_constraint(:name, message: "Team name already exists")
  end


  def get_all_teams do
    Team |> WeeklyPickem.Repo.all
  end
end
