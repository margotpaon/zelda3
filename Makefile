TARGET_EXEC:=zelda3
ROM:=tables/zelda3.sfc
SRCS:=$(wildcard *.c snes/*.c)
OBJS:=$(SRCS:%.c=%.o)
PYTHON:=/usr/bin/env python3
CFLAGS:=$(if $(CFLAGS),$(CFLAGS),-O2)

CFLAGS:=${CFLAGS} $(shell sdl2-config --cflags)
LDFLAGS:=${LDFLAGS} $(shell sdl2-config --libs)

.PHONY: all clean clean_obj clean_gen

all: $(TARGET_EXEC)
$(TARGET_EXEC): tables/zelda3_assets.dat $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
tables/zelda3_assets.dat: tables/dialogue.txt
	cd tables; $(PYTHON) compile_resources.py ../$(ROM)
tables/dialogue.txt:
	cd tables; $(PYTHON) extract_resources.py ../$(ROM)
%.o : %.c tables/zelda3_assets.dat
	$(CC) -c $(CFLAGS) $< -o $@

clean: clean_obj clean_gen
clean_obj:
	$(RM) $(OBJS) $(TARGET_EXEC)
clean_gen:
	$(RM) tables/zelda3_assets.dat
