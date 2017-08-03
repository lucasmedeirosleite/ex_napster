defmodule ExNapster.Metadata.Models.Album do
  @moduledoc """
    Module to emulate an album model
  """

  @doc """
    Defines the Album struct

    * :id                  - the album id
    * :upc                 - the album universal product code
    * :name                - the album name
    * :tags                - the album tags
    * :label               - the label which released the album
    * :genres              - the album genres
    * :single?             - tells if the album is a single
    * :shortcut            - the album shortcut string id
    * :explicit?           - tells if the album has explicit content
    * :copyright           - the copyright
    * :disc_count          - the album count
    * :streamable?         - tells if the album can be streamed
    * :artist_name         - the album artist name
    * :track_count         - the album track count
    * :release_date        - the album release date
    * :partner_account     - napster account name of the partner
    * :originally_released - the album original release date
  """
  defstruct id: "",
            upc: "",
            name: "",
            tags: [],
            label: "",
            genres: [],
            single?: false,
            shortcut: "",
            explicit?: false,
            copyright: "",
            disc_count: 0,
            streamable?: false,
            artist_name: "",
            track_count: 0,
            release_date: nil,
            partner_account: "",
            originally_released: nil

  def convert(album_map) when is_map(album_map) do
    with {:ok, id}                  <- Map.fetch(album_map, "id"),
         {:ok, upc}                 <- Map.fetch(album_map, "upc"),
         {:ok, name}                <- Map.fetch(album_map, "name"),
         {:ok, tags}                <- Map.fetch(album_map, "tags"),
         {:ok, label}               <- Map.fetch(album_map, "label"),
         {:ok, links}               <- Map.fetch(album_map, "links"),
         {:ok, genres}              <- extract_genres(links),
         {:ok, is_single}           <- Map.fetch(album_map, "isSingle"),
         {:ok, shortcut}            <- Map.fetch(album_map, "shortcut"),
         {:ok, is_explicit}         <- Map.fetch(album_map, "isExplicit"),
         {:ok, copyright}           <- Map.fetch(album_map, "copyright"),
         {:ok, disc_count}          <- Map.fetch(album_map, "discCount"),
         {:ok, is_streamable}       <- Map.fetch(album_map, "isStreamable"),
         {:ok, artist_name}         <- Map.fetch(album_map, "artistName"),
         {:ok, track_count}         <- Map.fetch(album_map, "trackCount"),
         {:ok, release_date}        <- Map.fetch(album_map, "released"),
         {:ok, partner_account}     <- Map.fetch(album_map, "accountPartner"),
         {:ok, originally_released} <- Map.fetch(album_map, "originallyReleased") do

      %ExNapster.Metadata.Models.Album{
        id: id,
        upc: upc,
        name: name,
        tags: tags,
        label: label,
        genres: genres,
        single?: is_single,
        shortcut: shortcut,
        explicit?: is_explicit,
        copyright: copyright,
        disc_count: disc_count,
        streamable?: is_streamable,
        artist_name: artist_name,
        track_count: track_count,
        release_date: release_date,
        partner_account: partner_account,
        originally_released: originally_released
      }
    else _ ->
      nil
    end
  end

  def convert(albums_map) when is_list(albums_map) do
    for album_map <- albums_map, do: convert(album_map)
  end

  defp extract_genres(links_map) do
    with {:ok, genres_map} <- Map.fetch(links_map, "genres"),
         {:ok, ids}        <- Map.fetch(genres_map, "ids") do
      {:ok, ids}
    else _ ->
      {:ok, []}
    end
  end
end
