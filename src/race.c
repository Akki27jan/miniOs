#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include "../include/minios.h"

#define NUM_THREADS 2
#define ITERATIONS 1000000
#define NUM_RUNS 5

// Shared by every worker thread
static long count = 0;

// Protects count in the fixed version
static sem_t count_mutex;

// Each worker increments the shared counter ITERATIONS times.
// count++ is really three steps (read, add 1, write back), and two
// threads can interleave those steps, so some updates get lost.
static void *race_worker(void *arg) {
    (void)arg;
    for (long i = 0; i < ITERATIONS; i++) {
        count++; // critical section, but nothing is guarding it
    }
    return NULL;
}

// Same work, but only one thread at a time may run count++
static void *safe_worker(void *arg) {
    (void)arg;
    for (long i = 0; i < ITERATIONS; i++) {
        sem_wait(&count_mutex); // wait for the single permit
        count++;                // critical section, now protected
        sem_post(&count_mutex); // give the permit back
    }
    return NULL;
}

// Run the experiment once with the given worker and return the final count
static long run_once(void *(*worker)(void *)) {
    pthread_t threads[NUM_THREADS];
    count = 0;

    for (int i = 0; i < NUM_THREADS; i++) {
        if (pthread_create(&threads[i], NULL, worker, NULL) != 0) {
            perror("pthread_create failed");
            return -1;
        }
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return count;
}

// Run NUM_RUNS experiments and print each result
static int run_experiment(void *(*worker)(void *), long expected) {
    for (int run = 1; run <= NUM_RUNS; run++) {
        long final = run_once(worker);
        if (final < 0) return -1;
        printf("Run %d: count = %-8ld lost updates = %ld\n",
               run, final, expected - final);
    }
    return 0;
}

// Command: race
void race_demo(void) {
    long expected = (long)NUM_THREADS * ITERATIONS;

    printf("--- Race Condition Demo ---\n");
    printf("%d threads each do count++ %d times.\n", NUM_THREADS, ITERATIONS);
    printf("Expected final count: %ld\n", expected);

    printf("\n[1] No synchronization:\n");
    if (run_experiment(race_worker, expected) < 0) return;
    printf("The threads interleaved their read/add/write steps, so some\n");
    printf("increments overwrote each other and disappeared.\n");

    printf("\n[2] With a semaphore around count++:\n");
    sem_init(&count_mutex, 0, 1);
    int result = run_experiment(safe_worker, expected);
    sem_destroy(&count_mutex);
    if (result < 0) return;
    printf("Only one thread can be inside the critical section at a time,\n");
    printf("so no updates are lost.\n");
}
