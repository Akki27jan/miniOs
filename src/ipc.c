#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>
#include "../include/minios.h"

#define MAX_JOBS 10
static char job_history[MAX_JOBS][256];
static int job_count = 0;

// Write data into the write-end of the pipe
void send_result(int fd, const char *result) {
    write(fd, result, strlen(result));
}

// Read data from the read-end of the pipe and safely null-terminate it
void receive_result(int fd, char *buf, size_t capacity) {
    ssize_t bytes_read = read(fd, buf, capacity - 1);
    if (bytes_read > 0) {
        buf[bytes_read] = '\0'; 
    } else {
        buf[0] = '\0';
    }
}

// Command: submit <job_name>
void submit_job(char *job_name) {
    int pipefd[2];
    
    // Create the pipe (pipefd[0] is read, pipefd[1] is write)
    if (pipe(pipefd) == -1) {
        perror("pipe failed");
        return;
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
    } 
    else if (pid == 0) {
        // CHILD PROCESS (Worker)
        close(pipefd[0]); // Close the unused read-end of the pipe
        
        // Simulate a worker doing a job and formulating a result string
        char result_msg[256];
        snprintf(result_msg, sizeof(result_msg), "Job '%s' completed successfully by worker PID %d", job_name, getpid());
        
        // Send the result through the pipe
        send_result(pipefd[1], result_msg);
        
        close(pipefd[1]); // Close the write-end when finished
        exit(0);          // Exit the worker process
    } 
    else {
        // PARENT PROCESS (Manager)
        close(pipefd[1]); // Close the unused write-end of the pipe
        
        char buffer[256];
        // Read the result from the pipe
        receive_result(pipefd[0], buffer, sizeof(buffer));
        
        close(pipefd[0]); // Close the read-end when finished
        waitpid(pid, NULL, 0); // Wait for the worker to exit
        
        printf("Manager received: %s\n", buffer);
        
        // Save the result to our jobs array for the 'jobs' command
        if (job_count < MAX_JOBS) {
            strncpy(job_history[job_count], buffer, 255);
            job_history[job_count][255] = '\0';
            job_count++;
        } else {
            printf("Job history full!\n");
        }
    }
}

// Command: jobs
void list_jobs(void) {
    printf("--- Recent Jobs ---\n");
    if (job_count == 0) {
        printf("No jobs submitted yet.\n");
    } else {
        for (int i = 0; i < job_count; i++) {
            printf("[%d] %s\n", i + 1, job_history[i]);
        }
    }
}