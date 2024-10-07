# List of all target executables
ALL_TARGETS = testMathLib

# Object file library
LIB = mathLib.o

# Compiler
CC = gcc
AS = as

# Compiler flags
CFLAGS = -g
ASFLAGS = -g

# Default target
all: $(ALL_TARGETS)

# Rule to build object file from assembly source file
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# Rule to build target executables
testMathLib: $(LIB)
	$(CC) testMathLib.o $(LIB) $(CFLAGS) -o $@

# Rule to clean up object files and executables
clean:
	rm -f $(ALL_TARGETS) *.o

