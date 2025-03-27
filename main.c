#include <stdio.h>

extern FILE *yyin;
int yyparse();

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Bitte eine Datei angeben.\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Fehler beim Öffnen der Datei");
        return 1;
    }

    yyparse();
    fclose(yyin);
    return 0;
}