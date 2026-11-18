#ifndef MINIOS_H
#define MINIOS_H

#include <semaphore.h>

#define QUEUE_SIZE 5

// A job that can sit in the shared queue
typedef struct {
    int id;
    char name[32];
} job_t;

// Bounded job queue shared between the producer and worker threads
typedef struct {
    job_t jobs[QUEUE_SIZE];
    int in;      // next slot to put a job into
    int out;     // next slot to take a job from
    sem_t empty; // how many slots are free
    sem_t full;  // how many slots hold a job
    sem_t mutex; // only one thread may touch the queue at a time
} job_queue_t;

void sysInfo(void);
void show_processes(void);
void runProg(char *command);
void submit_job(char *job_name);
void list_jobs(void);
void race_demo(void);

void queue_init(job_queue_t *q);
void queue_destroy(job_queue_t *q);
int queue_push(job_queue_t *q, job_t job);
int queue_pop(job_queue_t *q, job_t *job);

void workers_demo(char *args);

#endif
