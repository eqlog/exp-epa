mod test;
pub mod ast;

lalrpop_mod!(#[allow(unused_parens, dead_code)] pub parser, "/lang/qt.rs");
