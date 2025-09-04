use htmd::HtmlToMarkdown;
use rustler::{Atom, NifResult, NifTuple};

mod atoms {
    rustler::atoms! {
        // common

        ok,
        error,

        // htmd options

        // link styles
        inlined,
        inlined_prefer_autolinks,
        referenced,

        // link reference styles
        full,
        collapsed,
        shortcut,

        // code block styles
        indented,
        fenced,

        // code block fence
        tildes,
        backticks,

        // bullet list marker
        asterisk,
        dash,

        // heading styles
        setex,
        atx,
    }
}

#[derive(NifTuple)]
pub struct Response {
    /// status atom `:ok` or `:error`
    status: Atom,

    /// result string
    result: String,
}

#[rustler::nif]
fn convert(html: String) -> NifResult<Response> {
    let converter = HtmlToMarkdown::new();
    match converter.convert(&html) {
        Ok(markdown) => Ok(Response {
            status: atoms::ok(),
            result: markdown,
        }),
        Err(e) => Ok(Response {
            status: atoms::error(),
            result: e.to_string(),
        }),
    }
}

rustler::init!("Elixir.Htmd.Native");
