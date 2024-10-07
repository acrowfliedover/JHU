All: mainAssignment9
LIB=libAssignment9.o
CC=gcc

mainAssignment9: mainAssignment9.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
