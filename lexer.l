%option noyywrap

%{
#include "parser.h"
#include <stdlib.h>
#include <string.h>
%}

%%

"falls"         { return IF; }
"zurückgeben"   { return RETURN; }
"ganzzahl"      { return INT; }
"sonst"         { return ELSE; }
"abbruch"       { return BREAK; }
"konstante"     { return CONST; }
"für"           { return FOR; }


[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
";"             { return ';'; }
"++"            { return INC; }
"--"            { return DEC; }
"=="            { return EQ; }
"!="            { return NE; }
"<"             { return LT; }
">"             { return GT; }
"<="            { return LE; }
">="            { return GE; }

"="             { return '='; }
[ \t\r\n]+      { /* Ignore whitespace */ }
.               { printf("Unexpected character: %c\n", *yytext); }

%%
