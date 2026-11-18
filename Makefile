CC = gcc
CFLAGS = -Wall -Wextra -I./include -pthread

SRCS = src/main.c src/monitor.c src/process.c src/ipc.c src/race.c src/sync.c src/workers.c

TARGET = larpos

all: $(TARGET)

$(TARGET): $(SRCS) include/minios.h
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET)

clean:
	rm -f $(TARGET)