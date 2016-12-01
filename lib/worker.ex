defmodule Movies.Worker do
    
    def search_movie(query) do
        result = query |> url_of |> HTTPoison.get |> parse_response
        case result do
            {:ok, total_result} ->
                "total movies #{total_result}"
            _ -> 
                "error"
        end
    end

    def url_of(query) do
        encoded_query = URI.encode(query)
        "http://www.omdbapi.com/?s=#{encoded_query}"
    end

    defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
        json = body |> JSON.decode!
        {:ok, json["totalResults"]}
    end

    defp parse_response(_) do
        :error
    end

end