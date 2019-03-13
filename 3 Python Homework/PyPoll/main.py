import os
import csv

file = os.path.join("election_data SHORTENED.csv")
dataset = []
voteDict = {}
totalVote = 0

def printDict(d):
    for key in d:
        print (key + ": " +str((d[key]/totalVote)*100) + "% (" + str(d[key]) + ")")

def findWinner(d):
        winner = next(iter(d))
        for key in d:
                if d[key] > d[winner]:
                        winner = key
        return winner

with open(file,"r",newline = "") as csvfile:
    csvreader = csv.reader(csvfile,delimiter = ",")
    
    for lines in csvreader:
        dataset.append(lines)
    
for lines in dataset[1:]:
    totalVote += 1
    if lines[2] in voteDict:
        voteDict[lines[2]] = voteDict[lines[2]] + 1
    else:
        voteDict[lines[2]] = 1

def finalPrint(votes,d):
        print (f"Election Results \n"
          f"-------------------- \n"
          f"Total Votes: {votes} \n"
          f"--------------------")
        printDict(voteDict)
        print(f"--------------------\n"
          f"Winner: " + findWinner(voteDict) + "\n"
          f"--------------------")

finalPrint(totalVote,voteDict)
findWinner(voteDict)