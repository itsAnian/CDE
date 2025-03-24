%{
#include "parser.h" // Enthält Token-Definitionen von Bison
%}

%%

[0-9]+   { return NUMBER; }   // Zahlen erkennen
"="      { return EQUALS; }   // Zuweisungssymbol
";"      { return SEMICOLON; }   // Semikolon
[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }  // Variablen
[ \t\n]  ;  // Leerzeichen ignorieren
.        { return yytext[0]; } // Andere Zeichen zurückgeben

%%

int yywrap() { return 1; }  // Beendet den Lexer
