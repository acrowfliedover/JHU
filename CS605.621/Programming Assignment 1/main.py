import ClosestMPair as cp
import time


def testWithRandomInputOfSizeNkTimes(k,n):
    for i in range(k):
        inputList=cp.generateRandomInputArray(n)
        print(f"The list of input points: {inputList}")
        outputCount=cp.generateRandomOutputSize(n)
        closestMPair=cp.cloestMPair(inputList,outputCount)
        print(f"The list of closest distances: {closestMPair}")

def testWithInputsAndOutputLengths(n,m):
    if isinstance(n,int) and n<2:
        print("please enter an integer larger than 1")
        return
    inputList=cp.generateRandomInputArray(n)
    #print(inputList)
    closestMPair=cp.cloestMPair(inputList,m)
    #print(closestMPair)
    return closestMPair

k=10
n=8000
m=1000000

start_time = time.process_time()
testWithRandomInputOfSizeNkTimes(k,n)
#testWithInputsAndOutputLengths(n,m)
end_time = time.process_time()

print(f"For input length of {n} and output length of {m}, it takes {end_time - start_time} seconds")