defmodule Htmd.Native do
  use Rustler, otp_app: :htmd, crate: "htmd"

  @type html :: String.t()
  @type markdown :: String.t()
  @type error_reason :: String.t()

  @spec convert(html) :: {:ok, markdown} | {:error, error_reason}
  def convert(_html), do: :erlang.nif_error(:nif_not_loaded)
end
