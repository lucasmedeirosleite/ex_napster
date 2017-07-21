defmodule ArtistsSpec do
  use ESpec, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExNapster.Metadata.Artists

  describe Artists do
    describe "ExNapster.Metadata.Artists.top/2" do
    end
  end
end
