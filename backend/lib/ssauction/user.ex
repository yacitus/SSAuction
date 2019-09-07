defmodule Ssauction.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :super, :boolean, default: false
    field :password_hash, :string
    field :password, :string, virtual: true

    many_to_many :teams, Ssauction.Team, join_through: "teams_users"
    many_to_many :admin_for, Ssauction.Auction, join_through: "auctions_users"

    timestamps()
  end

  def changeset(user, attrs) do
    required_fields = [:username, :email, :password]
    optional_fields = [:super]
    
    user
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
    |> validate_length(:username, min: 2)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
