Henry's Decaf Scanner and Parser
=============

## Summary of design choices:

- Scanner and Parser written using ANTLR grammar, for readability and simplicity

- Lexer does a generous amount of work (differentiates all keywords,
differentiates most `OP`-like tokens, differentiates `HEXLITERAL` and
`DECLITERAL` int literals, differentiates `TRUE` and `FALSE`)

  - Notable design decisions for the Lexer:

    - When encountering an error, consume a newline and continue
    lexing on the next line.  Assumes that most lexer errors are
    resolved by starting on the next line -- notably might fail if a
    `ML_COMMENT` starts on the same line as an error.

    - Some hacks in Main.java to make lexer token types more
    generalized to pass the scanner tests.  (Ex. TRUE and FALSE ->
    print BOOLEANLITERAL.)

- Parser defines grammar in a depth-first style, close to the spec.

  - Notable design decisions for the parser:

    - `(MINUS)+`, `(NOT)+`: To easily get rid of ambiguity, `-` and
    `!` tokens right next to each other before an expression are
    parsed like `(!!!)(expr)` instead of `(!(!(!expr)))`.  This
    shouldn't be a problem since `!!!...` is always equivalent to
    either just `!` or nothing.

    - `expr`, `next_expr`, `bin_op_next_expr`: Hack to get rid of left
    recursion on the `expr`.

