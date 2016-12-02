defmodule Movies.Worker do
    
    def search_movie(query) do
        query
            |> url_of
            |> HTTPoison.get 
            |> parse_response
            |> display_result
    end

    defp display_result({:ok, total_result}), do: "Total: #{total_result}"
    defp display_result(:nothing), do: "Found nothing"
    defp display_result(_), do: "Unexpected result from the server"

    defp url_of(query) do
        encoded_query = URI.encode(query)
        "http://www.omdbapi.com/?s=#{encoded_query}"
    end

    defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
        json = body |> JSON.decode!
        total_results = json["totalResults"]
        cond do
            is_nil(total_results) ->
                :nothing 
            true ->
                {:ok, total_results}
        end
    end

    defp parse_response(_) do
        :error
    end

end