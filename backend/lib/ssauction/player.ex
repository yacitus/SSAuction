defmodule Ssauction.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "players" do
    field :year_range, :string    
    field :ssnum, :integer
    field :name, :string
    field :position, :string

    belongs_to :auction, Ssauction.Auction
    belongs_to :bid, Ssauction.Bid
    belongs_to :rostered_player, Ssauction.RosteredPlayer
    has_many :ordered_players, Ssauction.OrderedPlayer
  end

  def changeset(player, params \\ %{}) do
    required_fields = [:year_range, :ssnum, :name, :position, :auction_id]

    player
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    # TODO - :position should be split by / and each slice confirmed to be in the list below
    # |> validate_inclusion(:position, ["SP", "RP", "C", "1B", "2B", "3B", "SS", "OF", "DH"])
    |> validate_year_range()
    |> assoc_constraint(:auction)
  end

  def validate_year_range(changeset) do
    case changeset.valid? do
      true ->
        year_range = get_field(changeset, :year_range)
        case String.length(year_range) do
          12 ->
            case parse_year_range(year_range) do
              %{"start_year" => start_year, "end_year" => end_year} ->
                case String.to_integer(end_year) >= String.to_integer(start_year) do
                  false ->
                    add_error(changeset, :year_range, "end year must be greater or equal to start year")

                  _ ->
                    changeset
                end
              _ ->
                add_error(changeset, :year_range, "can't find start and end year")
            end
          _ ->
            add_error(changeset, :year_range, "must be 12 characters")
        end

      _ ->
        changeset
    end
  end

  def parse_year_range(year_range) do
    Regex.named_captures(~r/(?<start_year>\d{4})-(?<end_year>\d{4})-(?<league>[A-Z]{2})/, year_range)
  end
end
