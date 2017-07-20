defmodule ArtistTest do
  use ExUnit.Case, async: true
  doctest ExNapster.Metadata.Artist

  alias ExNapster.Metadata.Artist

  describe "ExNapster.Metadata.Artist.top/1" do
    test "retrieves the top 20 artists" do
      {:success, artists} = Artist.top

      assert 20 == Enum.count(artists)
    end

    test "retrieves the top 5 artists" do
      {:success, artists} = Artist.top(limit: 5)

      assert 5 == Enum.count(artists)
    end
  end
end
