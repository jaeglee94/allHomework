import os
import csv

file = os.path.join("election_data SHORTENED.csv")
dataset = []
voteDict = {}
totalVote = 0

def printDict(d):
    for key in d:
        print (key + ": " +str((d[key]/totalVote)*100) + "% (" + str(d[key]) + ")")

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

Result = (f"Election Results \n"
          f"-------------------- \n"
          f"Total Votes: {totalVote} \n"
          f"-------------------- \n")

print(Result)
printDict(voteDict)