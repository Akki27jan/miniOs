#include<stdio.h>

int sysInfo(){
    // this code is to get the uptime and idle time from the proc folder for the system command
    FILE *fpp = fopen("/proc/uptime","r");

    if (fpp == NULL)
    {
        perror("fopen uptime");
        return 1;
    }

    double uptime,idle;
    if (fscanf(fpp, "%lf %lf" , &uptime, &idle) != 2)
    {
        fprintf(stderr, "couldnt read");
        fclose(fpp);
        return 1;
    }

    printf("System uptime is %.2f seconds \n", uptime);
    printf("System idle time is %.2f seconds \n", idle);
    fclose(fpp);
    
    // this code is to get the memory info from the proc folder for the system command
    FILE *fpm = fopen("/proc/meminfo","r");
    if (fpm == NULL)
    {
        perror("fopen meminfo");
        return 1;
    }

    char line[256];
    long memTot = 0;
    long memFree = 0;
    while (fgets(line, sizeof(line), fpm)) {
        if (sscanf(line, "MemTotal: %ld kB", &memTot) == 1) {
            continue;
        }
        if (sscanf(line, "MemFree: %ld kB", &memFree) == 1) {
            continue;
        }
        if (memFree != 0 && memTot != 0) {
            break; 
        }
    }
    if (memFree != 0 && memTot != 0)
    {
        printf("System has %ld KB of memory \n", memTot);
        printf("System has %ld KB of free memory \n", memFree);
    }
    fclose(fpm);
    

    return 0;
}