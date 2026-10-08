#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../include/minios.h"

int main() {
    char input[256];

    printf("Welcome to LarpOS!\n");
    printf("Type 'larp' to see all commands, or 'quit' to exit.\n");

    while (1) {
        printf("LarpOS> ");
        
        if (fgets(input, sizeof(input), stdin) == NULL) {
            break; 
        }

        input[strcspn(input, "\n")] = 0;

        if (strcmp(input, "quit") == 0 || strcmp(input, "exit") == 0) {
            break;
        } else if (strcmp(input, "system") == 0) {
            sysInfo();
        } else if (strcmp(input, "larp") == 0) {
            FILE *fp = fopen("src/larp.txt", "r");
            if (fp == NULL) {
                perror("Not able to larp at this moment\n");
            } else {
                char line[256];
                while (fgets(line, sizeof(line), fp)) {
                    printf("%s", line);
                }
                fclose(fp);
                printf("\n");
            }
        }else if (strncmp(input, "run ", 4) == 0) {
            runProg(input + 4);
        }
        else if (strlen(input) > 0) {
            printf("Unknown command: %s\n", input);
        }
    }

    return 0;
}