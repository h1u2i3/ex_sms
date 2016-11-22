defmodule ExSms.Adapter.Submail do
  @moduledoc """
  The Submail Adapter. https://submail.cn
  """

  alias ExSms.Adapter.Submail.Single
  alias ExSms.Adapter.Submail.Multi

  @endpoint "https://api.submail.cn/message"

  @doc """
  submail xsend api.

    http: post
    path: /xsend
    data:
      appid=your_appid&
      to=138xxxxxxxx&
      project=Txxxks&
      signature=your_appkey&
      vars={
        "code": "234564" }

    params(Keyword):
      to: cellphonenumber
      project: project number
      vars: json var string

  the appid and signature will get from ENV.
  """
  def single_adapter(params, api) do
    url = @endpoint <> "/xsend"
    body =
      Single
      |> struct(params)
      |> add_config_data(api)
      |> generate_data(:single)

    [url: url, body: body,
     headers: [{"Content-Type", "application/x-www-form-urlencoded"}]]
  end

  @doc """
  submail multixsend api

    http: post
    path: /multixsend
    data:
      appid=your_app_id&
      project=Emssl&
      multi=[
        {
          "to": "15900112245",
          "vars": {
            "name": "xxxky"
          }
        }
      ]&
      signature=your_appkey

    params(Keyword):
      to: cellphonenumber
      project: project number
      multi: json var string

  the appid and signature will get from ENV.
  """
  def multi_adapter(params, api) do
    url = @endpoint <> "/multixsend"
    body =
      Multi
      |> struct(params)
      |> add_config_data(api)
      |> generate_data(:multi)

    [url: url, body: body,
     headers: [{"Content-Type", "application/x-www-form-urlencoded"}]]
  end

  defp add_config_data(struct, api) do
    struct
    |> struct(%{
        appid: appid,
        signature: signature,
        project: api.project})
  end

  defp generate_data(struct, mode) do
    case mode do
      :single -> Single.data(struct)
      :multi  -> Multi.data(struct)
    end
  end

  defp appid do
    Application.get_env(:ex_sms, ExSms.Adapter.Submail)[:appid]
  end

  defp signature do
    Application.get_env(:ex_sms, ExSms.Adapter.Submail)[:signature]
  end

  defmodule Single do
    @moduledoc """
    The data struct with single send.
    """

    defstruct appid: nil, to: nil, project: nil, vars: nil,
              timestamp: nil, sign_type: "normal", signature: nil

    def data(struct) do
      struct
      |> Map.delete(:__struct__)
      |> generate_string
    end

    defp generate_string(struct) do
      ~w/appid to project vars timestamp sign_type signature/a
      |> Enum.map(&get_string(struct, &1))
      |> Enum.reject(&("" == &1))
      |> Enum.join("&")
    end

    defp get_string(struct, key) do
      value = struct[key]
      case value do
        nil -> ""
        _   ->
          if key == :vars do
            "#{key}=#{Poison.encode!(value)}"
          else
            "#{key}=#{value}"
          end
      end
    end
  end

  defmodule Multi do
    @moduledoc """
    The data struct with multi send.
    """

    defstruct appid: nil, project: nil, multi: nil, signature: nil

    def data(struct) do
      struct
      |> Map.delete(:__struct__)
      |> generate_body
    end

    defp generate_body(struct) do
      ~w/appid project multi signature/a
      |> Enum.map(&get_string(struct, &1))
      |> Enum.reject(&("" == &1))
      |> Enum.join("&")
    end

    defp get_string(struct, key) do
      value = struct[key]
      case value do
        nil -> ""
        _   ->
          if key == :multi do
            "#{key}=#{Poison.encode!(value)}"
          else
            "#{key}=#{value}"
          end
      end
    end
  end
end
