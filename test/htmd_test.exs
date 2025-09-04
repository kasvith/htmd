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
      assert markdown =~ "_italic_"
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
end
