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
  k = 6; // Need some lookahead for SINGLECHAROP vs DOUBLECHAROP, SL_COMMENT vs. ML_COMMENT, ML_COMMENT, BOOLEANLITERAL vs. ID
}

tokens // Use enums instead of strings for typo protection.
{
	BOOL="bool";
	BREAK="break";
	IMPORT="import";
	CONTINUE="continue";
	ELSE="else";
	FOR="for";
	WHILE="while";
	IF="if";
	INT="int";
	RETURN="return";
	LEN="len";
	VOID="void";
	TRUE="true";
	FALSE="false";
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

ARITHOPEXCEPTMINUS : ('+'|'*'|'/'|'%');
NOT : '!';
MINUS : '-';
EQUALS : '=';
CONDOP : ('&' '&')|('|' '|');
RELOP : ('<' '=')|('>' '=')|'<'|'>';
COMPOUNDASSIGNOP : ('+' '=')|('-' '=');
EQOP : ('=' '=')|('!' '=');
INCREMENT : ('+' '+')|('-' '-');

ID options { paraphrase = "an identifier"; } : 
  ALPHA (ALPHANUM)*;

// Note that here, the {} syntax allows you to literally command the lexer
// to skip mark this token as skipped, or to advance to the next line
// by directly adding Java commands.
WS_ : (' ' | '\t' | '\r' | '\n' {newline();}) {_ttype = Token.SKIP; };
SL_COMMENT : '/' '/' (~'\n')* '\n' {_ttype = Token.SKIP; newline (); };
ML_COMMENT : '/' '*' ( options { greedy = false; } : .)* '*' '/' {_ttype = Token.SKIP; } ;

CHARLITERAL : '\'' CHAR '\'';
STRINGLITERAL : '"' (CHAR)* '"';
DECLITERAL : (DIGIT)+;
HEXLITERAL : '0' 'x' ('0'..'9' | 'a'..'f' | 'A'..'F')+;

protected ESC :  '\\' ('n'|'t'|'"'|'\''|'\\');
protected ALPHA : ('a'..'z' | 'A'..'Z' | '_');
protected DIGIT : ('0'..'9') ;
protected ALPHANUM : ALPHA | DIGIT;
protected CHAREXCEPTESC : ' '|'!'|'#'|'$'|'%'|'&'|'('|')'|'*'|'+'|','|'-'|'.'|'/'|
    '0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'|':'|';'|'<'|'='|'>'|'?'|'@'|
    'A'..'Z'|'['|']'|'^'|'_'|'`'|
    'a'..'z'|'{'|'|'|'}'|'~';
protected CHAR : ESC | CHAREXCEPTESC;
    