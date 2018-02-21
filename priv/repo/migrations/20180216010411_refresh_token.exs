defmodule WeeklyPickem.Repo.Migrations.RefreshToken do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :string
      add :expiration, :integer
      add :user_id, :id

      timestamps()
    end
  end
end
