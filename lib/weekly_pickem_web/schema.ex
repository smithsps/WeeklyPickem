defmodule WeeklyPickemWeb.Schema do
  use Absinthe.Schema

  alias WeeklyPickemWeb.Resolvers

  object :team do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :acronym, non_null(:string)
    field :region, non_null(:string)
  end

  @desc "Simple user object with id, name and email"
  object :user do
    field :id, non_null(:string)
    field :name, non_null(:string)
    field :email, non_null(:string)
  end

  @desc "Access token, used for authenticating API calls"
  object :access_token do
    field :token, non_null(:string)
  end

  object :refresh_token do
    field :token, non_null(:string)
    field :expiration, non_null(:integer)
  end

  @desc "Login object with refresher and access token with additional user object"
  object :login do
    field :refresh_token, non_null(:refresh_token)
    field :access_token, non_null(:access_token)
    field :user, non_null(:user)
  end

  @desc "Logout user by supplying a corresponding refresh token"
  object :logout do
    field :message, non_null(:string)
  end

  query do
    field :all_teams, non_null(list_of(non_null(:team))) do
      resolve &Resolvers.TeamResolver.all_teams/3
    end

  end

  mutation do
    @desc "Login an existing user"
    field :login_user, :login do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.UserResolver.login_user/3
    end

    @desc "Refresh access token with an refresh token"
    field :refresh_access, :access_token do
      arg :refresh_token, non_null(:string)

      resolve &Resolvers.UserResolver.refresh_access/3
    end

    @desc "Logout the user with the refresh token"
    field :logout_user, :logout do
      arg :refresh_token, non_null(:string)

      resolve &Resolvers.UserResolver.logout_user/3
    end

    @desc "Create a new user"
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
