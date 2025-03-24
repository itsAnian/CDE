%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

// Token-Definitionen aus Flex
%token IF RETURN IDENTIFIER NUMBER

%%

// Grammatikregeln für deutsche C-Syntax
program:
    statement
    ;

statement:
    IF '(' condition ')' '{' statement '}'  { printf("if (%s) {\n", $3); }
    | RETURN NUMBER ';'                     { printf("return %d;\n", $2); }
    ;

condition:
    IDENTIFIER                              { $$ = $1; }
    | NUMBER                                { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Fehler: %s\n", s);
}

int main() {
    return yyparse();
}
