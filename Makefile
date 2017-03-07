# ---------------------------------
# OrangePi V4L2 project
# Maintainer: Buddy <buddy.zhang@aliyun.com>
#
# Camera list:
# gc2035
# gc0309

CC=gcc
FLAGS= -I./include -ljpeg
TARGET= OrangePi_Capture

VPATH := src
V=

SharedLibrary= libOrangePi_SharedLib.so
OBJS= main.o
SharedFile= src/OrangePi_Configure.c OrangePi_SharedLib.c OrangePi_V4L2.c \
    OrangePi_ImageLibrary.c OrangePi_Debug.c

all: $(SharedLibrary) install $(TARGET)

$(TARGET): $(OBJS)
	$(V)$(CC) $< -ljpeg -lOrangePi_SharedLib -o $@
	$(V)rm *.o

$(SharedLibrary): $(SharedFile)
	$(V)$(CC) $^ $(FLAGS)  -shared -fPIC -o $@
	$(V)mv $@ /usr/lib/libOrangePi_SharedLib.so


# C source code
main.o: main.c
	$(V)$(CC) $< $(FLAGS) -c -o $@

# Flex source code
OrangePi_Configure.c: OrangePi_Configure.l
	$(V)flex $<
	$(V)mv lex.yy.c src/OrangePi_Configure.c

.PHONY: install
install:
	$(V)cp -rfa include/OrangePiV4L2 /usr/include
	$(V)install OrangePi_Camera.conf /etc

.PHONY: clean
clean:
	$(V)rm -rf *.o $(TARGET) lib/*.so

