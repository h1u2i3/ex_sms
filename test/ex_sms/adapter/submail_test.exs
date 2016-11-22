defmodule ExSms.Adapter.SubmailTest do
  use ExUnit.Case

  defmodule SignSms do
    use ExSms

    def project do
      "test"
    end
  end

  test "should generate the right single adapter data" do
    data = ExSms.Adapter.Submail.single_adapter([to: "13888888888", vars: %{code: "123456"}], SignSms)

    assert data[:url] == "https://api.submail.cn/message/xsend"
    assert data[:body] == "appid=appid&to=13888888888&project=test&vars={\"code\":\"123456\"}&sign_type=no" <>
      "rmal&signature=signature"
  end

  test "should generate the right multi adapter data" do
    data = ExSms.Adapter.Submail.multi_adapter([multi: [%{to: "123456", vars: %{code: "123"}},
              %{to: "1256", vars: %{code: "456"}}]], SignSms)

    assert data[:url] == "https://api.submail.cn/message/multixsend"
    assert data[:body] == "appid=appid&project=test&multi=[{\"vars\":{\"code\":\"123\"},\"to\":\"1234" <>
      "56\"},{\"vars\":{\"code\":\"456\"},\"to\":\"1256\"}]&signature=signature"
  end
end
