defmodule IngredientsPlugTest do
  use ExUnit.Case
  use Plug.Test
  import Hammox

  defmock(MockHTTPClient, for: HTTPoison.Base)

  setup :verify_on_exit!

  describe "init" do
    test "require framework" do
      assert_raise ArgumentError, "framework is missing", fn ->
        IngredientsPlug.init(credentials: [username: "user", password: "pass"])
      end
    end

    test "valid init" do
      assert IngredientsPlug.init(framework: %{name: "framework", version: "1.2.3"}) == [
               date_time: &DateTime.utc_now/0,
               http_client: HTTPoison,
               framework: %{name: "framework", version: "1.2.3"}
             ]
    end
  end

  describe "call" do
    test "get status" do
      System.put_env("COMMIT_SHA", "abc123")

      options = [
        date_time: fn -> ~U[2019-10-04 14:02:07Z] end,
        framework: %{name: "framework", version: "1.2.3"}
      ]

      conn =
        conn(:get, "/__status")
        |> IngredientsPlug.call(options)

      assert json_response(conn, 200) == %{
               "language" => %{"name" => "elixir", "version" => System.version()},
               "vcs" => %{"revision" => "abc123"}
             }
    end
  end

  defp response(%Plug.Conn{resp_body: body, status: status_code}, status_code) do
    body
  end

  defp response(%Plug.Conn{resp_body: body, status: status}, given) do
    raise "expected response with status #{given}, got: #{status}, with body:\n#{body}"
  end

  defp json_response(conn, status_code) do
    response(conn, status_code) |> Jason.decode!()
  end
end
