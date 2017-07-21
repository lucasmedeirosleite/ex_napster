defmodule ExNapster.Metadata.Artists do
  @moduledoc """
    Module responsible to handle the Napster Web API metadata
    related to Artists
  """

  @doc """
  Returns an optionally paged list of the top artists across all of Napster,
  driven by listening activity.
  """
  def top([limit: limit] \\ [limit: 20]) do
    artists = Enum.to_list(1..limit)
    {:success, artists}
  end
end
