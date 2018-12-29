CC:=gcc
CXX:=g++
LINK_FLAGS=-Wl,--dynamic-linker=/data/data/com.termux/files/lib/ld-linux-armhf.so.3 -Wl,--rpath=/data/data/com.termux/files/lib
CFLAGS=-std=c++11 -pthread -fPIC -DDEBUG=1 -DMEASURE_TIME=0 -DSAVE_PIC=0 -DPIC_TEST=1
INC_DIR=-I./src -I./lib
LIB_DIR=-L.
LIB=-lpthread -lm

vpath %.c ./src ./lib
vpath %.cpp ./src ./lib

OUTDIR:=out

OBJS:=main.o
OUTOBJS+=$(addprefix $(OUTDIR)/, $(OBJS))
LIBOBJS:=$(addprefix $(OUTDIR)/, svm.o dollar.o)

ifeq ($(ARCH),arm)
CC:=arm-linux-gnueabihf-gcc
CXX:=arm-linux-gnueabihf-g++
endif

ifeq ($(OS),linux)
RM:=rm $(OUTDIR)/*.o *.so main
else
RM:=del $(OUTDIR)\*.o *.so main
endif

.PHONY:clean show push pull
all:$(OUTOBJS)
	@echo link: $^
	$(CXX) $^ -o main $(LIB_DIR) $(LIB) $(LINK_FLAGS)

libdollar.so:$(LIBOBJS)
	@echo build dynamic library libdollar.so
	@$(CXX) $^ -shared -o $@

$(OUTDIR)/%.o:%.s
	@echo cc: $<
	@$(CC) $(CFLAGS) -c $< -o $@ $(CFLAGS)
$(OUTDIR)/%.o:%.c
	@echo cc: $<
	@$(CC) $(CFLAGS) $(DEFS) $(INCS) -c $< -o $@ $(CFLAGS) $(INC_DIR)
$(OUTDIR)/%.o:%.cpp
	@echo cxx: $<
	@$(CXX) $(CFLAGS) $(DEFS) $(INCS) -c $< -o $@ $(CFLAGS) $(INC_DIR)

clean:
	$(RM)

push:
	ftp -n -s:"ftppushscript.txt"
pull:
	ftp -n -s:"ftppullscript.txt"
