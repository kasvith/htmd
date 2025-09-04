defmodule HtmdTest do
  use ExUnit.Case
  doctest Htmd

  describe "convert/1" do
    test "converts simple HTML to markdown" do
      html = "<h1>Hello World</h1>"
      assert {:ok, markdown} = Htmd.convert(html)
      assert markdown =~ "# Hello World"
    end

    test "converts paragraph tags" do
      html = "<p>This is a paragraph.</p>"
      assert {:ok, markdown} = Htmd.convert(html)
      assert markdown =~ "This is a paragraph."
    end

    test "converts links" do
      html = "<a href=\"https://example.com\">Example</a>"
      assert {:ok, markdown} = Htmd.convert(html)
      assert markdown =~ "[Example](https://example.com)"
    end

    test "converts emphasis tags" do
      html = "<em>italic</em> and <strong>bold</strong>"
      assert {:ok, markdown} = Htmd.convert(html)
      assert markdown =~ "*italic*"
      assert markdown =~ "**bold**"
    end

    test "converts unordered lists" do
      html = "<ul><li>Item 1</li><li>Item 2</li></ul>"
      assert {:ok, markdown} = Htmd.convert(html)
      assert markdown =~ "Item 1"
      assert markdown =~ "Item 2"
    end

    test "handles empty string" do
      assert {:ok, ""} = Htmd.convert("")
    end

    test "handles malformed HTML gracefully" do
      html = "<h1>Unclosed header"
      assert {:ok, _markdown} = Htmd.convert(html)
    end
  end

  describe "convert/2 with options" do
    test "converts with heading_style setex" do
      html = "<h1>Hello World</h1>"
      assert {:ok, markdown} = Htmd.convert(html, heading_style: :setex)
      assert markdown =~ "Hello World\n==========="
    end

    test "converts with heading_style atx" do
      html = "<h1>Hello World</h1>"
      assert {:ok, markdown} = Htmd.convert(html, heading_style: :atx)
      assert markdown =~ "# Hello World"
    end

    test "skips specified tags" do
      html = "<p>Keep this</p><img src='test.jpg' alt='skip this'><p>Keep this too</p>"
      assert {:ok, markdown} = Htmd.convert(html, skip_tags: ["img"])
      assert markdown =~ "Keep this"
      assert markdown =~ "Keep this too"
      refute markdown =~ "skip this"
      refute markdown =~ "test.jpg"
    end

    test "converts with bullet list marker dash" do
      html = "<ul><li>Item 1</li><li>Item 2</li></ul>"
      assert {:ok, markdown} = Htmd.convert(html, bullet_list_marker: :dash)
      assert markdown =~ "-   Item 1"
      assert markdown =~ "-   Item 2"
    end

    test "converts with bullet list marker asterisk" do
      html = "<ul><li>Item 1</li><li>Item 2</li></ul>"
      assert {:ok, markdown} = Htmd.convert(html, bullet_list_marker: :asterisk)
      assert markdown =~ "*   Item 1"
      assert markdown =~ "*   Item 2"
    end

    test "converts with link style referenced" do
      html = "<a href='https://example.com'>Example</a>"
      assert {:ok, markdown} = Htmd.convert(html, link_style: :referenced)
      # Referenced links have the link definition at the bottom
      assert markdown =~ "[Example][1]"
      assert markdown =~ "[1]: https://example.com"
    end

    test "converts with br_style backslash" do
      html = "<p>Line 1<br>Line 2</p>"
      assert {:ok, markdown} = Htmd.convert(html, br_style: :backslash)
      assert markdown =~ "Line 1\\\nLine 2"
    end

    test "converts with code block style fenced" do
      html = "<pre><code>console.log('hello');</code></pre>"
      assert {:ok, markdown} = Htmd.convert(html, code_block_style: :fenced)
      assert markdown =~ "```"
      assert markdown =~ "console.log('hello');"
    end

    test "accepts ConvertOptions struct" do
      html = "<h1>Hello</h1>"
      options = %Htmd.ConvertOptions{heading_style: :setex}
      assert {:ok, markdown} = Htmd.convert(html, options)
      assert markdown =~ "Hello\n====="
    end

    test "handles multiple options together" do
      html = "<h1>Title</h1><ul><li>Item</li></ul><img src='skip.jpg'>"
      options = [
        heading_style: :setex,
        bullet_list_marker: :dash,
        skip_tags: ["img"]
      ]
      assert {:ok, markdown} = Htmd.convert(html, options)
      assert markdown =~ "Title\n====="
      assert markdown =~ "-   Item"
      refute markdown =~ "skip.jpg"
    end
  end
end
