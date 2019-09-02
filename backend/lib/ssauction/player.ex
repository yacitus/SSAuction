defmodule Ssauction.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "players" do
    field :year_range, :string    
    field :ssnum, :integer
    field :name, :string
    field :position, :string

    belongs_to :bid, Ssauction.Bid
    belongs_to :rostered_player, Ssauction.RosteredPlayer
    belongs_to :ordered_player, Ssauction.OrderedPlayer
  end

  def changeset(player, params \\ %{}) do
    required_fields = [:year_range, :ssnum, :name, :position]

    player
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:position, ["SP", "RP", "1B", "2B", "3B", "SS", "OF", "DH"])
    |> validate_year_range()
    |> validate_unique_year_range_and_ssnum()
    # |> assoc_constraint(:bid)
  end

  def validate_year_range(changeset) do
    case changeset.valid? do
      true ->
        year_range = get_field(changeset, :year_range)
        case String.length(year_range) do
          9 ->
            [start_year, end_year] = start_and_end_year_from_range(year_range)
            case start_year <= end_year do
              false ->
                add_error(changeset, :year_range, "end year must be greater or equal to start year")

              _ ->
                changeset
            end

          _ ->
            add_error(changeset, :year_range, "must be 9 characters")
        end

      _ ->
        changeset
    end
  end

  def start_and_end_year_from_range(year_range) do
    Enum.map(String.split(year_range, "-"), fn(x) -> String.to_integer(x) end)
  end

  defp validate_unique_year_range_and_ssnum(changeset) do
    case changeset.valid? do
      true ->
        year_range = get_field(changeset, :year_range)
        ssnum = get_field(changeset, :ssnum)
        query = from player in Ssauction.Player,
                where: player.year_range == ^year_range and player.ssnum == ^ssnum
        case Ssauction.Repo.all(query) do
          [] ->
            changeset
          _ ->
            add_error(changeset, :year_range, "and ssnum not unique", ssnum: ssnum)
        end

      _ ->
        changeset
    end
  end
end
