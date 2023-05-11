pub struct FunctionArg {
    pub name: String,
    pub ty: Option<Type>,
}

pub enum Type {
    Void,
    Boolean,
    Number,
    String,
    Product(Vec<Type>),
    Function {
        domain: Vec<FunctionArg>,
        codomain: Box<Type>,
    },
}

pub struct Function {
    pub name: Option<String>,
    pub args: Vec<FunctionArg>,
    pub codomain: Option<Type>,
    pub body: Vec<Stmt>,
}

pub enum Expr {
    Variable(String),
    False,
    True,
    StringLiteral(String),
    NumberLiteral(String),
    Tuple(Vec<Expr>),
    App {
        function: Box<Expr>,
        args: Vec<Expr>,
    },
    Function(Function),
}

pub enum Stmt {
    Expr(Expr),
    Let {
        name: String,
        value: Expr,
    },
    Return(Expr),
    ReturnVoid,
    Function(Function),
    If {
        cond: Expr,
        true_branch: Vec<Stmt>,
        false_branch: Vec<Stmt>,
    },
    While {
        cond: Expr,
        body: Vec<Stmt>,
    },
}
