defmodule Htmd.Native do
  use Rustler, otp_app: :htmd, crate: "htmd"

  alias Htmd.ConvertOptions

  @type html :: String.t()
  @type markdown :: String.t()
  @type error_reason :: String.t()

  @spec convert(html) :: {:ok, markdown} | {:error, error_reason}
  def convert(_html), do: :erlang.nif_error(:nif_not_loaded)

  @spec convert_with_options(html, ConvertOptions.t()) :: {:ok, markdown} | {:error, error_reason}
  def convert_with_options(_html, _options), do: :erlang.nif_error(:nif_not_loaded)
end
