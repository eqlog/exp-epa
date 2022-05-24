use crate::ast;
use crate::cwf::*;
use std::collections::HashMap;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Checking {
    Yes,
    No,
}

#[derive(Clone, Debug)]
struct Definition {
    base_context: Ctx,
    extensions: Vec<(Ty, Ctx)>,
    term: Tm,
}

#[derive(Clone, Debug)]
pub struct Scope {
    definitions: HashMap<String, Definition>,
    empty_context: Ctx,
    extensions: Vec<(Ty, Ctx)>,
    cwf: Cwf,
}

impl Scope {
    pub fn new() -> Self {
        let mut cwf = Cwf::new();
        let empty_context = cwf.new_ctx();
        Scope {
            definitions: HashMap::new(),
            empty_context,
            extensions: Vec::new(),
            cwf,
        }
    }
}

impl Scope {
    fn current_context(&self) -> Ctx {
        self.extensions
            .last()
            .map(|(_, ctx)| *ctx)
            .unwrap_or(self.empty_context)
    }

    fn add_weakening_from_base(&mut self, def: &Definition) -> Mor {
        let base_to_current_exts: &[(Ty, Ctx)] = match self
            .extensions
            .iter()
            .position(|(_, ctx)| *ctx == def.base_context)
        {
            None => {
                debug_assert_eq!(self.empty_context, def.base_context);
                self.extensions.as_slice()
            }
            Some(i) => &self.extensions[(i + 1)..],
        };

        let mut ctx = def.base_context;
        let mut w = self.cwf.define_id(ctx);
        for (ty, ext_ctx) in base_to_current_exts.iter().copied() {
            let wkn = self.cwf.define_wkn(ctx, ty);
            w = self.cwf.define_comp(wkn, w);
            ctx = ext_ctx;
        }
        w
    }

    fn add_substitution(&mut self, checking: Checking, def: &Definition, args: &[Tm]) -> Mor {
        if checking == Checking::Yes {
            assert_eq!(args.len(), def.extensions.len())
        }
        let mut subst = self.add_weakening_from_base(def);
        let mut subst_dom = def.base_context;
        for (arg, (ty, ext_ctx)) in args.iter().copied().zip(def.extensions.iter().copied()) {
            let subst_ty = self.cwf.define_subst_ty(subst, ty);
            if checking == Checking::Yes {
                let arg_ty = self.cwf.define_tm_ty(arg);
                self.cwf.close();
                assert_eq!(self.cwf.ty_root(subst_ty), self.cwf.ty_root(arg_ty));
            } else {
                self.cwf.insert_tm_ty(TmTy(arg, subst_ty));
            }
            subst = self.cwf.define_mor_ext(subst_dom, ty, subst, arg);
            subst_dom = ext_ctx;
        }
        subst
    }

    fn add_type(&mut self, checking: Checking, ty: &ast::Ty) -> Ty {
        match ty {
            ast::Ty::Unit => self.cwf.define_unit(self.current_context()),
            ast::Ty::Eq(lhs, rhs) => {
                let lhs = self.add_term(checking, lhs);
                let rhs = self.add_term(checking, rhs);

                if checking == Checking::Yes {
                    let lhs_ty = self.cwf.define_tm_ty(lhs);
                    let rhs_ty = self.cwf.define_tm_ty(lhs);
                    self.cwf.close();
                    assert_eq!(self.cwf.ty_root(lhs_ty), self.cwf.ty_root(rhs_ty));
                }
                self.cwf.define_eq(lhs, rhs)
            }
        }
    }
    fn add_term(&mut self, checking: Checking, tm: &ast::Tm) -> Tm {
        match tm {
            ast::Tm::Variable(name) => {
                let def = self.definitions.get(name).unwrap().clone();
                let wkn = self.add_weakening_from_base(&def);
                self.cwf.define_subst_tm(wkn, def.term)
            }
            ast::Tm::Typed { tm, ty } => {
                let tm = self.add_term(checking, tm);
                let ty = self.add_type(checking, ty);
                if checking == Checking::Yes {
                    let tm_ty = self.cwf.define_tm_ty(tm);
                    self.cwf.close();
                    assert_eq!(self.cwf.ty_root(tm_ty), self.cwf.ty_root(ty));
                }
                tm
            }
            ast::Tm::App { fun, args } => {
                let def = self.definitions.get(fun).unwrap().clone();
                let args: Vec<Tm> = args
                    .iter()
                    .map(|arg| self.add_term(checking, arg))
                    .collect();
                let subst = self.add_substitution(checking, &def, args.as_slice());
                self.cwf.define_subst_tm(subst, def.term)
            }
            ast::Tm::Let { body, result } => {
                let before_defs = self.definitions.clone();
                for def in body {
                    self.add_definition(checking, def);
                }
                let result = self.add_term(checking, result);
                self.definitions = before_defs;
                result
            }
            ast::Tm::UnitTm => self.cwf.define_unit_tm(self.current_context()),
            ast::Tm::Refl(s) => {
                let s = self.add_term(checking, s);
                self.cwf.define_refl(s)
            }
        }
    }
    // Adjoing indeterminate term of a given type, do not change context.
    fn adjoin_variable(&mut self, checking: Checking, name: &str, ty: &ast::Ty) {
        let ty = self.add_type(checking, ty);
        let var = self.cwf.new_tm();
        self.cwf.insert_tm_ty(TmTy(var, ty));
        self.definitions.insert(
            name.to_string(),
            Definition {
                base_context: self.current_context(),
                extensions: Vec::new(),
                term: var,
            },
        );
    }
    // Extend context by a variable.
    fn extend_context(&mut self, checking: Checking, name: &str, ty: &ast::Ty) {
        let ty = self.add_type(checking, ty);
        let base_ctx = self.current_context();
        let ext_ctx = self.cwf.define_ext_ctx(base_ctx, ty);
        let var = self.cwf.define_var(base_ctx, ty);
        self.extensions.push((ty, ext_ctx));
        self.definitions.insert(
            name.to_string(),
            Definition {
                base_context: ext_ctx,
                extensions: Vec::new(),
                term: var,
            },
        );
    }

    pub fn add_definition(&mut self, checking: Checking, def: &ast::Def) {
        use ast::Def::*;
        match def {
            Dump => {
                println!("{:?}", self);
            }
            Def { name, args, ty, tm } if args.is_empty() => {
                let tm = self.add_term(checking, tm);
                let ty = self.add_type(checking, ty);
                if checking == Checking::Yes {
                    let tm_ty = self.cwf.define_tm_ty(tm);
                    self.cwf.close();
                    assert_eq!(self.cwf.ty_root(tm_ty), self.cwf.ty_root(ty));
                } else {
                    self.cwf.insert_tm_ty(TmTy(tm, ty));
                }
                self.definitions.insert(
                    name.to_string(),
                    Definition {
                        base_context: self.current_context(),
                        extensions: Vec::new(),
                        term: tm,
                    },
                );
            }
            Def { name, args, ty, tm } => {
                if checking == Checking::Yes {
                    let before_self = self.clone();
                    for (arg_name, arg_ty) in args {
                        self.adjoin_variable(Checking::Yes, arg_name, arg_ty);
                    }
                    let tm = self.add_term(Checking::Yes, tm);
                    let ty = self.add_type(Checking::Yes, ty);
                    let tm_ty = self.cwf.define_tm_ty(tm);
                    self.cwf.close();
                    assert_eq!(self.cwf.ty_root(tm_ty), self.cwf.ty_root(ty));
                    *self = before_self;
                }

                let before_definitions = self.definitions.clone();
                let before_extensions = self.extensions.clone();

                let mut extensions = Vec::new();
                for (arg_name, arg_ty) in args {
                    self.extend_context(Checking::No, arg_name, arg_ty);
                    extensions.push(*self.extensions.last().unwrap())
                }
                let tm = self.add_term(Checking::No, tm);
                let ty = self.add_type(Checking::No, ty);
                self.cwf.insert_tm_ty(TmTy(tm, ty));

                self.definitions = before_definitions;
                self.extensions = before_extensions;

                self.definitions.insert(
                    name.to_string(),
                    Definition {
                        base_context: self.current_context(),
                        extensions,
                        term: tm,
                    },
                );
            }
            UnitInd {
                name,
                var,
                into_ty,
                unit_case,
            } => {
                panic!()
            }
        }
    }
}
