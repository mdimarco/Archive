#!/bin/sh
userid=$1	
echo "Question 1"
cat talking.txt | ./hex2raw | ./buffer -u $userid | grep VALID  
echo "Question 2"
cat walking.txt | ./hex2raw | ./buffer -u $userid | grep VALID
echo "Question 3"
cat flying.txt | ./hex2raw | ./buffer -u $userid | grep VALID
echo "Question 4"
cat fire-breathing.txt | ./hex2raw -n | ./buffer -n -u $userid | grep VALID
