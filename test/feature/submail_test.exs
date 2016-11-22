defmodule ExSms.SubmailTest do
  use ExUnit.Case

  defmodule Sign do
    use ExSms, api: ExSms.Adapter.Submail

    def project do
      "sign"
    end
  end

  defmodule Notice do
    use ExSms, api: ExSms.Adapter.Submail

    def project do
      "notice"
    end
  end

  test "should get the right project name" do
    data_sign = ExSms.Adapter.Submail.single_adapter([to: "123456", vars: %{code: "!23"}], Sign)
    data_notice = ExSms.Adapter.Submail.single_adapter([to: "123456", vars: %{code: "!23"}], Notice)

    assert String.contains? data_sign[:body], "project=sign"
    assert String.contains? data_notice[:body], "project=notice"
  end

end
