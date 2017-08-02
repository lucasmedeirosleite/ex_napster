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
    %ExNapster.Metadata.Models.Album{}
  end

  def convert(albums_map) when is_list(albums_map) do
    for album_map <- albums_map, do: convert(album_map)
  end
end
