let rec repl () = 
    let lb = Lexing.from_string (read_line ()) in
    let ast = Parser.main Lexer.token lb in 
    let () = print_endline @@ Ast.show_rule ast 
    in repl ()

let _ = repl ()