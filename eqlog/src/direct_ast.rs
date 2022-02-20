#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub struct Sort(pub String);

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub struct Predicate {
    pub name: String,
    pub arity: Vec<String>,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub struct Function {
    pub name: String,
    pub dom: Vec<String>,
    pub cod: String,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub enum Term {
    Variable(String),
    Wildcard,
    Application(String, Vec<Term>),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub enum Atom {
    Equal(Term, Term),
    Defined(Term, Option<String>),
    Predicate(String, Vec<Term>),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub struct Formula(pub Vec<Atom>);

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub enum Sequent {
    SurjectiveImplication(Formula, Formula),
    GeneralImplication(Formula, Formula),
    Reduction(Term, Term),
    ConditionalReduction(Formula, Term, Term),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug)]
pub enum Declaration {
    Sort(Sort),
    Predicate(Predicate),
    Function(Function),
    Axiom(Sequent),
}
