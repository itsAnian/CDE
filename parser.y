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
%token IF RETURN INT ELSE

%type <sval> condition statement statements if_statement return_statement int_definition else_statement

%%

program:
    statements
    {
        printf("Parsed program:\n%s\n", $1);
        free($1);
    }
    ;

statements:
    statement
    { $$ = $1; }
    | statements statement
    {
        $$ = malloc(strlen($1) + strlen($2) + 1);
        strcpy($$, $1);
        strcat($$, $2);
        free($1);
        free($2);
    }
    ;

statement:
    if_statement
    { $$ = $1; }
    | else_statement
    { $$ = $1; }
    | return_statement
    { $$ = $1; }
    | int_definition
    { $$ = $1; }
    ;

if_statement:
    IF '(' condition ')' '{' statements '}'
    {
        $$ = malloc(strlen("if (") + strlen($3) + strlen(") {\n") + strlen($6) + strlen("\n}\n") + 1);
        sprintf($$, "if (%s) {\n%s\n}\n", $3, $6);
        free($3);
        free($6);
    }
    ;

else_statement:
    ELSE '{' statements '}'
    {
        $$ = malloc(strlen("else{\n") + strlen($3) + strlen("\n}\n") + 1);
        sprintf($$, "else{\n%s\n}\n", $3);
        free($3);
    }
    ;

return_statement:
    RETURN NUMBER ';'
    {
        $$ = malloc(20);
        sprintf($$, "return %d;", $2);
    }
    ;

int_definition:
    INT IDENTIFIER '=' NUMBER ';'
    {
        $$ = malloc(strlen("int ") + strlen($2) + strlen(" = ") + 20 + strlen(";\n") + 1);
        sprintf($$, "int %s = %d;\n", $2, $4);
        free($2);
    }
    | INT IDENTIFIER ';'
    {
        $$ = malloc(strlen("int ") + strlen($2) + strlen(";\n") + 1);
        sprintf($$, "int %s;\n", $2);
        free($2);
    }
    ;

condition:
    IDENTIFIER
    {
        $$ = strdup($1);
        free($1);
    }
    | NUMBER
    {
        $$ = malloc(16);
        sprintf($$, "%d", $1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Fehler: %s\n", s);
}

int parser_main() {
    return yyparse();
}
