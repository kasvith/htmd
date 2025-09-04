defmodule Htmd.ConvertOptions do
  @moduledoc """
  Options for HTML to Markdown conversion.
  """

  defstruct [
    :heading_style,
    :hr_style,
    :br_style,
    :link_style,
    :link_reference_style,
    :code_block_style,
    :code_block_fence,
    :bullet_list_marker,
    :ul_bullet_spacing,
    :ol_number_spacing,
    :preformatted_code,
    :skip_tags
  ]

  @type t :: %__MODULE__{
          heading_style: :atx | :setex | nil,
          hr_style: :dashes | :underscores | :stars | nil,
          br_style: :two_spaces | :backslash | nil,
          link_style: :inlined | :inlined_prefer_autolinks | :referenced | nil,
          link_reference_style: :full | :collapsed | :shortcut | nil,
          code_block_style: :indented | :fenced | nil,
          code_block_fence: :tildes | :backticks | nil,
          bullet_list_marker: :asterisk | :dash | nil,
          ul_bullet_spacing: non_neg_integer() | nil,
          ol_number_spacing: non_neg_integer() | nil,
          preformatted_code: boolean() | nil,
          skip_tags: [String.t()] | nil
        }
end
