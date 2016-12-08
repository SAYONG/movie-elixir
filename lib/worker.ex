defmodule Movies.Worker do
    def loop do
        receive do
            {sender_pid, query} ->
                send(sender_pid, {:ok, search_movie(query)})
            _ ->
                IO.puts "Wrong query!!"
        end
        loop
    end

    def search_movie(query) do
        query
            |> URI.encode
            |> url_of
            |> HTTPoison.get 
            |> parse_response
            |> display_result
    end

    defp url_of(query), do: "http://www.omdbapi.com/?s=#{query}"

    defp display_result({:ok, results}), do: hd results
    defp display_result(:nothing), do: "Found nothing"
    defp display_result(_), do: "Unexpected result from the server"

    defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
        body
            |> JSON.decode!
            |> get_json_data("Search")
            |> construct_result
    end
    defp parse_response(_), do: :error

    defp get_json_data(json, path), do: json[path]

    defp construct_result(result) when is_nil(result), do: :nothing
    defp construct_result(result), do: {:ok, result}

end
