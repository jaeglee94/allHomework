#import libraries
import os
import csv

#set file path
file = os.path.join("employee_data.csv")

#initialize variables
df = []

id = []
name = []
dob = []
ssn = []
state = []

first = []
last = []
dobClean = []
ssnClean = []
stateClean = []

#initialize state dictionary
us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY',
}


#read rows into dataframe
with open(file,"r",newline = "") as csvFile:
    csvreader = csv.reader(csvFile,delimiter = ",")
    for lines in csvreader:
        df.append(lines)

#split initial values into separate lists
for lines in df[1:]:
    id.append(lines[0])
    name.append(lines[1])
    dob.append(lines[2])
    ssn.append(lines[3])
    state.append(lines[4])
    
#split first and last names by space
for lines in name:
    x = lines.split()
    first.append(x[0])
    last.append(x[1])

#rearrange DOB by splitting and re-concatenating
for lines in dob:
    x = lines.split("-")
    dobClean.append(x[1] + "/" + x[2] + "/" + x[0])

#rearrange SSN by splitting and re-concatenating
for lines in ssn:
    x = lines.split("-")
    ssnClean.append("***-**-" + x[2])

#get state abbreviations from dictionary and append to new list
for lines in state:
    stateClean.append(us_state_abbrev.get(lines))

#zip together lists
final = zip(id,first,last,dobClean,ssnClean,stateClean)

#print final list
for lines in final:
    print(lines)