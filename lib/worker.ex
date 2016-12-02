defmodule Movies.Worker do
    
    def search_movie(query) do
        query
            |> URI.encode
            |> url_of
            |> HTTPoison.get 
            |> parse_response
            |> display_result
    end

    defp url_of(query), do: "http://www.omdbapi.com/?s=#{query}"

    defp display_result({:ok, search_results}), do: search_results
    defp display_result(:nothing), do: "Found nothing"
    defp display_result(_), do: "Unexpected result from the server"

    defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
        body
            |> JSON.decode!
            |> get_search_results_from_json
            |> construct_result
    end
    defp parse_response(_), do: :error

    defp get_total_results_from_json(json), do: json["totalResults"]
    defp get_search_results_from_json(json), do: json["Search"]

    defp construct_result(result) when is_nil(result), do: :nothing
    defp construct_result(result), do: {:ok, result}

end
