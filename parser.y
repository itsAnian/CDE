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
%token IF RETURN INT LONG SHORT ELSE BREAK CONST FOR
%token INC DEC EQ NE LT GT LE GE

%type <sval> condition statement statements if_statement return_statement
%type <sval> datatype_definition else_statement parameter_list parameters
%type <sval> expression argument_list arguments datatype break_statement for_statement int_for_forloop

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
    | break_statement
    { $$ = $1; }
    | for_statement
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
    datatype IDENTIFIER
    {
        $$ = malloc(strlen($1) + strlen($2) + 1);
        sprintf($$, "%s %s", $1, $2);
        free($2);
    }
    | parameters ',' datatype IDENTIFIER
    {
        $$ = malloc(strlen($1) + strlen($3) + strlen($4) + 3);
        sprintf($$, "%s, %s %s", $1, $3, $4);
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

break_statement:
    BREAK ';'
    {
        $$ = strdup("break;\n");
    }
    ;

for_statement:
    FOR '(' int_for_forloop ';' condition ';' expression ')' statement
    {
        $$ = malloc(strlen("for (") + strlen($3) + strlen("; ") + strlen($5) + strlen("; ") + strlen($7) + strlen(") ") + strlen($9) + 1);
        sprintf($$, "for (%s; %s; %s) %s", $3, $5, $7, $9);
        free($3); free($5); free($7); free($9);
    }
    | FOR '(' int_for_forloop ';' condition ';' expression ')' '{' statements '}'
    {
        $$ = malloc(strlen("for (") + strlen($3) + strlen("; ") + strlen($5) + strlen("; ") + strlen($7) + strlen(") {\n") + strlen($10) + strlen("\n}\n") + 1);
        sprintf($$, "for (%s; %s; %s) {\n%s\n}\n", $3, $5, $7, $10);
        free($3); free($5); free($7); free($10);
    }
    ;

int_for_forloop:
    INT IDENTIFIER '=' expression
    {
        $$ = malloc(strlen("int ") + strlen($2) + strlen(" = ") + strlen($4) + 1);
        sprintf($$, "int %s = %s", $2, $4);
        free($2); free($4);
    }
    | INT IDENTIFIER
    {
        $$ = malloc(strlen("int ") + strlen($2) + 1);
        sprintf($$, "int %s", $2);
        free($2);
    }
    ;

datatype:
    INT
    {
        $$ = strdup("int");
    }
    | LONG
    {
        $$ = strdup("long");
    }
    | SHORT
    {
        $$ = strdup("short");
    }
    ;

datatype_definition:
    datatype IDENTIFIER '=' expression ';'
    {
        $$ = malloc(strlen($1) + strlen($2) + strlen(" = ") + strlen($4) + 3);
        sprintf($$, "%s %s = %s;\n", $1, $2, $4);
        free($1);
        free($2);
        free($4);
    }
    | datatype IDENTIFIER ';'
    {
        $$ = malloc(strlen($1) + strlen($2) + 2);
        sprintf($$, "%s %s;\n", $1, $2);
        free($1);
        free($2);
    }
    | datatype IDENTIFIER '(' parameter_list ')' '{' statements '}'
    {
        $$ = malloc(strlen($1) + strlen($2) + strlen("(") + strlen($4) + strlen(") {\n") + strlen($7) + strlen("\n}\n") + 1);
        sprintf($$, "%s %s(%s) {\n%s\n}\n", $1, $2, $4, $7);
        free($1);
        free($2);
        free($4);
        free($7);
    }
    | CONST datatype IDENTIFIER '=' expression ';'
    {
        $$ = malloc(7 + strlen($2) + strlen($3) + strlen(" = ") + strlen($5) + 3);
        sprintf($$, "const %s %s = %s;\n", $2, $3, $5);
        free($3); 
        free($5);
    }
    | CONST datatype IDENTIFIER ';'
    {
        $$ = malloc(7 + strlen($2) + strlen($3) + 2);
        sprintf($$, "const %s %s;\n", $2, $3);
        free($3);
    }
    ;

expression:
    IDENTIFIER
    { 
        $$ = strdup($1); 
        free($1); 
    }
    | NUMBER
    {
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
    | IDENTIFIER INC
    {
        $$ = malloc(strlen($1) + 3);
        sprintf($$, "%s++", $1);
        free($1);
    }
    | IDENTIFIER DEC
    {
        $$ = malloc(strlen($1) + 3);
        sprintf($$, "%s--", $1);
        free($1);
    }
    | INC IDENTIFIER
    {
        $$ = malloc(strlen($2) + 3);
        sprintf($$, "++%s", $2);
        free($2);
    }
    | DEC IDENTIFIER
    {
        $$ = malloc(strlen($2) + 3);
        sprintf($$, "--%s", $2);
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
    | IDENTIFIER '=' expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 3);
        sprintf($$, "%s=%s", $1, $3);
        free($1);
        free($3);
    }
    | expression EQ expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s == %s", $1, $3);
        free($1); free($3);
    }
    | expression NE expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s != %s", $1, $3);
        free($1); free($3);
    }
    | expression LT expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s < %s", $1, $3);
        free($1); free($3);
    }
    | expression GT expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s > %s", $1, $3);
        free($1); free($3);
    }
    | expression LE expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s <= %s", $1, $3);
        free($1); free($3);
    }
    | expression GE expression
    {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s >= %s", $1, $3);
        free($1); free($3);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int parser_main() {
    return yyparse();
}
