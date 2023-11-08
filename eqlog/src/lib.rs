mod eqlog_util;
mod grammar_util;
mod semantics;
mod sort_if_stmts_pass;
use lalrpop_util::lalrpop_mod;
lalrpop_mod!(grammar);
mod build;
mod error;
mod flat_ast;
mod flat_eqlog;
mod flat_to_llam;
mod flatten;
mod fmt_util;
mod fork_suffix_pass;
mod index_selection;
mod llam;
mod rust_gen;
mod slice_group_by;
mod source_display;
mod var_info_pass;

pub use crate::build::{process, process_root, Config};
