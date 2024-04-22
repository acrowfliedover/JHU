All: mainRong
LIB=libRong.o
LIB2=test2lib.o
CC=gcc

mainRong: mainRong.o $(LIB) $(LIB2)
	$(CC) $@.o $(LIB) $(LIB2) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
