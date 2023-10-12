pred absurd();

// ## Identifiers
//
// The `Ident` type corresponds to actual strings that occur in the source
// file. The `VirtIdent` type represent ids that do not occur verbatim in
// source code, but semantically correspond to identifiers. For example, each
// occurence of a wildcard token _ corresponds to a separate `VirtIdent` which
// does not arise from an `Ident`.
type Ident;
type VirtIdent;
func real_virt_ident(Ident) -> VirtIdent;

rule real_virt_ident_total {
    if ident: Ident;
    then real_virt_ident(ident)!;
}

// ## Syntax tree nodes

// TODO: These currently don't carry any data, but they should.
type TypeDeclNode;
pred type_decl(TypeDeclNode, name: Ident);

type ArgDeclNode;
// arg_decl_node_name is optional (but must be unique), arg_decl_node_type is
// mandatory and must be unique.
pred arg_decl_node_name(ArgDeclNode, name: Ident);
pred arg_decl_node_type(ArgDeclNode, typ: Ident);

type ArgDeclListNode;
pred nil_arg_decl_list_node(ArgDeclListNode);
pred cons_arg_decl_list_node(ArgDeclListNode, head: ArgDeclNode, tail: ArgDeclListNode);

type PredDeclNode;
pred pred_decl(PredDeclNode, name: Ident, args: ArgDeclListNode);

type FuncDeclNode;
pred func_decl(FuncDeclNode, name: Ident, args: ArgDeclListNode, result_type: Ident);

type TermNode;

type TermListNode;
pred nil_term_list_node(nil: TermListNode);
pred cons_term_list_node(node: TermListNode, head: TermNode, tail: TermListNode);

type OptTermNode;
pred none_term_node(OptTermNode);
pred some_term_node(OptTermNode, value: TermNode);

pred var_term_node(TermNode, Ident);
pred wildcard_term_node(TermNode);
pred app_term_node(TermNode, function: Ident, args: TermListNode);

type IfAtomNode;
pred equal_if_atom_node(IfAtomNode, lhs: TermNode, rhs: TermNode);
pred defined_if_atom_node(IfAtomNode, term: TermNode);
pred pred_if_atom_node(IfAtomNode, predicate: Ident, args: TermListNode);
pred var_if_atom_node(IfAtomNode, var: TermNode, typ: Ident);

type ThenAtomNode;
pred equal_then_atom_node(ThenAtomNode, lhs: TermNode, rhs: TermNode);
pred defined_then_atom_node(ThenAtomNode, var: OptTermNode, tm: TermNode);
pred pred_then_atom_node(ThenAtomNode, predicate: Ident, args: TermListNode);

type StmtNode;
pred if_stmt_node(StmtNode, IfAtomNode);
pred then_stmt_node(StmtNode, ThenAtomNode);

type StmtListNode;
pred nil_stmt_list_node(nil: StmtListNode);
pred cons_stmt_list_node(node: StmtListNode, head: StmtNode, tail: StmtListNode);

type RuleDeclNode;
pred rule_decl(node: RuleDeclNode, stmts: StmtListNode);

type DeclNode;
pred decl_node_type(DeclNode, TypeDeclNode);
pred decl_node_pred(DeclNode, PredDeclNode);
pred decl_node_func(DeclNode, FuncDeclNode);
pred decl_node_rule(DeclNode, RuleDeclNode);

type DeclListNode;
pred nil_decl_list_node(DeclListNode);
pred cons_decl_list_node(DeclListNode, head: DeclNode, tail: DeclListNode);

type ModuleNode;
pred decls_module_node(ModuleNode, DeclListNode);

// ## Semantic types, predicates and functions

type Type;
type TypeList;
func nil_type_list() -> TypeList;
func cons_type_list(head: Type, tail: TypeList) -> TypeList;
rule type_list_nil_not_cons {
    if nil_type_list() = cons_type_list(_, _);
    then absurd();
}
rule type_list_cons_injective {
    if cons_type_list(head_0, tail_0) = cons_type_list(head_1, tail_1);
    then head_0 = head_1;
    then tail_0 = tail_1;
}

func semantic_type(Ident) -> Type;
rule semantic_decl_type {
    if type_decl(_, ident);
    then semantic_type(ident)!;
}

func semantic_arg_types(ArgDeclListNode) -> TypeList;
rule semantic_arg_types_nil {
    if nil_arg_decl_list_node(n);
    then nil_type_list()!;
    then semantic_arg_types(n) = nil_type_list();
}
rule semantic_arg_types_cons {
    if cons_arg_decl_list_node(arg_decls, head, tail);
    if arg_decl_node_type(head, head_type_name);
    if head_type = semantic_type(head_type_name);
    if tail_types = semantic_arg_types(tail);
    then cons_type_list(head_type, tail_types)!;
    then semantic_arg_types(arg_decls) = cons_type_list(head_type, tail_types);
}

type Pred;
func semantic_pred(Ident) -> Pred;
rule semantic_decl_pred {
    if pred_decl(_, name, _);
    then semantic_pred(name)!;
}


func arity(Pred) -> TypeList;
rule arity_decl {
    if pred_decl(_, pred_name, arg_decls);
    if predicate = semantic_pred(pred_name);
    if arg_types = semantic_arg_types(arg_decls);
    then arity(predicate) = arg_types;
}

type Func;
func semantic_func(Ident) -> Func;
rule semantic_decl_func {
    if func_decl(_, name, _, _);
    then semantic_func(name)!;
}

func domain(Func) -> TypeList;
func codomain(Func) -> Type;
rule domain_decl {
    if func_decl(_, func_name, arg_decls, result_type_name);
    if function = semantic_func(func_name);
    if domain_types = semantic_arg_types(arg_decls);
    if result_type = semantic_type(result_type_name);
    then domain(function) = domain_types;
    then codomain(function) = result_type;
}

// ## Structures

type Structure;

type El;

type ElList;
func nil_el_list(Structure) -> ElList;
func cons_el_list(head: El, tail: ElList) -> ElList;

rule el_list_cons_injective {
    if cons_el_list(head_0, tail_0) = cons_el_list(head_1, tail_1);
    then head_0 = head_1;
    then tail_0 = tail_1;
}
rule el_list_cons_nil {
    if cons_el_list(_, _) = nil_el_list(_);
    then absurd();
}

func func_app(Func, ElList) -> El;

pred pred_app(Pred, ElList);

func var(Structure, VirtIdent) -> El;

// ### The structure that elements belong to
func el_structure(El) -> Structure;
func els_structure(ElList) -> Structure;
rule nil_els_structure {
    if els = nil_el_list(structure);
    then els_structure(els) = structure;
}
rule cons_els_structure {
    if els = cons_el_list(head, tail);
    if head_structure = el_structure(head);
    then head_structure = els_structure(els);
    then head_structure = els_structure(tail);
}

rule func_app_structure {
    if result = func_app(_, args);
    if structure = els_structure(args);
    then structure = el_structure(result);
}

rule var_structure {
    if el = var(structure, _);
    then el_structure(el) = structure;
}

// ### The types of elements
func el_type(El) -> Type;
func el_types(ElList) -> TypeList;

rule nil_el_types {
    if els = nil_el_list(_);
    then nil_type_list()!;
    then el_types(els) = nil_type_list();
}
rule cons_el_types {
    if els = cons_el_list(head, tail);
    if head_type = el_type(head);
    if tail_types = el_types(tail);
    then cons_type_list(head_type, tail_types)!;
    then el_types(els) = cons_type_list(head_type, tail_types);
}
rule cons_el_types_reverse {
    if els = cons_el_list(head, tail);
    if el_types(els) = cons_type_list(head_type, tail_types);
    then el_type(head) = head_type;
    then el_types(tail) = tail_types;
}

rule func_app_types {
    if result = func_app(function, args);
    if domain(function) = dom;
    if codomain(function) = cod;
    then el_types(args) = dom;
    then el_type(result) = cod;
}

rule pred_app_types {
    if pred_app(predicate, args);
    if arity(predicate) = ar;
    then el_types(args) = ar;
}

// ### Constrained elements
//
// An element is constrained if it appears in a function
// application (including the result) or in the
// application of a predicate.
pred constrained_el(El);
pred constrained_els(ElList);
rule func_app_constrained {
    if result = func_app(_, args);
    then constrained_els(args);
    then constrained_el(result);
}
rule pred_app_constrained {
    if pred_app(_, args);
    then constrained_els(args);
}
rule constrained_head_tail {
    if constrained_els(cons_el_list(head, tail));
    then constrained_el(head);
    then constrained_els(tail);
}

// ## Morphisms

type Morphism;
func dom(Morphism) -> Structure;
func cod(Morphism) -> Structure;
func map_el(Morphism, El) -> El;
func map_els(Morphism, ElList) -> ElList;

// Mapped elements live in the codomain structure.
rule map_el_structure {
    if mapped = map_el(mor, _);
    if cod = cod(mor);
    then el_structure(mapped) = cod;
}
rule map_els_structure {
    if mapped = map_els(mor, _);
    if cod = cod(mor);
    then els_structure(mapped) = cod;
}

// The operations map_el(mor, -) and map_els(mor, -) are total.
rule map_el_defined {
    if dom(mor) = struct;
    if el_structure(el) = struct;
    then map_el(mor, el)!;
}
rule map_els_defined {
    if dom(mor) = struct;
    if els_structure(els) = struct;
    then map_els(mor, els)!;
}

// Morphisms commute with nil and cons.
rule map_nil_els {
    if mapped = map_els(mor, nil_el_list(_));
    if cod = cod(mor);
    then mapped = nil_el_list(cod);
}
rule map_cons_els {
    if mapped = map_els(mor, cons_el_list(head, tail));
    then map_el(mor, head)!;
    then map_els(mor, tail)!;
    then mapped = cons_el_list(map_el(mor, head), map_els(mor, tail));
}

// Morphisms commute with function application, preserve
// variables and are compatible with predicates.
rule map_app_func {
    if mapped_result = map_el(mor, func_app(function, args));
    if mapped_args = map_els(mor, args);
    then mapped_result = func_app(function, mapped_args);
}
rule map_var {
    if el = var(_, name);
    if mapped_el = map_el(morph, el);
    if cod(morph) = cod_structure;
    then mapped_el = var(cod_structure, name);
}
rule map_pred_app {
    if pred_app(predicate, args);
    if mapped_args = map_els(_, args);
    then pred_app(predicate, mapped_args);
}

// Morphisms preserve and reflect types.
rule map_preserves_el_type {
    if el_type(el) = typ;
    if mapped_el = map_el(_, el);
    then el_type(mapped_el) = typ;
}
rule map_reflects_el_type {
    if el_type(map_el(_, el)) = typ;
    then el_type(el) = typ;
}

// ### Kernel pairs of morphisms.

pred in_ker(Morphism, El, El);
rule in_ker_rule {
    if map_el(morph, el_0) = map_el(morph, el_1);
    then in_ker(morph, el_0, el_1);
}

// ### Images of morphisms.

pred el_in_img(Morphism, El);
rule el_in_img_rule {
    if map_el(morph, _) = el;
    then el_in_img(morph, el);
}

pred pred_tuple_in_img(Morphism, Pred, ElList);
rule pred_tuple_in_img_rule {
    if map_els(morphism, dom_els) = cod_els;
    if pred_app(predicate, dom_els);
    then pred_tuple_in_img(morphism, predicate, cod_els);
}

pred func_app_in_img(Morphism, Func, args: ElList);
rule func_app_in_img_rule {
    if map_els(morphism, dom_els) = cod_els;
    if func_app(function, dom_els)!;
    then func_app_in_img(morphism, function, cod_els);
}

// ## The initial structure

func initial_structure() -> Structure;
func initiality_morphism(Structure) -> Morphism;

rule initial_structure_total {
    then initial_structure()!;
}

rule initiality_morphism_total {
    if structure: Structure;
    then initiality_morphism(structure)!;
}

rule dom_cod_initiality_morphism {
    if initial_struct = initial_structure();
    if initiality_morph = initiality_morphism(structure);
    then dom(initiality_morph) = initial_struct;
    then cod(initiality_morph) = structure;
}

rule initiality_uniqueness {
    if dom(morph) = initial_structure();
    if cod(morph) = structure;
    then morph = initiality_morphism(structure);
}

// ## Non-empty chains of structures.

type Chain;
func nil_chain() -> Chain;
func chain_tail(Chain) -> Chain;
func chain_head_structure(Chain) -> Structure;
func chain_head_transition(Chain) -> Morphism;

rule chain_head_structure_defined {
    if chain_tail(chain)!;
    then chain_head_structure(chain)!;
}
rule chain_head_transition_defined {
    if chain_tail(chain_tail(chain))!;
    then chain_head_transition(chain)!;
}
rule chain_transition_signature {
    if tail = chain_tail(chain);
    if head_0 = chain_head_structure(chain);
    if trans = chain_head_transition(chain);
    if head_1 = chain_head_structure(tail);
    then dom(trans) = head_0;
    then cod(trans) = head_1;
}

// ## The Chain associated to a RuleDeclNode
//
// The chain of a rule has one structure for each statement in the rule. The
// structure associated to statement corresponds to all the data that has been
// hypothesized or concluded in this and prior statements.

func rule_chain(RuleDeclNode) -> Chain;
rule rule_stmt_list_chain {
    if rule_decl(node, stmts);
    if chain = stmt_list_chain(stmts);
    then rule_chain(node) = chain;
}

// ### The structure of the chain
func stmt_list_chain(StmtListNode) -> Chain;
rule stmt_list_chain_total {
    if stmts: StmtListNode;
    then stmt_list_chain(stmts)!;
}

rule stmt_list_chain_nil {
    if nil_stmt_list_node(stmts);
    if chain = stmt_list_chain(stmts);
    then chain = nil_chain();
}
rule stmt_list_chain_cons {
    if cons_stmt_list_node(stmts, _, tail_stmts);
    if stmts_chain = stmt_list_chain(stmts);
    if tail_chain = stmt_list_chain(tail_stmts);
    then chain_tail(stmts_chain) = tail_chain;
}

// ### Propagation of associated structures through the AST

// #### Propagate stmt structure through if and then stmts.
func stmt_structure(StmtNode) -> Structure;
func if_atom_structure(IfAtomNode) -> Structure;
func then_atom_structure(ThenAtomNode) -> Structure;
func term_structure(TermNode) -> Structure;
func terms_structure(TermListNode) -> Structure;
func opt_term_structure(OptTermNode) -> Structure;

rule stmt_structure_chain {
    if cons_stmt_list_node(stmts, stmt, _);
    if structure = chain_head_structure(stmt_list_chain(stmts));
    then stmt_structure(stmt) = structure;
}

rule if_stmt_structure {
    if if_stmt_node(stmt, atom);
    if structure = stmt_structure(stmt);
    then if_atom_structure(atom) = structure;
}
rule then_stmt_structure {
    if then_stmt_node(stmt, atom);
    if structure = stmt_structure(stmt);
    then then_atom_structure(atom) = structure;
}

// #### Propagate associated structures through if atoms.
rule equal_if_atom_structure {
    if equal_if_atom_node(atom, lhs, rhs);
    if structure = if_atom_structure(atom);
    then term_structure(lhs) = structure;
    then term_structure(rhs) = structure;
}
rule defined_if_atom_structure {
    if defined_if_atom_node(atom, term);
    if structure = if_atom_structure(atom);
    then term_structure(term) = structure;
}
rule pred_if_atom_structure {
    if pred_if_atom_node(atom, _, arg_terms);
    if structure = if_atom_structure(atom);
    then terms_structure(arg_terms) = structure;
}
rule var_if_atom_structure {
    if var_if_atom_node(atom, var_term, _);
    if structure = if_atom_structure(atom);
    then term_structure(var_term) = structure;
}

// #### Propagate associated structures through then atoms.
rule equal_then_atom_structure {
    if equal_then_atom_node(atom, lhs, rhs);
    if structure = then_atom_structure(atom);
    then term_structure(lhs) = structure;
    then term_structure(rhs) = structure;
}
rule defined_then_atom_structure {
    if defined_then_atom_node(atom, var_term, term);
    if structure = then_atom_structure(atom);
    then opt_term_structure(var_term) = structure;
    then term_structure(term) = structure;
}
rule pred_then_atom_structure {
    if pred_then_atom_node(atom, _, arg_terms);
    if structure = then_atom_structure(atom);
    then terms_structure(arg_terms) = structure;
}

// #### Propagate associated structures through terms.
rule cons_term_list_structure {
    if cons_term_list_node(terms, head, tail);
    if structure = terms_structure(terms);
    then term_structure(head) = structure;
    then terms_structure(tail) = structure;
}

rule some_opt_term_structure {
    if some_term_node(opt_term, term);
    if structure = opt_term_structure(opt_term);
    then term_structure(term) = structure;
}

rule app_term_structure {
    if app_term_node(term, _, args);
    if structure = term_structure(term);
    then terms_structure(args) = structure;
}

// ### Populate associated structures

func semantic_el(TermNode) -> El;
rule semantic_el_total {
    if el: TermNode;
    then semantic_el(el)!;
}

func semantic_els(TermListNode) -> ElList;
rule semantic_els_total {
    if els: TermListNode;
    then semantic_els(els)!;
}

rule semantic_els_nil {
    if nil_term_list_node(terms);
    if structure = terms_structure(terms);
    if sem_els = semantic_els(terms);
    then sem_els = nil_el_list(structure);
}
rule semantic_els_cons {
    if cons_term_list_node(terms, head, tail);
    if sem_els = semantic_els(terms);
    if head_sem_el = semantic_el(head);
    if tail_sem_els = semantic_els(tail);
    then sem_els = cons_el_list(head_sem_el, tail_sem_els);
}

// #### The structures of semantic elements
rule semantic_el_struct {
    if el = semantic_el(tm);
    if structure = term_structure(tm);
    then el_structure(el) = structure;
}
rule semantic_els_struct {
    if els = semantic_els(tms);
    if structure = terms_structure(tms);
    then els_structure(els) = structure;
}

// #### Semantics of terms
rule app_term_semantics {
    if app_term_node(result_term, func_name, arg_terms);
    if result_el = semantic_el(result_term);
    if arg_els = semantic_els(arg_terms);
    if function = semantic_func(func_name);
    then result_el = func_app(function, arg_els);
}

rule var_term_semantics {
    if var_term_node(term, name);
    if virt_name = real_virt_ident(name);
    if el = semantic_el(term);
    if structure = term_structure(term);
    then el = var(structure, virt_name);
}

func wildcard_virt_ident(TermNode) -> VirtIdent;
rule wildcard_virt_ident_defined {
    if wildcard_term_node(term);
    then wildcard_virt_ident(term)!;
}
rule wildcard_term_semantics {
    if wildcard_term_node(term);
    if name = wildcard_virt_ident(term);
    if el = semantic_el(term);
    if structure = term_structure(term);
    then el = var(structure, name);
}

// #### Semantics of if atoms
rule equal_if_atom_semantics {
    if equal_if_atom_node(_, lhs_term, rhs_term);
    if lhs_el = semantic_el(lhs_term);
    if rhs_el = semantic_el(rhs_term);
    then lhs_el = rhs_el;
}
// No rule for `defined_if_atom` -- this is already taken care of because `semantic_el` is total.
rule pred_if_atom_semantics {
    if pred_if_atom_node(_, predicate_name, arg_terms);
    if predicate = semantic_pred(predicate_name);
    if arg_els = semantic_els(arg_terms);
    then pred_app(predicate, arg_els);
}
rule var_if_atom_semantics {
    if var_if_atom_node(_, var_term, type_name);
    if typ = semantic_type(type_name);
    if var_el = semantic_el(var_term);
    then el_type(var_el) = typ;
}

// #### Semantics of then atoms
rule equal_then_atom_semantics {
    if equal_then_atom_node(_, lhs_term, rhs_term);
    if lhs_el = semantic_el(lhs_term);
    if rhs_el = semantic_el(rhs_term);
    then lhs_el = rhs_el;
}
rule defined_then_atom_semantics {
    if defined_then_atom_node(_, opt_var_term, term);
    if some_term_node(opt_var_term, var_term);
    if var_el = semantic_el(var_term);
    if el = semantic_el(term);
    then var_el = el;
}
rule pred_then_atom_semantics {
    if pred_then_atom_node(_, predicate_name, arg_terms);
    if predicate = semantic_pred(predicate_name);
    if arg_els = semantic_els(arg_terms);
    then pred_app(predicate, arg_els);
}


// ### The *grouped* Chain associated to a RuleDeclNode
//
// The chain of a rule has one object for each *group* of statements, where
// groups are given by consecutive statements of the same type (i.e. either
// `if` or `then` statements). The structure associated to a statement group 
// is the structure in the (ungrouped) chain of the last statement in that
// group.
func grouped_rule_chain(RuleDeclNode) -> Chain;
rule grouped_rule_stmt_list_chain {
    if rule_decl(node, stmts);
    if grouped_chain = grouped_stmt_list_chain(stmts);
    then grouped_rule_chain(node) = grouped_chain;
}

func grouped_stmt_list_chain(StmtListNode) -> Chain;
rule grouped_stmt_list_chain_total {
    if stmts: StmtListNode;
    then grouped_stmt_list_chain(stmts)!;
}

// The grouped chain of the empty statement list is the empty chain.
rule grouped_stmt_list_chain_nil {
    if nil_stmt_list_node(stmts);
    if grouped_chain = grouped_stmt_list_chain(stmts);
    then grouped_chain = nil_chain();
}

// For either
//
// - two consecutive `if` statements, or
// - two consecutive `then` statements
//
// the chains of the two statements agree.
rule grouped_chain_if_if {
    if cons_stmt_list_node(stmts, first, stmts_tail);
    if cons_stmt_list_node(stmts_tail, second, _);
    if if_stmt_node(first, _);
    if if_stmt_node(second, _);
    if stmts_chain = grouped_stmt_list_chain(stmts);
    then grouped_stmt_list_chain(stmts_tail) = stmts_chain;
}
rule stmt_list_chain_then_then {
    if cons_stmt_list_node(stmts, first, stmts_tail);
    if cons_stmt_list_node(stmts_tail, second, _);
    if then_stmt_node(first, _);
    if then_stmt_node(second, _);
    if stmts_chain = grouped_stmt_list_chain(stmts);
    then grouped_stmt_list_chain(stmts_tail) = stmts_chain;
}

// For a statement followed by a statement of different type (e.g. `if`
// statement followed by a `then` statement or no statement at all), there is a
// transition in the grouped chain. The head of the chain agrees with the head
// of the ungrouped chain.
rule stmt_list_chain_singleton {
    if cons_stmt_list_node(stmts, _, stmts_tail);
    if nil_stmt_list_node(stmts_tail);
    if grouped_chain = grouped_stmt_list_chain(stmts);
    if grouped_tail_chain = grouped_stmt_list_chain(stmts_tail);
    if ungrouped_chain_head = chain_head_structure(stmt_list_chain(stmts));
    then chain_tail(grouped_chain) = grouped_tail_chain;
    then chain_head_structure(grouped_chain) = ungrouped_chain_head;
}
rule grouped_chain_if_then {
    if cons_stmt_list_node(stmts, first, stmts_tail);
    if cons_stmt_list_node(stmts_tail, second, _);
    if if_stmt_node(first, _);
    if then_stmt_node(second, _);
    if grouped_chain = grouped_stmt_list_chain(stmts);
    if grouped_tail_chain = grouped_stmt_list_chain(stmts_tail);
    if ungrouped_chain_head = chain_head_structure(stmt_list_chain(stmts));
    then chain_tail(grouped_chain) = grouped_tail_chain;
    then chain_head_structure(grouped_chain) = ungrouped_chain_head;
}
rule grouped_chain_then_if {
    if cons_stmt_list_node(stmts, first, stmts_tail);
    if cons_stmt_list_node(stmts_tail, second, _);
    if then_stmt_node(first, _);
    if if_stmt_node(second, _);
    if grouped_chain = grouped_stmt_list_chain(stmts);
    if grouped_tail_chain = grouped_stmt_list_chain(stmts_tail);
    if ungrouped_chain_head = chain_head_structure(stmt_list_chain(stmts));
    then chain_tail(grouped_chain) = grouped_tail_chain;
    then chain_head_structure(grouped_chain) = ungrouped_chain_head;
}

/// ### The names associated to elements in chains
//
// Flat names are created outside of this Eqlog module, during flattening.
// We can't do it here because flattening involves some choice (e.g. "pick any
// name for this element") and negative reasoning (e.g. "if no name exists for
// this element, introduce a new name").
//
// Nevertheless, flat names satisfy some algebraic properties, which can be
// encoded here in Eqlog.
type FlatName;
pred flat_el_name(El, FlatName);

rule flat_name_map {
    if mapped_el = map_el(_, el);
    if flat_el_name(el, name);
    then flat_el_name(mapped_el, name);
}