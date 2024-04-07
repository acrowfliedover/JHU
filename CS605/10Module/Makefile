All: mainAssignment10
LIB=libAssignment10.o
CC=gcc

mainAssignment10: mainAssignment10.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
