#include <stdio.h>
#include <semaphore.h>
#include "../include/minios.h"

void queue_init(job_queue_t *q) {
    q->in = 0;
    q->out = 0;
    sem_init(&q->empty, 0, QUEUE_SIZE); // every slot starts free
    sem_init(&q->full, 0, 0);           // no jobs yet
    sem_init(&q->mutex, 0, 1);          // one permit = one thread at a time
}

void queue_destroy(job_queue_t *q) {
    sem_destroy(&q->empty);
    sem_destroy(&q->full);
    sem_destroy(&q->mutex);
}

// Producer side: add a job, waiting if the queue is full
int queue_push(job_queue_t *q, job_t job) {
    // wait for an empty slot (try first, so we can say when we have to wait)
    if (sem_trywait(&q->empty) != 0) {
        printf("  [Queue] FULL  -> producer waits for a free slot\n");
        sem_wait(&q->empty);
    }

    sem_wait(&q->mutex);                 // enter the critical section
    q->jobs[q->in] = job;                // insert the job
    q->in = (q->in + 1) % QUEUE_SIZE;
    sem_post(&q->mutex);                 // leave the critical section

    sem_post(&q->full);                  // signal that a job is available
    return 0;
}

// Worker side: take a job, waiting if the queue is empty
int queue_pop(job_queue_t *q, job_t *job) {
    // wait for an available job (try first, so we can say when we have to wait)
    if (sem_trywait(&q->full) != 0) {
        printf("  [Queue] EMPTY -> a worker waits for a job\n");
        sem_wait(&q->full);
    }

    sem_wait(&q->mutex);                 // enter the critical section
    *job = q->jobs[q->out];              // remove the job
    q->out = (q->out + 1) % QUEUE_SIZE;
    sem_post(&q->mutex);                 // leave the critical section

    sem_post(&q->empty);                 // signal that a slot is free
    return 0;
}
