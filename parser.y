%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

typedef struct {
    char* sval;
    int ival;
} YYSTYPE;

#define YYSTYPE_IS_DECLARED 1
%}

%union {
    char* sval;
    int ival;
}

%token <sval> IDENTIFIER
%token <ival> NUMBER
%token IF RETURN INT

%type <sval> condition

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    if_statement
    | return_statement
    | int_definition
    ;

if_statement:
    IF '(' condition ')' '{' statements '}'  { printf("if (%s) {\n", $3); free($3); }
    ;

return_statement:
    RETURN NUMBER ';' { printf("return %d;\n", $2 == 1 ? 0 : $2); }
    ;

int_definition:
    INT IDENTIFIER '=' NUMBER ';' { printf("int %s = %d;\n", $2, $4); free($2); }
    | INT IDENTIFIER ';' { printf("int %s;\n", $2); free($2); }
    ;

condition:
    IDENTIFIER  { $$ = strdup($1); free($1); }
    | NUMBER    {
        $$ = malloc(16);
        sprintf($$, "%d", $1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int parser_main() {
    return yyparse();
}