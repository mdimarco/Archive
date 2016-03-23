#Expects sys args to be a list of space separated files
#Utilizes the stat unix command with -c %X flag, getting the soonest access time
#NOTE: stat being a unix command can cause problems when run on non-unix
#      operating systems

#NOTE 2: This will output an error if such a file provided is not found in
# the filesystem

import subprocess #similar to os.system, however os.system soon to be depracated
import sys

numbArgs = len(sys.argv)
args = sys.argv
args.pop(0) #gets rid of the pyprocess.py

callString = "stat -c %X "
for arg in args:
	callString += arg + " "
#string for bash command now complete

result = subprocess.check_output(callString, shell=True)
result = result.split()

minTup = (args[0], int(result[0]) )
for x in range(len(result)):
	curr = int(result[x])
	if( curr > minTup[1]):
		minTup = (args[x], curr)
print(minTup[0])


