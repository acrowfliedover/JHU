All: rfan13_team3_rsa
LIB=libRong.o
LIB2=libConversion.o
LIB3=libConversionColin.o
LIB4=DecryptionMainTest.o

CC=gcc

mainRong: mainRong.o $(LIB) $(LIB2) $(LIB3) $(LIB4)
	$(CC) $@.o $(LIB) $(LIB2) $(LIB3) $(LIB4) -g -o $@

.s.o:
	$(CC) $(@:.o=.s) -g -c -o $@
