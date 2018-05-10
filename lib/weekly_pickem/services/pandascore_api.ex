defmodule WeeklyPickem.Services.PandaScoreAPI do

    defmodule ApiRequest do
      defstruct url: nil, parameters: []
    end

    @doc """
    Starts building a new PandaScore API request
    """
    def new_request(path) do
      %ApiRequest{url: "https://api.pandascore.co/" <> path}
    end

    @doc """
    The search parameter is a bit like the filter parameter,
    but it will return all results where the values contain the given parameter.

    Example result: search[name]=twi
    """
    def search(request, field, contains) do
      "search[" <> field <> "]=" <> contains
      |> append_parameter(request)
    end

    @doc """
    The range parameter is a hash allowing filtering for a field
    Only values between the given bounds will be returned. The bounds are inclusive.

    Example result: range[hp]=500,1000
    """
    def range(request, field, from, to) do
      "range[" <> field <> "]=" <> from <> "," <> to
      |> append_parameter(request)
    end

    @doc """
    All index endpoints support multiple sort fields and they are applied in the order specified.

    The sort order for each sort field is ascending unless prefixed with a minus "-""),
    in which case it is descending.

    Example end result: sort=-armor,name
    """
    def sort(request, fields) do
      "sort=" <> Enum.join(fields, ",")
      |> append_parameter(request)
    end

    @doc """
    Add a filter query parameter can be used to filter a collection by one for one or more values.

    Example end result: filter[name]=Brand,Twitch
    """
    def filter(request, field, matches) do
      "filter[" <> field <> "]=" <> Enum.join(matches, ",")
      |> append_parameter(request)
    end

    defp append_parameter(parameter, request) do
      %{request | parameters: [parameter | request.parameters]}
    end

    @doc """
    Execute the built request and return the result.
    """
    def execute(request) do
      http_request(request)
      |> Poison.decode
      |> IO.inspect
    end

    defp http_request(request) do
      parameters = ["token=" <> token_secret() | request.parameters]
      final_url = request.url <> "?" <> Enum.join(Enum.reverse(parameters), "&")

      case HTTPoison.get(final_url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body
        {:ok, %HTTPoison.Response{status_code: 403}} ->
          IO.puts "\nInvalid Token\n"
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
        {:error, %HTTPoison.Error{reason: reason}} ->
          reason
      end
    end

    defp token_secret() do
      Application.get_env(:weekly_pickem, :secrets)[:api_pandascore]
    end
end
