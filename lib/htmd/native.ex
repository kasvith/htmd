defmodule Htmd.Native do
  mix_config = Mix.Project.config()
  version = mix_config[:version]
  github_url = mix_config[:package][:links]["GitHub"]

  targets = ~w(
    aarch64-apple-darwin
    aarch64-unknown-linux-gnu
    aarch64-unknown-linux-musl
    riscv64gc-unknown-linux-gnu
    x86_64-apple-darwin
    x86_64-pc-windows-gnu
    x86_64-pc-windows-msvc
    x86_64-unknown-linux-gnu
    x86_64-unknown-linux-musl
  )

  nif_versions = ~w(2.17 2.16)

  use RustlerPrecompiled,
    otp_app: :htmd,
    crate: "htmd",
    base_url: "#{github_url}/releases/download/v#{version}",
    nif_versions: nif_versions,
    targets: targets,
    version: version,
    force_build: System.get_env("HTMD_BUILD") in ["1", "true"]

  alias Htmd.ConvertOptions

  @type html :: String.t()
  @type markdown :: String.t()
  @type error_reason :: String.t()

  @spec convert(html) :: {:ok, markdown} | {:error, error_reason}
  def convert(_html), do: :erlang.nif_error(:nif_not_loaded)

  @spec convert_with_options(html, ConvertOptions.t()) :: {:ok, markdown} | {:error, error_reason}
  def convert_with_options(_html, _options), do: :erlang.nif_error(:nif_not_loaded)
end
