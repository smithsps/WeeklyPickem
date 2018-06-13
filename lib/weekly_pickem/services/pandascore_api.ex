defmodule WeeklyPickem.Services.PandaScoreAPI do

  @endpoint "https://api.pandascore.co/"

  defmodule ApiRequest do
    defstruct url: nil, url_parameters: [], headers: %{}
  end

  @doc """
  Starts building a new PandaScore API request
  """
  def new_request(path) do
    %ApiRequest{url: @endpoint <> path}
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

  defp page(request, page_number) do
    "page=" <> Integer.to_string(page_number)
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

  def results_per_page(request, results_per_page) do
    "per_page=" <> results_per_page
    |> append_parameter(request)
  end

  defp append_parameter(parameter, request) do
    %{request | url_parameters: [parameter | request.url_parameters]}
  end

  defp _add_header(request, header_key, header_value) do
    %{request | headers: Map.put(request.headers, header_key, header_value)}
  end

  @doc """
  Execute the built request and return the result.
  """
  def execute(request) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} = http_request(request)

    # Automatic pagination
    IO.inspect headers

    # Enum.each reponses, fn response ->

    # end
    Poison.decode!(body)
  end

  def execute_all_pages(request, page \\ 1) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} =
      request
      |> page(page)
      |> http_request

    IO.inspect headers

    {total, _} = Integer.parse(header_get(headers, "X-Total"))
    {per_page, _} = Integer.parse(header_get(headers, "X-Per-Page"))
    {current_page, _} = Integer.parse(header_get(headers, "X-Page"))

    combined_results = Poison.decode!(body)

    cond do
      current_page * per_page < total ->
        execute_all_pages(request, current_page + 1) ++ combined_results

      true ->
        combined_results
    end
  end

  defp http_request(request) do
    url_parameters = ["token=" <> token_secret() | request.url_parameters]
    final_url = request.url <> "?" <> Enum.join(Enum.reverse(url_parameters), "&")

    HTTPoison.get(final_url, [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    #  do
    #   {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: header}} ->
    #     {body, header}
    #   {:ok, %HTTPoison.Response{status_code: 403}} ->
    #     IO.puts "\nInvalid Token\n"
    #   {:ok, %HTTPoison.Response{status_code: 404}} ->
    #     IO.puts "Not found :("
    #   {:error, %HTTPoison.Error{reason: reason}} ->
    #     reason
    # end
  end

  defp header_get(headers, name) do
    case Enum.find(headers, fn(x) -> elem(x, 0) == name end) do
      nil ->
        nil
      {_header_name, header_value} ->
        header_value
    end
  end

  defp token_secret() do
    Application.get_env(:weekly_pickem, :secrets)[:api_pandascore]
  end
end
