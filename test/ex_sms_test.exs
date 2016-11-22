defmodule ExSmsTest do
  use ExUnit.Case

  setup do
    {:ok, _} = :application.ensure_all_started(:httparrot)
    :ok
  end

  defmodule SignSms do
    use ExSms
  end

  test "module use ExSms should get the send && multi_send method" do
    methods = Keyword.keys SignSms.__info__(:functions)

    assert :send in methods
    assert :multi_send in methods
    assert :project in methods
  end

  test "should send the right post body through http_post method" do
    response = ExSms.http_post([url: "http://localhost:8080/post", body: "post_body=body&method=post",
                                headers: [{"Content-Type", "application/x-www-form-urlencoded"}]])

    assert response[:form] == %{method: "post", post_body: "body"}
  end

  test "should send the post body with the right header" do
    response = ExSms.http_post([url: "http://localhost:8080/post", body: "post_body",
                                headers: [{"content-type", "application/json"}]])

    assert {:"content-type", "application/json"} in response[:headers]
  end

  test "should get error reason when http request got error" do
    import :meck
    new :hackney
    expect(:hackney, :request, 5, {:error, {:closed, "Something happened"}})

    response = ExSms.http_post([url: "http://localhost", body: "body", headers: []])

    assert response == {:error, {:closed, "Something happened"}}
    unload
  end
end
