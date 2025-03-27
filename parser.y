%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%define api.value.type { 
    struct { 
        char* sval; 
        int ival; 
    } 
}

%token <sval> IDENTIFIER
%token <ival> NUMBER
%token IF RETURN INT ELSE

%type <sval> condition statement statements if_statement return_statement
%type <sval> datatype_definition else_statement parameter_list parameters
%type <sval> expression argument_list arguments

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
    | datatype_definition
    { $$ = $1; }
    | expression ';'
    { $$ = strdup(";"); }
    ;

argument_list:
    /* empty */
    { $$ = strdup(""); }
    | arguments
    { $$ = $1; }
    ;

arguments:
    expression
    { $$ = $1; }
    | arguments ',' expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 3);
        sprintf($$, "%s, %s", $1, $3);
        free($1);
        free($3);
    }
    ;

parameter_list:
    /* empty */
    { $$ = strdup(""); }
    | parameters
    { $$ = $1; }
    ;

parameters:
    INT IDENTIFIER
    {
        $$ = malloc(strlen("int ") + strlen($2) + 1);
        sprintf($$, "int %s", $2);
        free($2);
    }
    | parameters ',' INT IDENTIFIER
    {
        $$ = malloc(strlen($1) + strlen(" int ") + strlen($4) + 3);
        sprintf($$, "%s, int %s", $1, $4);
        free($1);
        free($4);
    }
    ;

if_statement:
    IF '(' condition ')' statement
    | IF '(' condition ')' '{' statements '}'
    {
        $$ = malloc(strlen("if (") + strlen($3) + strlen(") {\n") + strlen($6) + strlen("\n}\n") + 1);
        sprintf($$, "if (%s) {\n%s\n}\n", $3, $6);
        free($3);
        free($6);
    }
    ;

else_statement:
    ELSE statement
    | ELSE '{' statements '}'
    {
        $$ = malloc(strlen("else {\n") + strlen($3) + strlen("\n}\n") + 1);
        sprintf($$, "else {\n%s\n}\n", $3);
        free($3);
    }
    ;

return_statement:
    RETURN expression ';'
    {
        $$ = malloc(strlen("return ") + strlen($2) + 2);
        sprintf($$, "return %s;\n", $2);
        free($2);
    }
    ;

datatype_definition:
    INT IDENTIFIER '=' expression ';'
    {
        $$ = malloc(strlen("int ") + strlen($2) + strlen(" = ") + strlen($4) + 3);
        sprintf($$, "int %s = %s;\n", $2, $4);
        free($2);
        free($4);
    }
    | INT IDENTIFIER ';'
    {
        $$ = malloc(strlen("int ") + strlen($2) + 2);
        sprintf($$, "int %s;\n", $2);
        free($2);
    }
    | INT IDENTIFIER '(' parameter_list ')' '{' statements '}'
    {
        $$ = malloc(strlen("int ") + strlen($2) + strlen("(") + strlen($4) + strlen(") {\n") + strlen($7) + strlen("\n}\n") + 1);
        sprintf($$, "int %s(%s) {\n%s\n}\n", $2, $4, $7);
        free($2);
        free($4);
        free($7);
    }
    ;

expression:
    IDENTIFIER
    { $$ = strdup($1); free($1); }
    | NUMBER
    {
        printf("PARSER SIDE:\n");
        printf("  yylval address: %p\n", (void*)&yylval);
        printf("  ival address:   %p\n", (void*)&(yylval.ival));
        printf("  Received value: %d\n\n", $1);
        $$ = malloc(32);
        sprintf($$, "%d", $1);
    }
    | expression '+' expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s + %s", $1, $3);
        free($1);
        free($3);
    }
    | expression '=' expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s = %s", $1, $3);
        free($1);
        free($3);
    }
    | IDENTIFIER '(' argument_list ')'
    {
        $$ = malloc(strlen($1) + strlen($3) + 3);
        sprintf($$, "%s(%s)", $1, $3);
        free($1);
        free($3);
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
    | IDENTIFIER '=' expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 3);
        sprintf($$, "%s=%s", $1, $3);
        free($1);
        free($3);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int parser_main() {
    return yyparse();
}
