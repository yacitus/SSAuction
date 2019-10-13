defmodule Ssauction.AllPlayer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "all_players" do
    field :year_range, :string    
    field :ssnum, :integer
    field :name, :string
    field :position, :string
  end

  def changeset(player, params \\ %{}) do
    required_fields = [:year_range, :ssnum, :name, :position]

    player
    |> cast(params, required_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:position, ["SP", "RP", "C", "1B", "2B", "3B", "SS", "OF", "DH"])
    |> validate_year_range()
    |> validate_unique_year_range_and_ssnum()
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
