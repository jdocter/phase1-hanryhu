header {
package edu.mit.compilers.grammar;
}

options
{
  mangleLiteralPrefix = "TK_";
  language = "Java";
}

class DecafParser extends Parser;
options
{
  importVocab = DecafScanner;
  k = 3;
  buildAST = true;
}

// Java glue code that makes error reporting easier.
// You can insert arbitrary Java code into your parser/lexer this way.
{
  // Do our own reporting of errors so the parser can return a non-zero status
  // if any errors are detected.
  /** Reports if any errors were reported during parse. */
  private boolean error;

  @Override
  public void reportError (RecognitionException ex) {
    // Print the error via some kind of error reporting mechanism.
    super.reportError(ex);
    error = true;
  }
  @Override
  public void reportError (String s) {
    // Print the error via some kind of error reporting mechanism.
    super.reportError(s);
    error = true;
  }
  public boolean getError () {
    return error;
  }

  // Selectively turns on debug mode.

  /** Whether to display debug information. */
  private boolean trace = false;

  public void setTrace(boolean shouldTrace) {
    trace = shouldTrace;
  }
  @Override
  public void traceIn(String rname) throws TokenStreamException {
    if (trace) {
      super.traceIn(rname);
    }
  }
  @Override
  public void traceOut(String rname) throws TokenStreamException {
    if (trace) {
      super.traceOut(rname);
    }
  }
}

program: (import_decl)* (field_decl)* (method_decl)* EOF;

    import_decl : IMPORT ID SEMICOLON;

    field_decl : field_type field (COMMA field)* SEMICOLON ;

        field_type : type ;

            type : INT | BOOL ;

        field : ID ( LSQUARE int_literal RSQUARE ) ? ;
        
            int_literal : DECLITERAL | HEXLITERAL ;

    method_decl : method_type method_name LPAREN (param (COMMA param)*)? RPAREN block ;  

        method_type : type | VOID ;

        method_name : ID ;

        param : type ID ;

        block : LCURLY (field_decl)* (statement)* RCURLY ;

			statement : (assignment SEMICOLON)|
			            (method_call SEMICOLON) |
			            if_statement |
			            for_statement |
			            while_statement |
			            return_statement |
			            break_statement |
			            continue_statement;
		
		        assignment : location assign_expr;
		
		            location : ID (LSQUARE expr RSQUARE)? ;
		
		            assign_expr : (assign_op expr) | INCREMENT;
		            
		                assign_op : EQUALS | COMPOUNDASSIGNOP ;
		
						// expr : expr bin_op expr
						// expr : len ( id )
						// =>
						// expr : len ( id ) R
						// R : (bin_op expr R)?
						expr : (next_expr |
						       // Semantics of the parser is that multiple minuses/nots without any
						       // parens means just apply all of them to the next_expr.
						       ((MINUS)+ next_expr) |
						       ((NOT)+ next_expr)
						       )
						       bin_op_next_expr ;
						    
						    next_expr : location |
						                method_call |
						                literal |
						                (LEN LPAREN ID RPAREN) |
						                (LPAREN expr RPAREN);
		
		                    bin_op_next_expr : (bin_op expr)? ;
		
		                        bin_op : arith_op | rel_op | eq_op | cond_op;
		
		                            arith_op : ARITHOPEXCEPTMINUS | MINUS;
		
									rel_op : RELOP;
									
									eq_op : EQOP;
									
									cond_op : CONDOP;
		
							method_call : method_name LPAREN (import_arg (COMMA import_arg)*)? RPAREN ;
							        // | method_name LPAREN (expr (COMMA expr)*)? RPAREN
					
								import_arg : expr | STRINGLITERAL;
								        
					        literal : int_literal | boolean_literal | CHARLITERAL;
					        
					            boolean_literal : TRUE | FALSE;
					        
		        if_statement : IF LPAREN expr RPAREN
		                            block
		                            (ELSE block)?;
		        
		        for_statement : FOR LPAREN
		                            ID EQUALS expr SEMICOLON
		                            expr SEMICOLON
		                            location ((COMPOUNDASSIGNOP expr) | INCREMENT)
		                            RPAREN
		                            block;
		                            
		        while_statement : WHILE LPAREN expr RPAREN block;
		        
		        return_statement : RETURN (expr)? SEMICOLON;
		
		        break_statement : BREAK SEMICOLON;
		        
		        continue_statement : CONTINUE SEMICOLON;