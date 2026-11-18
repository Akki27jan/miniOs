#include <stdio.h>
#include <pthread.h>
#include "../include/minios.h"

#define NUM_THREADS 2
#define ITERATIONS 100000
#define NUM_RUNS 5

// Shared by every worker thread, with NO protection
static long count = 0;

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

// Run the experiment once and return the final count
static long run_once(void) {
    pthread_t threads[NUM_THREADS];
    count = 0;

    for (int i = 0; i < NUM_THREADS; i++) {
        if (pthread_create(&threads[i], NULL, race_worker, NULL) != 0) {
            perror("pthread_create failed");
            return -1;
        }
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return count;
}

// Command: race
void race_demo(void) {
    long expected = (long)NUM_THREADS * ITERATIONS;

    printf("--- Race Condition Demo ---\n");
    printf("%d threads each do count++ %d times, with no synchronization.\n",
           NUM_THREADS, ITERATIONS);
    printf("Expected final count: %ld\n\n", expected);

    for (int run = 1; run <= NUM_RUNS; run++) {
        long final = run_once();
        if (final < 0) return;
        printf("Run %d: count = %-8ld lost updates = %ld\n",
               run, final, expected - final);
    }

    printf("\nThe threads interleaved their read/add/write steps, so some\n");
    printf("increments overwrote each other and disappeared.\n");
}
