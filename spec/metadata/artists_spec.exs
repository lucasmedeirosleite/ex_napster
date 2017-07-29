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
          {:ok, artist} = Artists.top(limit: 1)

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

    describe "ExNapster.Metadata.Artists.by_id/1" do
      subject :artists_by_id, do: Artists.by_id(artist_id())

      context "with one artist id" do
        let :artist_id, do: "Art.28463069"

        it "returns an artist" do
          use_cassette "artists/one_artist" do
            {:ok, artist} = artists_by_id()

            expect(artist).to be_struct Artist
          end
        end
      end

      context "with more than on artist id" do
        let :artist_id, do: ["Art.28463069", "Art.7375005"]

        it "returns the artists" do
          use_cassette "artists/two_artists" do
            {:ok, artists} = artists_by_id()

            expect(artists).to have_count(2)
            Enum.each(artists, fn(artist) ->
              expect(artist).to be_struct Artist
            end)
          end
        end
      end

      context "with no valid artist" do
        let :artist_id, do: "ashashsa"

        it "returns an error" do
          use_cassette "artists/no_valid_artist_for_id" do
            expect(artists_by_id()).to eq({:error, :not_found})
          end
        end
      end
    end
  end
end
