defmodule ArtistsSpec do
  use ESpec, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExNapster.Metadata.Artists
  alias ExNapster.Metadata.Models.Artist

  before_all do
    ExVCR.Config.cassette_library_dir("spec/cassettes")
  end

  describe Artists do
    describe "ExNapster.Metadata.Artists.top/2" do
      subject :top_artists, do: Artists.top

      it "limits the return to 20" do
        use_cassette "artists/top_without_params" do
          {:ok, artists} = top_artists()

          expect(artists).to have_count(20)
        end
      end

      it "converts returns a list of artist struct" do
        use_cassette "artists/top_without_params" do
          {:ok, artists} = top_artists()

          Enum.each(artists, fn(artist) ->
            expect(artist).to be_struct Artist
            expect(artist).to have_key(:id)
            expect(artist).to have_key(:name)
            expect(artist).to have_key(:bios)
            expect(artist).to have_key(:blurb)
            expect(artist).to have_key(:shortcut)
            expect(artist).to have_key(:albums_ids)
            expect(artist).to have_key(:genres_ids)
            expect(artist).to have_key(:stations_ids)
            expect(artist).to have_key(:influences_ids)
            expect(artist).to have_key(:contemporaries_ids)
          end)
        end
      end
    end
  end
end
