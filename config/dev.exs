use Mix.Config


config :ex_sms, ExSms.Adapter.Submail,
  appid: System.get_env("SUBMAIL_APPID"),
  signature: System.get_env("SUBMAIL_APPKEY")
