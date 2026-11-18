#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include "../include/minios.h"

#define NUM_JOBS 10
#define DEFAULT_WORKERS 3
#define MAX_WORKERS 16
#define JOB_TIME_US 200000 // each job takes 0.2 seconds
#define STOP_JOB -1        // special job id that tells a worker to exit

typedef struct {
    int id;
    job_queue_t *queue;
    int jobs_done;
} worker_context_t;

// Consumer: keep taking jobs from the queue until told to stop
static void *worker_main(void *arg) {
    worker_context_t *ctx = arg;

    while (1) {
        job_t job;
        queue_pop(ctx->queue, &job);         // obtain a job
        if (job.id == STOP_JOB) break;

        printf("  [Worker %d] started  %s\n", ctx->id, job.name);
        usleep(JOB_TIME_US);                 // process it
        printf("  [Worker %d] finished %s\n", ctx->id, job.name);
        ctx->jobs_done++;                    // record the result
    }

    return NULL;
}

// Command: workers [n]
void workers_demo(char *args) {
    int num_workers = DEFAULT_WORKERS;
    if (args != NULL && *args != '\0') {
        num_workers = atoi(args);
        if (num_workers < 1 || num_workers > MAX_WORKERS) {
            printf("Usage: workers [1-%d]\n", MAX_WORKERS);
            return;
        }
    }

    printf("--- Producer-Consumer Demo ---\n");
    printf("%d worker thread(s), %d jobs, queue holds %d jobs\n\n",
           num_workers, NUM_JOBS, QUEUE_SIZE);

    job_queue_t queue;
    queue_init(&queue);

    pthread_t threads[MAX_WORKERS];
    worker_context_t ctx[MAX_WORKERS];

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);

    for (int i = 0; i < num_workers; i++) {
        ctx[i].id = i + 1;
        ctx[i].queue = &queue;
        ctx[i].jobs_done = 0;
        if (pthread_create(&threads[i], NULL, worker_main, &ctx[i]) != 0) {
            perror("pthread_create failed");
            num_workers = i; // only wait for the threads that did start
            break;
        }
    }

    // Producer: the main thread puts the jobs into the queue
    for (int i = 1; i <= NUM_JOBS; i++) {
        job_t job;
        job.id = i;
        snprintf(job.name, sizeof(job.name), "job%d", i);
        queue_push(&queue, job);
        printf("  [Producer] added %s\n", job.name);
    }

    // One stop job per worker, so every worker leaves its loop
    for (int i = 0; i < num_workers; i++) {
        job_t stop = { .id = STOP_JOB };
        queue_push(&queue, stop);
    }

    for (int i = 0; i < num_workers; i++) {
        pthread_join(threads[i], NULL);
    }

    clock_gettime(CLOCK_MONOTONIC, &end);
    double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;

    queue_destroy(&queue);

    printf("\n--- Summary ---\n");
    for (int i = 0; i < num_workers; i++) {
        printf("Worker %d did %d job(s)\n", ctx[i].id, ctx[i].jobs_done);
    }
    printf("Total time: %.2f seconds\n", elapsed);
}
