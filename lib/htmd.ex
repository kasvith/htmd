defmodule Htmd do
  @moduledoc """
  A fast HTML to Markdown converter for Elixir, powered by Rust.

  Htmd provides a high-performance HTML to Markdown conversion using the Rust htmd crate
  as a Native Implemented Function (NIF). It supports extensive customization options
  for controlling the output format.

  ## Basic Usage

      iex> Htmd.convert("<h1>Hello World</h1>")
      {:ok, "# Hello World"}

  ## Advanced Usage with Options

      iex> Htmd.convert("<h1>Title</h1><ul><li>Item</li></ul>", [
      ...>   heading_style: :setex,
      ...>   bullet_list_marker: :dash,
      ...>   skip_tags: ["script", "style"]
      ...> ])
      {:ok, "Title\\n=====\\n\\n-   Item"}

  ## Performance

  This library leverages Rust's performance for HTML parsing and Markdown generation,
  making it suitable for high-throughput applications that need to convert large amounts
  of HTML content.

  ## Configuration Options

  Supports all major Markdown formatting options including heading styles, list markers,
  link styles, code block formatting, and tag filtering. See `convert/2` for complete
  documentation of available options.
  """

  alias Htmd.{Native, ConvertOptions}

  @type html :: String.t()
  @type markdown :: String.t()
  @type error_reason :: String.t()
  @type options :: ConvertOptions.t() | keyword()

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

  @doc """
  Converts HTML string to Markdown with options.

  ## Options

    * `:heading_style` - `:atx` (default) or `:setex`
    * `:hr_style` - `:dashes` (default), `:underscores`, or `:stars`
    * `:br_style` - `:two_spaces` (default) or `:backslash`
    * `:link_style` - `:inlined` (default), `:inlined_prefer_autolinks`, or `:referenced`
    * `:link_reference_style` - `:full` (default), `:collapsed`, or `:shortcut`
    * `:code_block_style` - `:indented` (default) or `:fenced`
    * `:code_block_fence` - `:backticks` (default) or `:tildes`
    * `:bullet_list_marker` - `:asterisk` (default) or `:dash`
    * `:ul_bullet_spacing` - non-negative integer for spaces between bullet and content
    * `:ol_number_spacing` - non-negative integer for spaces between number and content
    * `:preformatted_code` - boolean to preserve whitespace in inline code tags
    * `:skip_tags` - list of tag names to skip during conversion

  ## Examples

      iex> Htmd.convert("<h1>Hello</h1>", heading_style: :setex)
      {:ok, "Hello\\n====="}

      iex> Htmd.convert("<img src='test.jpg'>", skip_tags: ["img"])
      {:ok, ""}

  """
  @spec convert(html, options) :: {:ok, markdown} | {:error, error_reason}
  def convert(html, options) when is_binary(html) do
    convert_options = build_options(options)
    Native.convert_with_options(html, convert_options)
  end

  @doc """
  Converts HTML string to Markdown, silently returning an empty string on error.
  ## Examples

      iex> Htmd.convert!("<h1>Hello World</h1>")
      "# Hello World"

      iex> Htmd.convert!("<p>Simple paragraph</p>")
      "Simple paragraph"

  """
  @spec convert!(html, options) :: binary()
  def convert!(html, options \\ []) when is_binary(html) do
    case convert(html, options) do
      {:ok, markdown} -> markdown
      {:error, _} -> ""
    end
  end

  defp build_options(options) when is_list(options) do
    struct(ConvertOptions, options)
  end

  defp build_options(%ConvertOptions{} = options), do: options
end
