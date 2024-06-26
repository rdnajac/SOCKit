open Ast
open Bytecode

let execute_prog prog =
  let stack = Array.make 1024 0 and globals = Array.make prog.num_globals 0 in

  let rec exec fp sp pc =
    match prog.text.(pc) with
    | Lit i ->
        stack.(sp) <- i;
        exec fp (sp + 1) (pc + 1)
    | Blit i ->
        stack.(sp) <- globals.(i);
        exec fp (sp + 1) (pc + 1)
    | Drp -> exec fp (sp - 1) (pc + 1)
    | Bin op ->
        let op1 = stack.(sp - 2) and op2 = stack.(sp - 1) in
        stack.(sp - 2) <-
          (let boolean i = if i then 1 else 0 in
           match op with
           | Add -> op1 + op2
           | Sub -> op1 - op2
           | Mul -> op1 * op2
           | Div -> op1 / op2
           | Mod -> op1 mod op2
           | And -> boolean (op1 != 0 && op2 != 0)
           | Or -> boolean (op1 != 0 || op2 != 0)
           | Eq -> boolean (op1 = op2)
           | Neq -> boolean (op1 != op2)
           | Lt -> boolean (op1 < op2)
           | Gt -> boolean (op1 > op2)
           | Le -> boolean (op1 <= op2)
           | Ge -> boolean (op1 >= op2));
        exec fp (sp - 1) (pc + 1)
    | Lod i ->
        stack.(sp) <- globals.(i);
        exec fp (sp + 1) (pc + 1)
    | Str i ->
        globals.(i) <- stack.(sp - 1);
        exec fp sp (pc + 1)
    | Lfp i ->
        stack.(sp) <- stack.(fp + i);
        exec fp (sp + 1) (pc + 1)
    | Sfp i ->
        stack.(fp + i) <- stack.(sp - 1);
        exec fp sp (pc + 1)
    | Jsr -1 ->
        print_endline (string_of_int stack.(sp - 1));
        exec fp sp (pc + 1)
    | Jsr i ->
        stack.(sp) <- pc + 1;
        exec fp (sp + 1) i
    | Ent i ->
        stack.(sp) <- fp;
        exec sp (sp + i + 1) (pc + 1)
    | Rts i ->
        let new_fp = stack.(fp) and new_pc = stack.(fp - 1) in
        stack.(fp - i - 1) <- stack.(sp - 1);
        exec new_fp (fp - i) new_pc
    | Beq i -> exec fp (sp - 1) (pc + if stack.(sp - 1) = 0 then i else 1)
    | Bne i -> exec fp (sp - 1) (pc + if stack.(sp - 1) != 0 then i else 1)
    | Bra i -> exec fp sp (pc + i)
    | Hlt -> ()
  in

  exec 0 0 0
