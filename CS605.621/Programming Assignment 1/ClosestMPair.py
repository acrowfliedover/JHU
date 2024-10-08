# Online Python - IDE, Editor, Compiler, Interpreter

import random
import numpy as np
import math
import heapq

# Generate a random point (x, y) where x and y are in the range [-10, 10]
# the range can be larger if needed but it shouldn't affect performance that much
def generateRandomPoint():
    x = random.uniform(-10, 10)
    y = random.uniform(-10, 10)
    return (x,y)

# generate the input size n
def generateRandomInputSizeWithMaximumN(n):
    return random.randint(2,n)

# generate the output size m given the inputSize n
def generateRandomOutputSize(inputSize):
    return random.randint(1,inputSize*(inputSize-1)/2)


# generate a random list of input of size 2 to 100
def generateRandomInputArray(n):
    outputList=[]
    for i in range(n):
        outputList.append(generateRandomPoint())   
    return outputList

# calculate the Euclidean distance between two points
# Each point is a tuple of two floats
def calculateEuclideanDistance(pointa,pointb):
    return math.sqrt((pointa[0]-pointb[0])*(pointa[0]-pointb[0])+(pointa[1]-pointb[1])*(pointa[1]-pointb[1]))

# the main algorithm of this assignment
# input: a list of tuples of size which contains the coordinates, with size n,
# and an int m which is the size of output
# The idea is to find the distance of each pair of points and store the triplet in a max-heap. We 
# can keep the heap with maximum length m, and keep the pairs with the smallest distance, so at the
# end of the operation, the heap will be the output.
def cloestMPair(P,m):
    n=len(P)
    maxHeap = []
    for i in range(0,n-1):
        for j in range(i+1,n):
            distance=calculateEuclideanDistance(P[i],P[j])

            # since heapq is implemented as a min-heap, we can get the max-heap by negating the distance
            heapq.heappush(maxHeap,(-distance,i,j))
            if len(maxHeap)>m:
                heapq.heappop(maxHeap)
    print(m)
    # we negate the distance back for the output
    for i in range(0,m):
        tuple=maxHeap[i]
        maxHeap[i] = (-tuple[0],tuple[1],tuple[2])
    return maxHeap