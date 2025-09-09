# Htmd

[![Hex Version](https://img.shields.io/hexpm/v/htmd.svg)](https://hex.pm/packages/htmd)
![Hex.pm Downloads](https://img.shields.io/hexpm/dt/htmd)
[![Hex Docs](http://img.shields.io/badge/hex.pm-docs-green.svg?style=flat)](https://hexdocs.pm/htmd)
[![Mix Test](https://github.com/kasvith/htmd/actions/workflows/test.yml/badge.svg)](https://github.com/kasvith/htmd/actions/workflows/test.yml)

A fast HTML to Markdown converter for Elixir, powered by Rust.

Htmd provides high-performance HTML to Markdown conversion using the Rust [htmd crate](https://crates.io/crates/htmd) as a Native Implemented Function (NIF). It offers extensive customization options for controlling the output format and is designed for applications that need to process large amounts of HTML content efficiently.

## Features

- **High Performance**: Leverages Rust's speed for HTML parsing and Markdown generation
- **Extensive Configuration**: Support for all major Markdown formatting options
- **Tag Filtering**: Skip specific HTML tags during conversion
- **Multiple Formats**: Support for different heading styles, list markers, link formats, and more
- **Safe**: Uses Rustler for safe Rust-Elixir interop

## Installation

Add `htmd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:htmd, "~> 0.2.0"}
  ]
end
```

## Basic Usage

```elixir
# Simple conversion
{:ok, markdown} = Htmd.convert("<h1>Hello World</h1>")
# => {:ok, "# Hello World"}

# Convert a paragraph
{:ok, markdown} = Htmd.convert("<p>This is a paragraph with <strong>bold</strong> text.</p>")
# => {:ok, "This is a paragraph with **bold** text."}

# Convert links
{:ok, markdown} = Htmd.convert("<a href='https://example.com'>Example</a>")
# => {:ok, "[Example](https://example.com)"}

# Use the bang version for direct result(shh!! we are silently ignoring errors here)
markdown = Htmd.convert!("<h2>Subtitle</h2>")
# => "## Subtitle"
```

## Advanced Usage with Options

```elixir
html = """
<h1>My Document</h1>
<ul>
  <li>First item</li>
  <li>Second item</li>
</ul>
<img src="image.jpg" alt="Skip this">
<p>Final paragraph</p>
"""

{:ok, markdown} = Htmd.convert(html, [
  heading_style: :setex,           # Use underline-style headers
  bullet_list_marker: :dash,       # Use dashes for bullet points
  skip_tags: ["img"],             # Skip image tags
  link_style: :referenced         # Use reference-style links
])
```

## Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `:heading_style` | `:atx` \| `:setex` | `:atx` | Header format (# vs underline) |
| `:hr_style` | `:dashes` \| `:underscores` \| `:stars` | `:dashes` | Horizontal rule style |
| `:br_style` | `:two_spaces` \| `:backslash` | `:two_spaces` | Line break format |
| `:link_style` | `:inlined` \| `:inlined_prefer_autolinks` \| `:referenced` | `:inlined` | Link format style |
| `:link_reference_style` | `:full` \| `:collapsed` \| `:shortcut` | `:full` | Reference link format |
| `:code_block_style` | `:indented` \| `:fenced` | `:indented` | Code block format |
| `:code_block_fence` | `:backticks` \| `:tildes` | `:backticks` | Fence character for code blocks |
| `:bullet_list_marker` | `:asterisk` \| `:dash` | `:asterisk` | Bullet point character |
| `:ul_bullet_spacing` | `non_neg_integer()` | `3` | Spaces between bullet and content |
| `:ol_number_spacing` | `non_neg_integer()` | `3` | Spaces between number and content |
| `:preformatted_code` | `boolean()` | `false` | Preserve whitespace in inline code |
| `:skip_tags` | `[String.t()]` | `[]` | HTML tags to skip during conversion |

## Examples with Different Styles

### Heading Styles

```elixir
# ATX style (default)
Htmd.convert("<h1>Title</h1>", heading_style: :atx)
# => {:ok, "# Title"}

# Setex style  
Htmd.convert("<h1>Title</h1>", heading_style: :setex)  
# => {:ok, "Title\n====="}
```

### List Styles

```elixir
# Asterisk bullets (default)
Htmd.convert("<ul><li>Item</li></ul>", bullet_list_marker: :asterisk)
# => {:ok, "*   Item"}

# Dash bullets
Htmd.convert("<ul><li>Item</li></ul>", bullet_list_marker: :dash)  
# => {:ok, "-   Item"}
```

### Link Styles

```elixir
# Inline links (default)
Htmd.convert("<a href='https://example.com'>Link</a>", link_style: :inlined)
# => {:ok, "[Link](https://example.com)"}

# Reference links
Htmd.convert("<a href='https://example.com'>Link</a>", link_style: :referenced)
# => {:ok, "[Link][1]\n\n[1]: https://example.com"}
```

## Performance

Htmd is designed for high-throughput applications. The Rust implementation provides:

- Fast HTML parsing using html5ever
- Efficient string processing  
- Minimal memory allocations
- Safe concurrent usage

## Requirements

- Elixir 1.12 or later
- Rust toolchain (for compilation)
- Compatible with OTP 24+

## Documentation

Full documentation is available on [HexDocs](https://hexdocs.pm/htmd).

## License

This project is licensed under the MIT License.

