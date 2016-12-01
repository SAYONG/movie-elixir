defmodule Movies.Worker do
    
    def search_movie(query) do
        result = query |> url_of |> HTTPoison.get |> parse_response
        case result do
            {:ok, total_result} ->
                "Total: #{total_result}"
            :nothing ->
                "Nothing"
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
        total_results = json["totalResult"]["nothing"]
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