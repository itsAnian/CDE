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
"langezahl"     { return LONG; }
"kurzezahl"     { return SHORT; }
"sonst"         { return ELSE; }

[0-9]+ { 
    yylval.ival = atoi(yytext); 
    return NUMBER; 
}

[a-zA-Z_][a-zA-Z0-9_]* { 
    yylval.sval = strdup(yytext); 
    return IDENTIFIER; 
}

[(){};=]       { return *yytext; }
[ \t\r\n]+      { /* Ignore whitespace */ }
.               { printf("Unexpected character: %c\n", *yytext); }

%%