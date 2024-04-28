All: rfan13_team3_rsa
LIB=libRong.o
LIB2=libYan.o
LIB3=libColin.o
LIB4=DecryptionMainTest.o

CC=gcc

rfan13_team3_rsa: rfan13_team3_rsa.o $(LIB) $(LIB2) $(LIB3) $(LIB4)
	$(CC) $@.o $(LIB) $(LIB2) $(LIB3) $(LIB4) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
