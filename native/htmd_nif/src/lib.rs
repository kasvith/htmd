use htmd::{options::*, HtmlToMarkdown};
use rustler::{Atom, NifResult, NifStruct, NifTuple};

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

        // hr styles
        dashes,
        underscores,
        stars,

        // br styles
        two_spaces,
        backslash,
    }
}

#[derive(NifTuple)]
pub struct Response {
    /// status atom `:ok` or `:error`
    status: Atom,

    /// result string
    result: String,
}

#[derive(NifStruct)]
#[module = "Htmd.ConvertOptions"]
pub struct ConvertOptions {
    pub heading_style: Option<Atom>,
    pub hr_style: Option<Atom>,
    pub br_style: Option<Atom>,
    pub link_style: Option<Atom>,
    pub link_reference_style: Option<Atom>,
    pub code_block_style: Option<Atom>,
    pub code_block_fence: Option<Atom>,
    pub bullet_list_marker: Option<Atom>,
    pub ul_bullet_spacing: Option<u8>,
    pub ol_number_spacing: Option<u8>,
    pub preformatted_code: Option<bool>,
    pub skip_tags: Option<Vec<String>>,
}

fn heading_style_from_atom(atom: Atom) -> HeadingStyle {
    if atom == atoms::atx() {
        HeadingStyle::Atx
    } else if atom == atoms::setex() {
        HeadingStyle::Setex
    } else {
        HeadingStyle::Atx
    }
}

fn hr_style_from_atom(atom: Atom) -> HrStyle {
    if atom == atoms::dashes() {
        HrStyle::Dashes
    } else if atom == atoms::underscores() {
        HrStyle::Underscores
    } else if atom == atoms::stars() {
        HrStyle::Asterisks
    } else {
        HrStyle::Dashes
    }
}

fn br_style_from_atom(atom: Atom) -> BrStyle {
    if atom == atoms::two_spaces() {
        BrStyle::TwoSpaces
    } else if atom == atoms::backslash() {
        BrStyle::Backslash
    } else {
        BrStyle::TwoSpaces
    }
}

fn link_style_from_atom(atom: Atom) -> LinkStyle {
    if atom == atoms::inlined() {
        LinkStyle::Inlined
    } else if atom == atoms::inlined_prefer_autolinks() {
        LinkStyle::InlinedPreferAutolinks
    } else if atom == atoms::referenced() {
        LinkStyle::Referenced
    } else {
        LinkStyle::Inlined
    }
}

fn link_reference_style_from_atom(atom: Atom) -> LinkReferenceStyle {
    if atom == atoms::full() {
        LinkReferenceStyle::Full
    } else if atom == atoms::collapsed() {
        LinkReferenceStyle::Collapsed
    } else if atom == atoms::shortcut() {
        LinkReferenceStyle::Shortcut
    } else {
        LinkReferenceStyle::Full
    }
}

fn code_block_style_from_atom(atom: Atom) -> CodeBlockStyle {
    if atom == atoms::indented() {
        CodeBlockStyle::Indented
    } else if atom == atoms::fenced() {
        CodeBlockStyle::Fenced
    } else {
        CodeBlockStyle::Indented
    }
}

fn code_block_fence_from_atom(atom: Atom) -> CodeBlockFence {
    if atom == atoms::tildes() {
        CodeBlockFence::Tildes
    } else if atom == atoms::backticks() {
        CodeBlockFence::Backticks
    } else {
        CodeBlockFence::Backticks
    }
}

fn bullet_list_marker_from_atom(atom: Atom) -> BulletListMarker {
    if atom == atoms::asterisk() {
        BulletListMarker::Asterisk
    } else if atom == atoms::dash() {
        BulletListMarker::Dash
    } else {
        BulletListMarker::Asterisk
    }
}

impl From<ConvertOptions> for Options {
    fn from(opts: ConvertOptions) -> Self {
        let mut options = Options::default();

        if let Some(heading_style) = opts.heading_style {
            options.heading_style = heading_style_from_atom(heading_style);
        }

        if let Some(hr_style) = opts.hr_style {
            options.hr_style = hr_style_from_atom(hr_style);
        }

        if let Some(br_style) = opts.br_style {
            options.br_style = br_style_from_atom(br_style);
        }

        if let Some(link_style) = opts.link_style {
            options.link_style = link_style_from_atom(link_style);
        }

        if let Some(link_reference_style) = opts.link_reference_style {
            options.link_reference_style = link_reference_style_from_atom(link_reference_style);
        }

        if let Some(code_block_style) = opts.code_block_style {
            options.code_block_style = code_block_style_from_atom(code_block_style);
        }

        if let Some(code_block_fence) = opts.code_block_fence {
            options.code_block_fence = code_block_fence_from_atom(code_block_fence);
        }

        if let Some(bullet_list_marker) = opts.bullet_list_marker {
            options.bullet_list_marker = bullet_list_marker_from_atom(bullet_list_marker);
        }

        if let Some(preformatted_code) = opts.preformatted_code {
            options.preformatted_code = preformatted_code;
        }

        options
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
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

#[rustler::nif(schedule = "DirtyCpu")]
fn convert_with_options(html: String, options: ConvertOptions) -> NifResult<Response> {
    // Extract skip_tags before moving options
    let skip_tags = options.skip_tags.clone();
    let htmd_options: Options = options.into();
    let mut builder = HtmlToMarkdown::builder().options(htmd_options);

    // Handle skip_tags separately since it's not part of Options struct
    if let Some(skip_tags) = skip_tags {
        let str_tags: Vec<&str> = skip_tags.iter().map(|s| s.as_str()).collect();
        builder = builder.skip_tags(str_tags);
    }

    let converter = builder.build();
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
