defmodule ExNapster.Metadata.Models.Artist do
  @moduledoc """
    Module to emulate an artist model
  """

  alias ExNapster.Metadata.Models.Biography

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

  def convert([]), do: []

  def convert([artist_map]) do
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

      %ExNapster.Metadata.Models.Artist{
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
      nil
    end
  end

  def convert(artists_map) when is_list(artists_map) do
    for artist <- artists_map, do: convert([artist])
  end

  defp extract_bios(bios_map) do
    bios = for bio <- bios_map, do: Biography.convert(bio)
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
