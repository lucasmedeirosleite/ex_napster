defmodule ExNapster.Metadata.Artists do
  @moduledoc """
    Module responsible to handle the Napster Web API metadata
    related to Artists
  """

  alias ExNapster.Client
  alias ExNapster.Metadata.Models.Artist

  @artists "artists"
  @top_artists "#{@artists}/top"

  @doc """
  Returns an optionally paged list of the top artists across all of Napster,
  driven by listening activity.

  ## Params

  - limit: It limits the total artists return (default: 20)
  - offset: Use for pagination (default: 0)
  - range: Defines the frequency of top artists, values are: week, month, year and life (default: month)

  """
  def top(params \\ []) do
    @top_artists
    |> handle_call(params)
    |> handle_response
  end

  @doc """
  Returns the Artist who contains the passed id, or a list of Artists if an array
  of ids is passed.

  ## Params

  - id: an Artist id or an array of Artist ids
  """
  def by_id(id) when is_binary(id) do
    "#{@artists}/#{id}"
    |> handle_call
    |> handle_response
    |> nillify
  end

  def by_id(ids) when is_list(ids) do
    ids = Enum.join(ids, ",")

    "#{@artists}/#{ids}"
    |> handle_call
    |> handle_response
  end

  defp handle_call(action, params \\ []) do
    case Client.get(action, params) do
      {:ok, response} ->
        {:ok, response["artists"] || []}

      {:error, response} ->
        {:error, response}
    end
  end

  defp handle_response(response) do
    case response do
      {:ok, artists_map} ->
        artists = artists_map |> Artist.convert
        {:ok, artists}
      {:error, response} ->
        {:error, response}
    end
  end

  defp nillify({:ok, []}), do: {:error, :not_found}
  defp nillify({:ok, converted}), do: {:ok, converted}
end
