defmodule WeeklyPickemWeb.Resolvers.UserResolverTest do
  use WeeklyPickemWeb.ConnCase
  alias WeeklyPickemWeb.Resolvers.UserResolver
  alias WeeklyPickemWeb.AbsintheHelpers

  @valid_user %{name: "Test User",
                 email: "test@test.com", email_confirmation: "test@test.com",
                 password: "test123", password_confirmation: "test123"
               }

  describe "User Resolver Integrations" do

    test "create user, graphql", context do
      query = """
      mutation {
        createUser(
          name: "Test User",
          email: "test@test.com",
          emailConfirmation: "test@test.com",
          password: "test123",
          passwordConfirmation: "test123"
        ) {
          id,
          name
        }
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.mutation_skeleton(query))
      assert json_response(result, 200)["data"]["createUser"]["name"] == "Test User"
    end

    test "login user, graphql", context do
      {:ok, user} = UserResolver.create_user(nil, @valid_user, nil)

      query = """
      {
        loginUser(
          email: "test@test.com",
          password: "test123"
        ){
          id,
          name
        }
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.query_skeleton(query, "loginUser"))
      assert json_response(result, 200)["data"]["loginUser"]["name"] == user.name
    end

    test "login user, fail, graphql", context do
      {:ok, user} = UserResolver.create_user(nil, @valid_user, nil)

      query = """
      {
        loginUser(
          email: "fail@test.com",
          password: "test123"
        ){
          id,
          name
        }
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.query_skeleton(query, "loginUser"))
      refute json_response(result, 200)["data"]["loginUser"]["name"] == user.name
    end
  end

end
