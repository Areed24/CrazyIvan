# Build the app test objects
#
CC = g++
CFLAGS  = -g -Wall
STD = -std=c++11
TESTS = configuration_test.o log_test.o utils_test.o

default: $(TESTS)

configuration_test.o: configuration_test.cpp
	$(CC) $(CFLAGS) -o $@ -c $^ $(STD) -I../../src/app/include

log_test.o: log_test.cpp
	$(CC) $(CFLAGS) -o $@ -c $^ $(STD) -I../../src/app/include

utils_test.o: utils_test.cpp
	$(CC) $(CFLAGS) -o $@ -c $^ $(STD) -I../../src/app/include
