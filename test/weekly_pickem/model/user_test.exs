defmodule WeeklyPickem.Model.UserTest do
  use WeeklyPickem.DataCase

  alias WeeklyPickem.Model.User

  @valid_attrs %{name: "Test User",
                 email: "test@test.com", email_confirmation: "test@test.com",
                 password: "test123", password_confirmation: "test123"
               }

  test "name is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :name))
    refute changeset.valid?
  end

  test "email is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :email))
    refute changeset.valid?
  end

  test "password is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :password))
    refute changeset.valid?
  end

  test "email confirmation matching" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "email confirmation not matching" do
    changeset = User.changeset(%User{}, Map.replace!(@valid_attrs, :email, "not_matching@gmail.com"))
    refute changeset.valid?
  end

  test "password confirmation matching" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "password confirmation not matching" do
    changeset = User.changeset(%User{}, Map.replace!(@valid_attrs, :password, "not_matching"))
    refute changeset.valid?
  end

  test "password length too short" do
    changeset = User.changeset(%User{}, Map.replace!(@valid_attrs, :password, "shft"))
    refute changeset.valid?
  end

  test "password length too long" do
    changeset = User.changeset(%User{}, Map.replace!(@valid_attrs, :password, String.duplicate("A", 256)))
    refute changeset.valid?
  end

  test "password hashing" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :name))
    assert Argon2.verify_pass(@valid_attrs.password, changeset.changes.password)
  end

  test "email format" do
    changeset = User.changeset(%User{}, Map.replace!(@valid_attrs, :email, "test"))
    refute changeset.valid?
  end

end
