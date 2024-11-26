import time
import random
import numpy as np
import math


# Generate a string of length n made of 0 and 1
def generateRandomBits(n):
    number=random.getrandbits(n)
    output=format(number, 'b')
    output='0'*(n-len(output))+output
    return output


# Generate a number between 3 and n
def generateRandomsSize(n):
    return random.randint(3,int(n))

# Generate a number between 1 and n
def generateRandomxySize(n):
    return random.randint(1,int(n))

# generate the random s, x, and y with random inputs, 
# with s of length n
# x of length p
# y of length q
def generateRandomInputs(n,p,q):
    s=generateRandomBits(n)
    x=generateRandomBits(p)
    y=generateRandomBits(q)
    return [s,x,y]


# generate a random input of s size n, x and y at most n/2
def generateRandomInputArray(n):
    s=n
    x=generateRandomxySize(s/2)
    y=generateRandomxySize(s/2)
    return generateRandomInputs(s,x,y)


# print output to file
def printOutputToFile(s):
    
    fo.write(str(s))
    fo.write("\n")
    



# the main algorithm of this assignment
# input three strings of 1's and 0's s, x, y
# output true or false, whether s is an interweave of x and y

def checkInterweaving(s,x,y):
  
    numberOfComparisons=0
    printOutputToFile([s,x,y])
    slength=len(s)
    xlength=len(x)
    ylength=len(y)
    printOutputToFile("Length of s is: "+ str(slength))
    printOutputToFile("Length of x is: "+ str(xlength))
    printOutputToFile("Length of y is: "+ str(ylength))
    for a in range(slength):
        if slength-a<xlength+ylength:
            numberOfComparisons+=1
            printOutputToFile("number of comparisons is "+ str(numberOfComparisons))
            printOutputToFile("It is not an interweave")
            return False
        dp=[]
        dp.append([True])
        for k in range(1, slength-a):
            isAllFalse=True

    # split and statements to count comparisons
            if dp[k-1][0]:
                numberOfComparisons+=1
                if s[a+k-1]==x[(k-1)%xlength]:
                    numberOfComparisons+=1
                    dp.append([True])   
                    isAllFalse=False
                else:
                    dp.append([False])
                    numberOfComparisons+=1
            else:
                dp.append([False])
                numberOfComparisons+=1

    # split and statements to count comparisons
            if dp[0][k-1]:
                numberOfComparisons+=1
                if s[a+k-1]==y[(k-1)%ylength]:
                    numberOfComparisons+=1
                    dp[0].append(True)
                    isAllFalse=False
                else:
                    dp[0].append(False)
                    numberOfComparisons+=1
            else:
                dp[0].append(False)
                numberOfComparisons+=1

            for i in range(1,k):

                # split (and)or(and) statement
                if dp[i-1][k-i] and s[a+k-1]==x[(i-1)%xlength]: 
                    dp[i].append(True)
                    if i>=xlength and k-i >=ylength:
                        printOutputToFile("number of comparisons is "+ str(numberOfComparisons))
                        printOutputToFile("It is an interweave")
                        return True
                    isAllFalse=False
                elif dp[i][k-i-1] and s[a+k-1]==y[(k-i-1)%ylength]:
                    dp[i].append(True)
                    if i>=xlength and k-i >=ylength:
                        printOutputToFile("number of comparisons is "+ str(numberOfComparisons))
                        printOutputToFile("It is an interweave")
                        return True
                    isAllFalse=False
                else:
                    dp[i].append(False)
            if isAllFalse:
                break
    printOutputToFile("number of comparisons is "+ str(numberOfComparisons))
    printOutputToFile("It is not an interweave")
    return False



def testWithRandomInputOfSizeNkTimes(n,k):
    for i in range(k):
        inputs=generateRandomInputArray(n)
        print(checkInterweaving(inputs[0],inputs[1],inputs[2]))



# print(ci.checkInterweaving('100110111','101101','011')) #outputs false
# print(ci.checkInterweaving('100010111101111','101101','011')) #outputs true
# print(ci.checkInterweaving('100011111110111111','101101','011')) #outputs false
# print(ci.checkInterweaving('1001101110111111','101101','011')) #outputs true
fo = open("output.txt", "w")
testWithRandomInputOfSizeNkTimes(10,5)
fo.close
