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
            expect(artist).to have_key(:blurbs)
            expect(artist).to have_key(:shortcut)
            expect(artist).to have_key(:albums_ids)
            expect(artist).to have_key(:genres_ids)
            expect(artist).to have_key(:stations_ids)
            expect(artist).to have_key(:influences_ids)
            expect(artist).to have_key(:contemporaries_ids)
          end)
        end
      end

      it "limits the return to 1" do
        use_cassette "artists/top_with_limit_1" do
          {:ok, artists} = Artists.top(limit: 1)

          expect(artists).to have_count(1)

          artist = List.first(artists)

          expect(artist).to be_struct Artist
        end
      end

      it "offsets the return by one page" do
        use_cassette "artists/top_without_params" do
          {:ok, artists} = top_artists()

          use_cassette "artists/top_with_offset_2" do
            {:ok, offset_artists} = Artists.top(offset: 2)

            expect(artists).not_to eq(offset_artists)
          end
        end
      end

      it "changes the frequency of artists" do
        use_cassette "artists/top_without_params" do
          {:ok, artists} = top_artists()

          use_cassette "artists/top_weekly" do
            {:ok, week_artists} = Artists.top(range: :week)

            expect(artists).not_to eq(week_artists)
          end
        end
      end
    end
  end
end
