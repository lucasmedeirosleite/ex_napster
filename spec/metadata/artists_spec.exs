defmodule ArtistsSpec do
  use ESpec, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExNapster.Metadata.Artists
  alias ExNapster.Metadata.Models.Image
  alias ExNapster.Metadata.Models.Album
  alias ExNapster.Metadata.Models.Artist

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

    describe "ExNapster.Metadata.Artists.images/1" do
      subject :artist_images, do: Artists.images(artist_id())

      context "with valid artist id" do
        let :artist_id, do: "Art.28463069"

        it "returns all images related to the artist" do
          use_cassette "artists/artist_images" do
            {:ok, images} = artist_images()

            Enum.each(images, fn(image) ->
              expect(image).to be_struct Image
              expect(image).to have_key(:id)
              expect(image).to have_key(:url)
              expect(image).to have_key(:width)
              expect(image).to have_key(:height)
              expect(image).to have_key(:version)
              expect(image).to have_key(:default?)
              expect(image).to have_key(:image_type)
            end)
          end
        end
      end

      context "with invalid artist id" do
        let :artist_id, do: "invalid_id"

        it "returns an empty array of images" do
          use_cassette "artists/artist_images_from_invalid_id" do
            {:ok, images} = artist_images()

            expect(images).to be_empty()
          end
        end
      end
    end

    describe "ExNapster.Metadata.Artists.discography/2" do
      subject :discography, do: Artists.discography(artist(), params())

      context "with valid artist_id" do
        let :artist, do: "Art.28463069"
        let :params, do: []

        it "limits to 20 albums" do
          use_cassette("albums/artist_discography") do
            {:ok, albums} = discography()

            expect(albums).to have_count(20)
          end
        end

        it "returns the artist discography" do
          use_cassette("albums/artist_discography") do
            {:ok, albums} = discography()

            Enum.each(albums, fn(album) ->
              expect(album).to be_struct Album
              expect(album).to have_key(:id)
              expect(album).to have_key(:upc)
              expect(album).to have_key(:name)
              expect(album).to have_key(:tags)
              expect(album).to have_key(:label)
              expect(album).to have_key(:genres)
              expect(album).to have_key(:single?)
              expect(album).to have_key(:shortcut)
              expect(album).to have_key(:explicit?)
              expect(album).to have_key(:copyright)
              expect(album).to have_key(:disc_count)
              expect(album).to have_key(:streamable?)
              expect(album).to have_key(:artist_name)
              expect(album).to have_key(:track_count)
              expect(album).to have_key(:release_date)
              expect(album).to have_key(:partner_account)
              expect(album).to have_key(:originally_released)
            end)
          end
        end
      end

      context "with valid artist_id with params"

      context "with more than one artist_id"

      context "with invalid artist_id"
    end
  end
end
