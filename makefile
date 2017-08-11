# define some Makefile variables for the compiler and compiler flags
# to use Makefile variables later in the Makefile: $()
#
CC = g++
SLC = ar rcs
CFLAGS  = -g -Wall
STD = -std=c++11
MODEL_OBJS = src/model/transform.o src/model/user_device.o src/model/scene.o
API_OBJS = src/api/Scene.pb.cc src/api/json_scene_list.o src/api/protobuf_scene_list.o
APP_OBJS = src/app/ivan_log.o src/app/configuration_manager.o src/app/globals.o
QUERY_OBJS = src/proc/query/device_query_helper.o src/proc/query/scene_query_helper.o src/proc/query/algorithm_query_helper.o
PROC_OBJS = src/proc/processor/base_message_processor.o src/proc/processor/crud_message_processor.o src/proc/processor/message_processor.o
OBJS = $(MODEL_OBJS) $(API_OBJS) $(APP_OBJS) $(QUERY_OBJS) $(PROC_OBJS) main.o
TESTS = scene_test configuration_test
LIBS = -lpthread -llog4cpp
FULL_LIBS = -laossl -lcurl -lpthread -lzmq -lneo4j-client -lssl -lcrypto -lm -llog4cpp -luuid -lhiredis `pkg-config --cflags --libs protobuf`
PROTOC = protoc
PROTO_OPTS = -I=/usr/local/include/dvs_interface
INCL_DIRS = -I. -I$(CURDIR)/src/app/ -I$(CURDIR)/src/api/ -I$(CURDIR)/src/api/include -I$(CURDIR)/src/model/ -I$(CURDIR)/src/proc/processor/ -I$(CURDIR)/src/proc/query

.PHONY: mksrc mktest

# -------------------------- Central Targets --------------------------------- #

all: mksrc main.o crazy_ivan

mksrc: src/api/Scene.pb.cc
	@$(MAKE) -C src

main.o: main.cpp
	$(CC) $(CFLAGS) -o $@ -c main.cpp $(STD) -Isrc/ $(INCL_DIRS)

crazy_ivan:
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(FULL_LIBS) $(STD) $(INCL_DIRS)

src/api/Scene.pb.cc: /usr/local/include/dvs_interface/Scene.proto
	$(PROTOC) $(PROTO_OPTS) --cpp_out=src/api /usr/local/include/dvs_interface/Scene.proto
	mv src/api/Scene.pb.h src/api/include

# ------------------------------- Tests -------------------------------------- #

test: mktest $(TESTS)

mktest:
	@$(MAKE) -C test

scene_test: src/Scene.pb.cc src/ivan_log.o src/scene.o test/scene_test.o
	$(CC) $(CFLAGS) -o $@ $^ $(FULL_LIBS) $(STD)

configuration_test: src/ivan_log.o src/configuration_manager.o test/configuration_test.o
	$(CC) $(CFLAGS) -o $@ $^ $(FULL_LIBS) $(STD)

# --------------------------- Clean Project ---------------------------------- #

clean:
	$(RM) crazy_ivan *.o src/*/*.o src/*/*/*.o *~ *.log *.log.* src/*/*.pb.cc src/*/*/*.pb.h *_test test/*.o
