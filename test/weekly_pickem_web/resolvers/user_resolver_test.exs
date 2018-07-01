defmodule WeeklyPickem.Web.Resolvers.UserResolverTest do
  use WeeklyPickem.Web.ConnCase
  alias WeeklyPickem.Web.Resolvers.UserResolver
  alias WeeklyPickem.Web.AbsintheHelpers

  @valid_user %{name: "Test User",
                 email: "test@test.com", email_confirmation: "test@test.com",
                 password: "test123", password_confirmation: "test123"
               }

  describe "User Resolver Integrations" do

    test "create user", context do
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

    test "login user", context do
      {:ok, user} = UserResolver.create_user(nil, @valid_user, nil)

      query = """
      mutation {
        loginUser(email:"test@test.com", password: "test123") {
          refreshToken {
            token
            expiration
          }
          accessToken {
            token
          }
          user {
            id
            name
            email
          }
        }
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.mutation_skeleton(query))
      refute json_response(result, 200)["data"]["loginUser"]["user"]["name"] == nil
      assert json_response(result, 200)["data"]["loginUser"]["user"]["name"] == user.name
    end

    test "failed login attempt", context do
      {:ok, _user} = UserResolver.create_user(nil, @valid_user, nil)

      query = """
      mutation {
        loginUser(email:"test@test.com", password: "wrong_password") {
          refreshToken {
            token
            expiration
          }
          accessToken {
            token
          }
          user {
            id
            name
            email
          }
        }
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.mutation_skeleton(query))
      refute json_response(result, 200) == nil
      assert List.first(json_response(result, 200)["errors"])["message"] == "Invalid username or password."
    end


    test "logout", context do
      {:ok, _user} = UserResolver.create_user(nil, @valid_user, nil)
      login_query = """
      mutation {
        loginUser(email:"test@test.com", password: "test123") {
          refreshToken {
            token
            expiration
          }
          accessToken {
            token
          }
          user {
            id
            name
            email
          }
        }
      }
      """
      result = context.conn |> post("/api", AbsintheHelpers.mutation_skeleton(login_query))
      refresh_token = json_response(result, 200)["data"]["loginUser"]["refreshToken"]["token"]
      refute refresh_token == nil


      query = """
      mutation {
        logoutUser(refreshToken: "#{refresh_token}"){
        	message
      	}
      }
      """

      result = context.conn |> post("/api", AbsintheHelpers.mutation_skeleton(query))
      assert json_response(result, 200)["data"]["logoutUser"]["message"] == "Logout successful."
    end
  end
end
