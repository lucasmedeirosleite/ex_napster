defmodule ExNapsterTest do
  use ExUnit.Case, aync: true
  doctest ExNapster

  describe "configuration" do
    test "has an application env var for the base API Napster URL" do
      napster_base_url = Application.get_env(:ex_napster, :api_base_url)
      refute napster_base_url == nil
    end

    test "has an application env var for the Napster API version" do
      napster_api_version = Application.get_env(:ex_napster, :api_version)
      refute napster_api_version == nil
    end

    test "has an application env var for the Napster API Key" do
      napster_api_key = Application.get_env(:ex_napster, :api_key)
      refute napster_api_key == nil
    end
  end
end
