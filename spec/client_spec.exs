defmodule ClientSpec do
  use ESpec, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExNapster.Client

  describe ExNapster.Client do
    describe "ExNapster.Client.get/2" do
      context "when status code between 200 and 204" do
        it "returns a valid response" do
          use_cassette "artists/top_without_params" do
            {:ok, response} = Client.get("artists/top")

            expect(response).to have_key("artists")
            expect(response).to have_key("meta")
          end
        end

        it "returns a valid response with params" do
          use_cassette "artists/top_with_params" do
            {:ok, response} = Client.get("artists/top", limit: 5)

            expect(response).to have_key("artists")
            expect(response).to have_key("meta")
          end
        end
      end

      context "when status code greater than 204" do
        it "returns an error" do
          use_cassette "errors/not_found" do
            {status, response} = Client.get("artistsss/top")

            expect(status).to eq(:error)
            expect(response).to have_key("http_status_code")
          end
        end
      end
    end
  end
end
