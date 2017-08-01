defmodule ExNapster.Metadata.Models.Image do
  @moduledoc """
    Module to emulate an image model
  """

  @doc """
    Defines the Image struct

    * :id          - the image id
    * :url         - the image url
    * :width       - image width
    * :height      - the image height
    * :version     - tells the image version
    * :default?    - tells if the image is the default one (not resized)
    * :content_id  - from whom the image belongs to
    * :image_type  - tells the image type
  """
  defstruct id: "",
            url: "",
            width: "",
            height: "",
            version: 0,
            default?: true,
            content_id: nil,
            image_type: "displayImage"

  def convert([]), do: []

  def convert(images_map) when is_list(images_map) do
    for image_map <- images_map, do: convert(image_map)
  end

  def convert(image_map) when is_map(image_map) do
    with {:ok, id}          <- Map.fetch(image_map, "id"),
         {:ok, url}         <- Map.fetch(image_map, "url"),
         {:ok, width}       <- Map.fetch(image_map, "width"),
         {:ok, height}      <- Map.fetch(image_map, "height"),
         {:ok, version}     <- Map.fetch(image_map, "version"),
         {:ok, content_id}  <- Map.fetch(image_map, "contentId"),
         {:ok, image_type}  <- Map.fetch(image_map, "imageType"),
         {:ok, is_default}  <- Map.fetch(image_map, "isDefault") do

      %ExNapster.Metadata.Models.Image{
        id:         id,
        url:        url,
        width:      width,
        height:     height,
        version:    version,
        default?:   is_default,
        content_id: content_id,
        image_type: image_type
      }
    else _ ->
      nil
    end
  end
end
