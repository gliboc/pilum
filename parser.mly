%{
open Ast
%}

%token LPAR RPAR
%token ARROW
%token <string> CONST
%token <string> OP SYMBOL
%token EOF

%start main
%type <Ast.rule> main

%%

main:
    | e1=expr ARROW e2=expr  EOF     { Arr (e1, e2) }

expr:
    | e1=expr op=OP e2=expr          { Binary (Sym op, e1, e2) }
    | f=SYMBOL LPAR e=expr RPAR      { Unary (Sym f, e) }
    | c=CONST                        { Const c }





