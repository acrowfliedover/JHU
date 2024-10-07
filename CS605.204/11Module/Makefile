All: mainAssignment11
LIB=libAssignment11.o
CC=gcc

mainAssignment11: mainAssignment11.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
