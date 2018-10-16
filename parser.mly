%{
open Ast
%}

%token LPAR RPAR
%token ARROW
%token <string> CONST
%token <string> OP SYMBOL
%token EOF EOL
%token COMMA
%left OP

%start main
%type <Ast.system> main

%%

main:       
    | EOF                                         { [] }             
    | e1=nopar_expr ARROW e2=expr EOL? m=main           { Arr (e1, e2) :: m }

nopar_expr:
    | e1=nopar_expr op=OP e2=expr                       { Binary (Sym op, e1, e2) }
    | f=SYMBOL LPAR e=expr RPAR                   { Unary (Sym f, e) }
    | c=CONST                                     { Const c }
    | v=SYMBOL                                    { Term (Sym v) }
    | f=SYMBOL LPAR e=expr COMMA a=args RPAR      { Fun (Sym f, e :: a) }

expr:
    | e1=expr op=OP e2=expr                       { Binary (Sym op, e1, e2) }
    | f=SYMBOL LPAR e=expr RPAR                   { Unary (Sym f, e) }
    | c=CONST                                     { Const c }
    | v=SYMBOL                                    { Term (Sym v) }
    | f=SYMBOL LPAR e=expr COMMA a=args RPAR      { Fun (Sym f, e :: a) }
    | LPAR e=expr RPAR                            { e }

args:
    | e=expr                                      { [e] } 
    | e=expr COMMA a=args                         { e :: a }






