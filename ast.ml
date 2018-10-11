type symbol = Sym of string [@@deriving show]

type expr =   Unary of symbol * expr 
            | Binary of symbol * expr * expr 
            | Const of string [@@deriving show]

type rule = Arr of expr * expr [@@deriving show]

let string_of_symbol : symbol -> string = fun s -> 
    match s with
    | Sym s -> s

