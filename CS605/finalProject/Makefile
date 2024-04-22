All: mainRong
LIB=libRong.o
CC=gcc

mainRong: mainRong.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
