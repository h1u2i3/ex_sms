defmodule ExSms do

  def http_post(params) do
    case HTTPoison.post(params[:url], params[:body], [{"Content-Type", "application/x-www-form-urlencoded"}]) do
      {:ok, response} ->
        Poison.decode! response.body
      {:error, error} ->
        {:error, error.reason}
    end
  end

  defmacro __using__(opts) do
    module = opts[:api] || ExSms.Adapter.Submail

    quote do
      def send(params) do
        HTTPoison.start
        params
        |> unquote(module).single_adapter(__MODULE__)
        |> ExSms.http_post
      end

      def multi_send(params) do
        HTTPoison.start
        params
        |> unquote(module).multi_adapter(__MODULE__)
        |> ExSms.http_post
      end

      def project do
        :not_set
      end
      defoverridable [project: 0]
    end
  end
end
