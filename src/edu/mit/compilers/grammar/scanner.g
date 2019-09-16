header {
package edu.mit.compilers.grammar;
}

options
{
  mangleLiteralPrefix = "TK_";
  language = "Java";
}

{@SuppressWarnings("unchecked")}
class DecafScanner extends Lexer;
options
{
  k = 5; // Need some lookahead for SINGLECHAROP vs DOUBLECHAROP, SL_COMMENT vs. ML_COMMENT, ML_COMMENT, BOOLEANLITERAL vs. ID
}

tokens 
{
  "class";
}

// Selectively turns on debug tracing mode.
// You can insert arbitrary Java code into your parser/lexer this way.
{
  /** Whether to display debug information. */
  private boolean trace = false;

  public void setTrace(boolean shouldTrace) {
    trace = shouldTrace;
  }
  @Override
  public void traceIn(String rname) throws CharStreamException {
    if (trace) {
      super.traceIn(rname);
    }
  }
  @Override
  public void traceOut(String rname) throws CharStreamException {
    if (trace) {
      super.traceOut(rname);
    }
  }
}

LCURLY options { paraphrase = "{"; } : "{";
RCURLY options { paraphrase = "}"; } : "}";
LSQUARE options { paraphrase = "["; } : "[";
RSQUARE options { paraphrase = "]"; } : "]";
LPAREN options { paraphrase = "("; } : "(";
RPAREN options { paraphrase = ")"; } : ")";
SEMICOLON options { paraphrase = ";"; } : ";";
COMMA options { paraphrase = ","; } : ",";

SINGLECHAROP options { paraphrase = "a single-character operation"; } : ('+'|'-'|'*'|'/'|'!'|'%'|'<'|'>'|'=');
DOUBLECHAROP options { paraphrase = "a two-character operation"; } : (('+' '=')|('-' '=')|('+' '+')|('-' '-')|('<' '=')|('>' '=')|('=' '=')|('!' '=')|('&' '&')|('|' '|'));

ID options { paraphrase = "an identifier"; } : 
  ALPHA (ALPHANUM)*;

// Note that here, the {} syntax allows you to literally command the lexer
// to skip mark this token as skipped, or to advance to the next line
// by directly adding Java commands.
WS_ : (' ' | '\t' | '\r' | '\n' {newline();}) {_ttype = Token.SKIP; };
SL_COMMENT : '/' '/' (~'\n')* '\n' {_ttype = Token.SKIP; newline (); };
ML_COMMENT : '/' '*' ((~'*') | ('*' ~'/'))* '*' '/' {_ttype = Token.SKIP; newline (); } ;

CHARLITERAL : '\'' CHAR '\'';
STRINGLITERAL : '"' (CHAR)* '"';
INTLITERAL : (DIGIT)+;
HEXLITERAL : '0' 'x' INTLITERAL;

protected ESC :  '\\' ('n'|'t'|'"'|'\''|'\\');
protected ALPHA : ('a'..'z' | 'A'..'Z' | '_');
protected DIGIT : ('0'..'9') ;
protected ALPHANUM : ALPHA | DIGIT;
protected CHAREXCEPTESC : ' '|'!'|'#'|'$'|'%'|'&'|'('|')'|'*'|'+'|','|'-'|'.'|'/'|
    '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'|':'|';'|'<'|'='|'>'|'?'|'@'|
    'A'..'Z'|'['|']'|'^'|'_'|'`'|
    'a'..'m' | 'o'..'s' | 'u'..'z'|'{'|'|'|'}'|'~';
protected CHAR : ESC | CHAREXCEPTESC;
    