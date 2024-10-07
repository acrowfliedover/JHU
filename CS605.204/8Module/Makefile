All: mainToTest
LIB=libConversions.o
CC=gcc

mainToTest: mainToTest.o $(LIB)
	$(CC) $@.o $(LIB) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
