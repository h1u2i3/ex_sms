defmodule ExSms.AdapterTest do
  use ExUnit.Case

  setup do
    {:ok, _} = :application.ensure_all_started(:httparrot)
    :ok
  end

  defmodule ExampleAdapter do
    @endpoint "http://localhost:8080/post"

    def single_adapter(params, _api) do
      [url: @endpoint, body: params, headers: [{"content-type", "application/json"}]]
    end

    def multi_adapter(params, _api) do
      [url: @endpoint, body: params, headers: [{"content-type", "application/json"}]]
    end
  end

  defmodule Notice do
    use ExSms, api: ExampleAdapter
  end

  test "should send the right data" do
    response = Notice.send("xyz")

    assert response[:data] == "xyz"
  end
end
