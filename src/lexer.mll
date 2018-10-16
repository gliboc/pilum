{
open Parser
open Lexing
exception Bad_token of string
exception Eof
exception SyntaxError of string


let next_line lexbuf =
let pos = lexbuf.lex_curr_p in
lexbuf.lex_curr_p <-
    { pos with pos_bol = lexbuf.lex_curr_pos;
            pos_lnum = pos.pos_lnum + 1
    }
}

rule token = parse
    | [' ' '\t']                                                        { token lexbuf }
    | "\n"                                                              { EOL }
    | ("**" | "<=" |">="|"<<"| ">>" | "%" | "≤"|"×") as s               { OP s }
    | ("-"|"−"|"÷"|"÷"|"÷"|"+"|"*"|"/"|"&"|"^"|"|"|"="|"<"|">") as s    { OP s }
    | "("                                                               { LPAR }
    | ")"                                                               { RPAR }
    | ("→" | "→" | "→" | "->" | "→")                                          { ARROW }
    | ","                                                               { COMMA }
    | "⊥"                                                               { CONST "⊥" }
    | ['0'-'9']['0'-'9']* as n                                          { CONST n }
    | ['a'-'z''A'-'Z']['0'-'9''a'-'z''A'-'Z''_']*'\''* as s             { SYMBOL s } 
    | ['a'-'z''A'-'Z']['0'-'9''a'-'z''A'-'Z''_']*'\''*"⊥" as s          { SYMBOL s } 
    | _                                                                 { read_string (Buffer.create 17) lexbuf }
    | eof                                                               { EOF }
    | _                                                                 { raise (Bad_token (Lexing.lexeme lexbuf)) }

and read_string buf =
  parse
  | '"'       { SYMBOL (Buffer.contents buf) }
  | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'b'  { Buffer.add_char buf '\b'; read_string buf lexbuf }
  | '\\' 'f'  { Buffer.add_char buf '\012'; read_string buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("String is not terminated")) }