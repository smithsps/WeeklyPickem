defmodule WeeklyPickem.Model.RefreshToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias WeeklyPickem.Model.RefreshToken

  schema "tokens" do
    field :user_id, :id
    field :token, :string
    field :expiration, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(%RefreshToken{} = token, attrs) do
    token
    |> cast(attrs, [:user_id, :token, :expiration])
    |> validate_required([:user_id, :token, :expiration])
  end

end
