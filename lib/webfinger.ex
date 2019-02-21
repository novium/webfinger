defmodule Webfinger do
  @moduledoc """
  Documentation for Webfinger.
  """

  @doc """
  Looks up ref at url
  """
  def lookup(url, ref \\ "") do
    with :ok <- check_url(url),
         {:ok, response} <- HTTPoison.get(url),
         :ok <- check_headers(response.headers)
    do
      nil
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unknown error occured"}
    end
  end

  @spec check_url(String.t) :: :ok | {:error, String.t}
  defp check_url(url) do
    # RFC 4.2 MUST use HTTPS
    case String.starts_with?(url, "https://") do
      true -> :ok
      false -> {:error, "Resource must use HTTPS"}
    end
  end
  
  @spec check_headers([{String.t, String.t}]) :: :ok | {:error, String.t}
  defp check_headers([{"Content-Type", "application/jrd+json"} | _]), do: :ok
  defp check_headers([{"Content-Type", type} | _]), do: {:error, "Invalid content type - " <> type}
  defp check_headers([_ | t]), do: check_headers(t)
  defp check_headers([]), do: {:error, "Content-Type header missing"}
end
