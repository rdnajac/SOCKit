{ open Parser

let comment_depth = ref 0
}

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let whitespace = [' ' '\t' '\r' '\n']

rule token = parse
| whitespace { token lexbuf }
| "/*"     { comment_depth := !comment_depth + 1; comment lexbuf }
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI   }
| ','      { COMMA  }
| '+'      { PLUS   }
| '-'      { MINUS  }
| '='      { ASSIGN }
| "=="     { EQ     }
| "!="     { NEQ    }
| '<'      { LT     }
| "&&"     { AND    }
| "||"     { OR     }
| "if"     { IF     }
| "else"   { ELSE   }
| "while"  { WHILE  }
| "return" { RETURN }
| "int"    { INT    }
| "void"   { VOID   }
| digit+ as lxm  { LITERAL(int_of_string lxm) }
| letter (digit | letter | '_')* as lxm { ID(lxm) }
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/"     { comment_depth := !comment_depth - 1;
             if !comment_depth > 0 then comment lexbuf
             else token lexbuf }
| "/*"     { comment_depth := !comment_depth + 1; comment lexbuf }
| '\n'     { comment lexbuf }
| _        { comment lexbuf }

