import os
import csv

file = os.path.join("budget_data.csv")
dataSet=[]
PL = []
months = 0
netTotal = 0
average = 0.0

with open(file,"r",newline = "") as csvfile:
    csvreader = csv.reader(csvfile,delimiter =",")

    for lines in csvreader:
        dataSet.append(lines)
        
for lines in dataSet[1:]:
    PL.append(int(lines[1]))
    months += 1
    netTotal = netTotal + int(lines[1])

average = round(netTotal/months,2)
maxProfit = max(PL)
maxLoss = min(PL)
maxProfitMonth = ""
maxLossMonth = ""

for lines in dataSet[1:]:
    if lines[1] == str(maxProfit):
        maxProfitMonth = lines[0]
    elif lines[1] == str(maxLoss):
        maxLossMonth = lines[0]

Result = (f"Financial Analysis\n" 
          f"----------------------------\n"
          f"Total months: {months}\n"
          f"Total: ${netTotal}\n"
          f"Average Change: ${average}\n"
          f"Greatest Increase in Profits: {maxProfitMonth} (${maxProfit}) \n"
          f"Greatest Decrease in Profits: {maxLossMonth} (${maxLoss}) \n")

print(Result)
