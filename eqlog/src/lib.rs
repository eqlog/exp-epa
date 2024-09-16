mod eqlog_util;
mod grammar_util;
mod semantics;
use lalrpop_util::lalrpop_mod;
lalrpop_mod!(grammar);
mod build;
#[allow(dead_code)]
mod debug;
mod error;
mod flat_eqlog;
mod flatten;
mod fmt_util;
mod rust_gen;
mod source_display;

pub use crate::build::{process, process_root, Config};
