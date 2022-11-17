defmodule IngredientsPlug do
  import Plug.Conn

  def init(options) do
    unless Keyword.has_key?(options, :framework) do
      raise ArgumentError, "framework is missing"
    end

    Keyword.merge([date_time: &DateTime.utc_now/0, http_client: HTTPoison], options)
  end

  def call(%Plug.Conn{request_path: "/__status"} = conn, options) do
    data =
      %{
        language: %{name: "elixir", version: System.version()},
        vcs: %{
          revision: System.build_info().revision,
          time: System.build_info().date
        }
      }
      |> append_birthday(options)
      |> IO.inspect()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(data)
    )
    |> halt
  end

  def call(conn, _options), do: conn

  def append_birthday(data, options) do
    case Keyword.has_key?(options, :birthday) do
      false -> data
      true -> Map.put(data, :service, %{birthday: Keyword.fetch!(options, :birthday)})
    end
  end
end
