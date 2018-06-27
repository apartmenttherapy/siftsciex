defmodule Siftsciex.Score do
  @moduledoc """
  Functions for interacting with the Sift Science `Score` API.

  Risk Scores are why you are using Sift Science in the first place.  Sift Science provides an API to get Risk Scores for users on demand.  This module provides functions for doing just that.

  You will also find the `t:Siftsciex.Score.Response.t/0` struct defined in this namespace.  In the case of a successful HTTP request to the Score `API` the functions here will return a tuple with a `t:Siftsciex.Score.Response.t/0` struct as the second element.

  There are five different abuse scores that Sift Science can/will return:

    * _Payment Abuse_
    * _Content Abuse_
    * _Promotion Abuse_
    * _Account Abuse_
    * _Legacy_

  The legacy score is more of a general assesment of the user, the others are fairly self-explainatory.  When making a request to the Score API you must specify one or more score types to return, by default `score_for/1` will request the `:legacy` score.

  *NOTE*: If a synchronous request is made to the Events API then a `t:Siftsciex.Score.Response.t/0` struct will be embedded in the resulting `t:Siftsciex.Event.Response.t/0` struct.
  """

  require Logger

  alias Siftsciex.Score.Response

  @transport Application.get_env(:siftsciex, :http_transport) || HTTPoison

  @type abuse_type :: :payment | :content | :promotion | :account | :legacy
  @type result :: {:ok, Response.t}
                  | {:error,  :redirected, String.t}
                  | {:error, :client_error, integer}
                  | {:error, :server_error, integer}
                  | {:error, :transport_error, any}

  @doc """
  Retrieves a score for the given user

  ## Parameters

    - `user_id`: The `user_id` for which the score should be returned
    - `abuse_types`: A list of `t:Siftsciex.Score.abuse_type/0` values indicating the abuse types to return, if not given the default is `[:legacy]`

  ## Examples

      iex> Score.score_for("bob")
      {:ok, %Siftsciex.Score.Response{}}

  """
  @spec score_for(String.t, [abuse_type]) :: result
  def score_for(user_id, abuse_types \\ [:legacy]) do
    user_id
    |> request_url(abuse_types)
    |> @transport.get()
    |> case do
         {:ok, %{status_code: 200} = response} ->
           {:ok, Response.process(response.body())}
         {:ok, %{status_code: status} = response} when status >= 300 and status <= 399 ->
           {:error, :redirected, response.headers["Location"]}
         {:ok, %{status_code: status}} when status >= 400 and status <= 499 ->
           Logger.error("Failed to Post Event, received 4xx response for configured URI")
           {:error, :client_error, status}
         {:ok, %{status_code: status}} when status >= 500 and status <= 500 ->
           {:error, :server_error, status}
         {:error, error} ->
           {:error, :transport_error, error.reason()}
       end
  end

  defp request_url(user, types) do
    uri = "#{base_url()}/#{user}"
    query = "?api_key=#{api_key()}&abuse_types=#{abuse_val(types)}"

    "#{uri}/#{query}"
  end

  defp base_url, do: Application.get_env(:siftsciex, :score_url)

  defp api_key, do: Application.get_env(:siftsciex, :api_key)

  defp abuse_val(abuse_types) do
    abuse_types
    |> Enum.map(&(Atom.to_string(&1)))
    |> Enum.join(",")
  end
end
