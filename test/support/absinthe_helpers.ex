# This helper is from Tony Osbourn at Tosbourn.com
# https://tosbourn.com/testing-absinthe-exunit/
defmodule WeeklyPickemWeb.AbsintheHelpers do

  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  def mutation_skeleton(query) do
    %{
      "operationName" => "",
      "query" => "#{query}",
      "variables" => ""
    }
  end
end
