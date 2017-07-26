defmodule ExNapster.Metadata.Models.Artist do
  @moduledoc """
    Module to emulate an artist model
  """

  @doc """
    Defines the Artist struct

    * :id                 - the artist id
    * :name               - the artist name
    * :bios               - an array of artist biographies
    * :blurbs             - an array of artist blurb
    * :shortcut           - the artist name shortcut
    * :albums_ids         - the ids of the artist's albums
    * :genres_ids         - the ids of the artist's genres
    * :stations_ids       - the ids of the artist's stations
    * :influences_ids     - the ids of the artist's influences
    * :contemporaries_ids - the ids of the artist's contemporaries
  """
  defstruct id: "",
            name: "",
            bios: [],
            blurbs: [],
            shortcut: "",
            albums_ids: [],
            genres_ids: [],
            stations_ids: [],
            influences_ids: [],
            contemporaries_ids: []
end

defmodule ExNapster.Metadata.Models.Biography do
  @moduledoc """
    Module to emulate an artist biography
  """

  @doc """
    Defines the Artist Biography struct

    * :title              - the biography title
    * :author             - the biography author
    * :description        - the biography description
    * :publish_date       - the biography publish date
  """
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

  ## Params

  - limit: It limits the total artists return (default: 20)
  - offset: Use for pagination (default: 0)
  - range: Defines the frequency of top artists, values are: week, month, year and life (default: month)

  """
  def top(params \\ []) do
    with {:ok, response} <- Client.get(@top_artists, params),
         {:ok, artists}  <- Map.fetch(response, "artists") do

      artists = for artist <- artists, do: transform_to_artist(artist)
      {:ok, artists}
    else {:error, _} ->
      :error
    end
  end

  defp transform_to_artist(artist_map) do
    with {:ok, id}                 <- Map.fetch(artist_map, "id"),
         {:ok, name}               <- Map.fetch(artist_map, "name"),
         {:ok, blurbs}             <- Map.fetch(artist_map, "blurbs"),
         {:ok, bios_map}           <- Map.fetch(artist_map, "bios"),
         {:ok, bios}               <- extract_bios(bios_map),
         {:ok, shortcut}           <- Map.fetch(artist_map, "shortcut"),
         {:ok, albums_group}       <- Map.fetch(artist_map, "albumGroups"),
         {:ok, albums_ids}         <- extract_albums(albums_group),
         {:ok, links}              <- Map.fetch(artist_map, "links"),
         {:ok, genres_ids}         <- extract_from(links, "genres"),
         {:ok, stations_ids}       <- extract_from(links, "stations"),
         {:ok, influences_ids}     <- extract_from(links, "influences"),
         {:ok, contemporaries_ids} <- extract_from(links, "contemporaries") do

      %Artist{
        id:                 id,
        name:               name,
        bios:               bios,
        blurbs:             blurbs,
        shortcut:           shortcut,
        albums_ids:         albums_ids,
        genres_ids:         genres_ids,
        stations_ids:       stations_ids,
        influences_ids:     influences_ids,
        contemporaries_ids: contemporaries_ids
      }
    else _ ->
      %Artist{}
    end
  end

  defp extract_bios(bios_map) do
    bios = for bio <- bios_map, into: [] do
      %Biography{
        title: bio["title"],
        author: bio["author"],
        publish_date: bio["publishDate"],
        description: bio["bio"]
      }
    end

    {:ok, bios}
  end

  defp extract_albums(albums_group) do
    albums = for {_key, value} <- albums_group, into: [], do: value
    {:ok, List.flatten(albums)}
  end

  defp extract_from(links_map, field) do
    with {:ok, field_map } <- Map.fetch(links_map, field),
         {:ok, ids}        <- Map.fetch(field_map, "ids") do
      {:ok, ids}
    else _ ->
      {:ok, []}
    end
  end
end
