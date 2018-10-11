{
    open Parser
    exception Bad_token of string
}

rule token = parse
    | [' ' '\t' '\n']                                           { token lexbuf }
    | ("+" | "-" | "÷") as s                                { OP s }
    | "("                                                   { LPAR }
    | ")"                                                   { RPAR }
    | "→"                                                   { ARROW }
    | "->"                                                  { ARROW }
    | ['0'-'9']['0'-'9']* as n                                       { CONST n }
    | ['a'-'z']['0'-'9''a'-'z''A'-'Z''_']*'\''* as s        { SYMBOL s }
    | eof                                                   { EOF }
    | _                                                     { raise (Bad_token (Lexing.lexeme lexbuf)) }