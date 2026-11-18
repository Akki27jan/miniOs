#include<stdio.h>
#include<ctype.h>
#include<dirent.h>
#include "../include/minios.h"

void sysInfo(void){
    // this code is to get the uptime and idle time from the proc folder for the system command
    FILE *fpp = fopen("/proc/uptime","r");

    if (fpp == NULL)
    {
        perror("fopen uptime");
        return;
    }

    double uptime,idle;
    if (fscanf(fpp, "%lf %lf" , &uptime, &idle) != 2)
    {
        fprintf(stderr, "couldnt read");
        fclose(fpp);
        return;
    }

    printf("System uptime is %.2f seconds \n", uptime);
    printf("System idle time is %.2f seconds \n", idle);
    fclose(fpp);

    // this code is to get the memory info from the proc folder for the system command
    FILE *fpm = fopen("/proc/meminfo","r");
    if (fpm == NULL)
    {
        perror("fopen meminfo");
        return;
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
}

// this code is for the processes command, every numbered folder in /proc is a running process
void show_processes(void){
    DIR *dir = opendir("/proc");
    if (dir == NULL)
    {
        perror("opendir /proc");
        return;
    }

    printf("%7s  %-14s %9s  %s\n", "PID", "STATE", "MEM(KB)", "NAME");

    struct dirent *entry;
    int count = 0;
    while ((entry = readdir(dir)) != NULL) {
        // skip things like /proc/meminfo, we only want the numbered folders
        if (!isdigit((unsigned char)entry->d_name[0])) {
            continue;
        }

        char path[300];
        snprintf(path, sizeof(path), "/proc/%s/status", entry->d_name);
        FILE *fp = fopen(path, "r");
        if (fp == NULL) {
            continue; // the process exited while we were looking
        }

        char line[256];
        char name[64] = "?";
        char state[32] = "?";
        long mem = 0;
        while (fgets(line, sizeof(line), fp)) {
            sscanf(line, "Name:\t%63[^\n]", name);
            sscanf(line, "State:\t%31[^\n]", state);
            sscanf(line, "VmRSS: %ld", &mem); // kernel threads don't have this
        }
        fclose(fp);

        if (mem > 0)
            printf("%7s  %-14s %9ld  %s\n", entry->d_name, state, mem, name);
        else
            printf("%7s  %-14s %9s  %s\n", entry->d_name, state, "-", name);
        count++;
    }
    closedir(dir);

    printf("%d processes running\n", count);
}
