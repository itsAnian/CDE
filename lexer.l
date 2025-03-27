%option noyywrap

%{
#include "parser.h"
#include <stdlib.h>
#include <string.h>
#include <assert.h>  // Required for static_assert in C11
%}

%%

"falls"         { return IF; }
"zurückgeben"   { return RETURN; }
"ganzzahl"      { return INT; }
"sonst"         { return ELSE; }

[0-9]+ { 
    yylval.ival = atoi(yytext); 
    printf("LEXER SIDE:\n");
    printf("  yylval address: %p\n", (void*)&yylval);
    printf("  ival address:   %p\n", (void*)&(yylval.ival));
    printf("  Stored value:   %d\n\n", yylval.ival);
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