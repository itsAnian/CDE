#include <stdio.h>

int yyparse();

int main() {
    printf("Eingabe starten (Ctrl+D zum Beenden):\n");
    yyparse();
    return 0;
}
