defmodule IngredientsPlug do
  import Plug.Conn

  def init(options) do
    Keyword.merge([date_time: &DateTime.utc_now/0, http_client: HTTPoison], options)
  end

  def call(%Plug.Conn{request_path: "/__status"} = conn, _options) do
    data =
      %{
        language: %{name: "elixir", version: System.version()}
      }
      |> append_birthday()
      |> append_revision_and_modified()

    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(
      200,
      Jason.encode!(data)
    )
    |> halt
  end

  def call(conn, _options), do: conn

  defp append_birthday(map) do
    {:ok, birthdatetime} =
      System.build_info().date |> Timex.parse("{YYYY}-{0M}-{D}T{h24}:{m}:{s}Z")

    {:ok, birthday} = birthdatetime |> Timex.format("{YYYY}-{0M}-{D}")

    Map.put(map, :service, %{birthday: birthday})
  end

  defp append_revision_and_modified(map) do
    {hash, _} = System.cmd("git", ["rev-parse", "HEAD"])
    revision = String.trim(hash)
    {datetime, _} = System.cmd("git", ["log", "-1", "--format=%cd"])

    {:ok, parsed_datetime} =
      datetime |> String.trim() |> Timex.parse("%a %b %d %T %Y %z", :strftime)

    {:ok, date} = parsed_datetime |> Timex.format("{YYYY}-{0M}-{D}")
    Map.put(map, :vcs, %{revision: revision, time: date})
  end
end
