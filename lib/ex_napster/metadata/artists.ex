defmodule ExNapster.Metadata.Models.Artist do
  defstruct id: "",
            name: "",
            bios: [],
            blurb: [],
            shortcut: "",
            albums_ids: [],
            genres_ids: [],
            stations_ids: [],
            influences_ids: [],
            contemporaries_ids: []
end

defmodule ExNapster.Metadata.Models.Biography do
  defstruct title: "", author: "", publish_date: nil, description: ""
end

defmodule ExNapster.Metadata.Artists do
  @moduledoc """
    Module responsible to handle the Napster Web API metadata
    related to Artists
  """

  alias ExNapster.Client
  alias ExNapster.Metadata.Models.Artist
  alias ExNapster.Metadata.Models.Biography

  @top_artists "artists/top"

  @doc """
  Returns an optionally paged list of the top artists across all of Napster,
  driven by listening activity.
  """
  def top(_params \\ []) do
    with {:ok, response} <- Client.get(@top_artists),
         {:ok, artists}  <- Map.fetch(response, "artists") do

      artists = for artist <- artists, do: transform_to_artist(artist)
      {:ok, artists}
    else {:error, _} ->
      :error
    end
  end

  defp transform_to_artist(artist_map) do
    %Artist{
      id:                 artist_map["id"],
      name:               artist_map["name"],
      bios:               extract_bios(artist_map["bios"]),
      blurb:              artist_map["blurb"],
      shortcut:           artist_map["shortcut"],
      albums_ids:         extract_albums(artist_map["albumGroups"]),
      genres_ids:         extract_genres(artist_map["links"]),
      stations_ids:       extract_stations(artist_map["links"]),
      influences_ids:     extract_influences(artist_map["links"]),
      contemporaries_ids: extract_contemporaries(artist_map["links"])
    }
  end

  defp extract_bios(bios_map) do
    for bio <- bios_map do
      %Biography{
        title: bio["title"],
        author: bio["author"],
        publish_date: bio["publishDate"],
        description: bio["bio"]
      }
    end
  end

  defp extract_albums(albums_group) do
    albums = for {_key, value} <- albums_group, into: [], do: value
    List.flatten(albums)
  end

  defp extract_genres(links_map),         do: links_map["genres"]["ids"]
  defp extract_stations(links_map),       do: links_map["stations"]["ids"]
  defp extract_influences(links_map),     do: links_map["influences"]["ids"]
  defp extract_contemporaries(links_map), do: links_map["contemporaries"]["ids"]
end
