#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include "../include/minios.h"

void runProg(char *command) {
    char *args[64]; 
    int i = 0;

    
    char *token = strtok(command, " ");
    while (token != NULL && i < 63) {
        args[i] = token;
        i++;
        token = strtok(NULL, " ");
    }
    args[i] = NULL;

    if (args[0] == NULL) {
        return; 
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
    } 
    else if (pid == 0) {
        
        if (execvp(args[0], args) == -1) {
            perror("Command execution failed");
            exit(1);
        }
    } 
    else {
        int status;
        waitpid(pid, &status, 0);
    }
}