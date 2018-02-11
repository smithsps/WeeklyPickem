defmodule WeeklyPickemWeb.Schema do
  use Absinthe.Schema

  alias WeeklyPickemWeb.Resolvers


  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  query do
    field :all_teams, non_null(list_of(non_null(:team))) do
      resolve &Resolvers.TeamResolver.all_teams/3
    end
  end

  object :user do
    field :id, non_null(:string)
    field :name, non_null(:string)
    field :email, non_null(:string)
  end

  mutation do
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :email, non_null(:string)
      arg :email_confirmation, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)

      resolve &Resolvers.UserResolver.create_user/3
    end
  end

end
