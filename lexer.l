%{
#include "parser.tab.h"  // Von Bison generierte Header-Datei
%}

%option noyywrap  // Verhindert Probleme mit der Eingabe

%%

// Deutsche Schlüsselwörter als Token definieren
"falls"         { return IF; }
"zurückgeben"   { return RETURN; }

// Standard C-Symbole und Bezeichner
[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
";"             { return ';'; }
[ \t\r\n]+      { /* Ignoriere Leerzeichen */ }
.               { printf("Unerwartetes Zeichen: %c\n", *yytext); }

%%
