defmodule ExNapster.Client do
  @moduledoc """
    Module responsible to perform requests to Napster Web API
  """

  @api_base_url Application.get_env(:ex_napster, :api_base_url)
  @api_version  Application.get_env(:ex_napster, :api_version)
  @api_key      Application.get_env(:ex_napster, :api_key)
  @api_url      "#{@api_base_url}/#{@api_version}"
  @headers      ["apikey": @api_key, "Accept": "application/json"]

  def get(action, params \\ []) do
    action
    |> request_url(params)
    |> HTTPoison.get(@headers)
    |> handle_response
  end

  defp request_url(action, params) do
    "#{@api_url}/#{action}" |> encode_params(params)
  end

  defp encode_params(url, []), do: url
  defp encode_params(url, params) do
    "#{url}?#{URI.encode_query(params)}"
  end

  defp handle_response({:ok, %{status_code: status, body: body}})
  when is_integer(status) and status >= 200 and status <= 204  do
    response =
      body
      |> String.split("\n")
      |> Poison.Parser.parse!

    {:ok, response}
  end

  defp handle_response({:ok, %{status_code: status, body: body}})
  when is_integer(status) and status > 204 do
    {:error, Poison.Parser.parse!(body)}
  end

  defp handle_response({:error, error}), do: {:error, error}
end
