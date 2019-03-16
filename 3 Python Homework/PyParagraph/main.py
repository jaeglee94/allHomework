#import libraries
import os
import re

#set file path
file = os.path.join("sample.txt")

#Initialize variables
wordCount = 0
sentCount = 0
letterCount = 0.0
sentLength = 0.0
totalSentLength = 0.0
total = 0.0

#read text file
with open(file,"r") as txtfile:
    text = txtfile.read()

#get list of words
words = text.split(" ")

#determine wordcount by length
wordCount = len(words)

#get total character count
for word in words:
    total += len(word)

#get average letter count
letterCount = total/wordCount

#split sentences into list
sent = re.split("(?<=[.!?]) +", text)

#get number of sentences
sentCount = len(sent)

sentLength = wordCount/sentCount

output = (f"Paragraph Analysis \n"
         f"--------------------- \n"
         f"Apprximate Word Count: {wordCount} \n"
         f"Apprximate Sentence Count: {sentCount} \n"
         f"Average Letter Count: {letterCount} \n" 
         f"Average Sentence Length: {sentLength}")

print(output)