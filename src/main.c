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
        } else if (strcmp(input, "clear") == 0) {
            // ANSI escape codes: move cursor to top-left, then clear the screen
            printf("\033[H\033[2J");
            fflush(stdout);
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
        }else if (strncmp(input, "submit ", 7) == 0) {
            // input + 7 skips the word "submit " 
            submit_job(input + 7);
        } 
        else if (strcmp(input, "jobs") == 0) {
            list_jobs();
        }else if (strlen(input) > 0) {
            printf("Unknown command: %s\n", input);
        }
    }

    return 0;
}