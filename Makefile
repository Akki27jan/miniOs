CC = gcc
CFLAGS = -Wall -Wextra -I./include

SRCS = src/main.c src/monitor.c src/process.c

TARGET = larpos

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET)

clean:
	rm -f $(TARGET)