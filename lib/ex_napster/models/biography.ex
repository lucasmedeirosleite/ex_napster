defmodule ExNapster.Metadata.Models.Biography do
  @moduledoc """
    Module to emulate an artist biography
  """

  @doc """
    Defines the Artist Biography struct

    * :title              - the biography title
    * :author             - the biography author
    * :description        - the biography description
    * :publish_date       - the biography publish date
  """
  defstruct title: "", author: "", publish_date: nil, description: ""

  def convert(bio_map) do
    %ExNapster.Metadata.Models.Biography{
      title: bio_map["title"],
      author: bio_map["author"],
      publish_date: bio_map["publishDate"],
      description: bio_map["bio"]
    }
  end
end
