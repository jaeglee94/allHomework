#Import Libraries
import os
import csv
from statistics import mean

#Initialize Variables
file = os.path.join("budget_data.csv")
dataSet=[]
PL = []
plChange = []
months = 0
netTotal = 0
average = 0.0

#Read CSV to list variable
with open(file,"r",newline = "") as csvfile:
    csvreader = csv.reader(csvfile,delimiter =",")

    for lines in csvreader:
        dataSet.append(lines)

#Close file and create separate list just for P/L        
for lines in dataSet[1:]:
    PL.append(int(lines[1]))
    #determine months and netTotal through loop
    months += 1
    netTotal = netTotal + int(lines[1])

i = 1
for i in range(len(PL)):
    plChange.append(PL[i]-PL[i-1])
plChange = plChange[1:]


#Determine average, max, min and initialize max profit/loss month variables
average = round(mean(plChange),2)
maxProfit = max(PL)
maxLoss = min(PL)
maxProfitMonth = ""
maxLossMonth = ""

#Search in list for max profit or max loss value, return month associated with value
for lines in dataSet[1:]:
    if lines[1] == str(maxProfit):
        maxProfitMonth = lines[0]
    elif lines[1] == str(maxLoss):
        maxLossMonth = lines[0]

#Initialize formatted currency variables
netTotalFormatted = "{:,}".format(netTotal)
averageFormatted = "{:,}".format(average)
maxProfitFormatted = "{:,}".format(maxProfit)
maxLossFormatted = "{:,}".format(maxLoss)


#Print variables to console with block string
Result = (f"Financial Analysis\n" 
          f"----------------------------\n"
          f"Total months: {months}\n"
          f"Total: ${netTotalFormatted}\n"
          f"Average Change: ${averageFormatted}\n"
          f"Greatest Increase in Profits: {maxProfitMonth} (${maxProfitFormatted}) \n"
          f"Greatest Decrease in Profits: {maxLossMonth} (${maxLossFormatted}) \n")

#Print Result to Terminal
print(Result)

#Set Output Text Pathway and file name
output_path = os.path.join("result.txt")

#Write to text file the result
with open(output_path,"w",newline="") as textfile:
    textfile.write(Result)

