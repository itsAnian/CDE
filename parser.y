%define api.pure full
%define api.header.include {"parser.h"}
%define parse.error verbose
%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex();
%}

%token NUMBER IDENTIFIER EQUALS SEMICOLON

%%

program:
    statement_list
    ;

statement_list:
    statement_list statement
    | statement
    ;

statement:
    IDENTIFIER EQUALS NUMBER SEMICOLON { printf("Variable '%s' zugewiesen mit %d\n", $1, $3); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Fehler: %s\n", s);
}

int test() {
    return yyparse();
}
