#Import Libraries
import os
import csv

#Initialize file path and variables
file = os.path.join("election_data.csv")
dataset = []
voteDict = {}
totalVote = 0

#Creating Functions
#Creating function to print dictionary values to terminal
def printDict(d):
    for key in d:
        print (key + ": " +str(round((d[key]/totalVote)*100,2)) + "% (" + str(d[key]) + ")")

#Creating sorting function to find winner with most votes and return result
def findWinner(d):
        winner = next(iter(d))
        for key in d:
                if d[key] > d[winner]:
                        winner = key
        return winner

#Reading CSV file to new dataset
with open(file,"r",newline = "") as csvfile:
    csvreader = csv.reader(csvfile,delimiter = ",")
    
    for lines in csvreader:
        dataset.append(lines)
    
#Finding total vote count and individual vote counts
for lines in dataset[1:]:
    totalVote += 1
    if lines[2] in voteDict:
        voteDict[lines[2]] = voteDict[lines[2]] + 1
    else:
        voteDict[lines[2]] = 1

#Assigning result variables
finalPrint = (f"Election Results \n"
          f"-------------------- \n"
          f"Total Votes: {totalVote} \n"
          f"--------------------\n")

finalPrint2 = (f"--------------------\n"
          f"Winner: " + findWinner(voteDict) + "\n"
          f"--------------------")

#Printing results to terminal
print(finalPrint)
printDict(voteDict)
print(finalPrint2)

#Set Output Text Pathway and file name
output_path = os.path.join("result.txt")

#Write to text file the result
with open(output_path,"w",newline="") as textfile:
    textfile.write(finalPrint)
    for key in voteDict:
        textfile.write(key + ": " +str((voteDict[key]/totalVote)*100) + "% (" + str(voteDict[key]) + ") \n")
    textfile.write(finalPrint2)