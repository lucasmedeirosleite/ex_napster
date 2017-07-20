defmodule ConfigurationSpec do
  use ESpec, async: true

  describe Application do
    it "has a config var for Napster Web API base URL" do
      base_url = Application.get_env(:ex_napster, :api_base_url)

      expect(base_url).not_to be_nil()
    end

    it "has a config var for Napster Web API version" do
      version = Application.get_env(:ex_napster, :api_version)

      expect(version).not_to be_nil()
    end

    it "has a config var for Napster Web API key" do
      key = Application.get_env(:ex_napster, :api_key)

      expect(key).not_to be_nil()
    end
  end
end
