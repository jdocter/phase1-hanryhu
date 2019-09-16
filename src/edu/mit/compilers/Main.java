package edu.mit.compilers;

import java.io.*;
import antlr.Token;
import edu.mit.compilers.grammar.*;
import edu.mit.compilers.tools.CLI;
import edu.mit.compilers.tools.CLI.Action;
import java.util.Set;

class Main {
    
    private static Set<String> KEYWORDS = Set.of(
            "bool",
            "break",
            "import",
            "continue",
            "else",
            "for",
            "while",
            "if",
            "int",
            "return",
            "len",
            "void"
            );
    private static Set<String> BOOLEAN_LITERALS = Set.of(
            "true",
            "false"
            );
    
  public static void main(String[] args) {
    try {
      CLI.parse(args, new String[0]);
      InputStream inputStream = args.length == 0 ?
          System.in : new java.io.FileInputStream(CLI.infile);
      PrintStream outputStream = CLI.outfile == null ? System.out : new java.io.PrintStream(new java.io.FileOutputStream(CLI.outfile));
      if (CLI.target == Action.SCAN) {
        DecafScanner scanner =
            new DecafScanner(new DataInputStream(inputStream));
        scanner.setTrace(CLI.debug);
        Token token;
        boolean done = false;
        while (!done) {
          try {
            for (token = scanner.nextToken();
                 token.getType() != DecafParserTokenTypes.EOF;
                 token = scanner.nextToken()) {
              String type = "";
              String text = token.getText();
              switch (token.getType()) {
               case DecafScannerTokenTypes.ID:
                   // Hard to differentiate in scanner grammar, do here.
                   if (BOOLEAN_LITERALS.contains(text)) {
                       type = " BOOLEANLITERAL";
                   } else if (KEYWORDS.contains(text)) {
                       type = "";
                   } else {
                       type = " IDENTIFIER";
                   }
                   break;
               case DecafScannerTokenTypes.CHARLITERAL:
                   type = " CHARLITERAL";
                   break;
               case DecafScannerTokenTypes.INTLITERAL:
                   type = " INTLITERAL";
                   break;
               case DecafScannerTokenTypes.STRINGLITERAL:
                   type = " STRINGLITERAL";
                   break;
              }
              outputStream.println(token.getLine() + type + " " + text);
            }
            done = true;
          } catch(Exception e) {
            // print the error:
            System.err.println(CLI.infile + " " + e);
            scanner.consume();
          }
        }
      } else if (CLI.target == Action.PARSE ||
                 CLI.target == Action.DEFAULT) {
        DecafScanner scanner =
            new DecafScanner(new DataInputStream(inputStream));
        DecafParser parser = new DecafParser(scanner);
        parser.setTrace(CLI.debug);
        parser.program();
        if(parser.getError()) {
          System.exit(1);
        }
      }
    } catch(Exception e) {
      // print the error:
      System.err.println(CLI.infile+" "+e);
    }
  }
}
