defmodule Htmd do
  @moduledoc """
  A fast HTML to Markdown converter for Elixir, powered by Rust.
  """

  alias Htmd.Native

  @type html :: String.t()
  @type markdown :: String.t()
  @type error_reason :: String.t()

  @doc """
  Converts HTML string to Markdown.

  ## Examples

      iex> Htmd.convert("<h1>Hello World</h1>")
      {:ok, "# Hello World"}

      iex> Htmd.convert("<p>Simple paragraph</p>")
      {:ok, "Simple paragraph"}

  """
  @spec convert(html) :: {:ok, markdown} | {:error, error_reason}
  def convert(html) when is_binary(html) do
    Native.convert(html)
  end
end
