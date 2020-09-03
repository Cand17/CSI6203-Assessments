#!/bin/bash
#Candice Shepherd 10024859

#set IFS to go create new lines
orig_ifs=IFS
IFS=$'\n'

#prompt user for search parameters
read -p "Enter pattern to search for: " pattern

read -p "Would you like an exact word match (y\n)?: " exact

read -p "Would you like a wildcard match (y\n)?: " wildcard

read -p "Would you like an inverted match (y\n)?: " inverted

#display count of parameters
if [[ $exact == "y" ]] && [[ $inverted == "n" ]]; then
 grep -wc "$pattern" access_log.txt
fi
if [[ $exact == "n" ]]; then
#display count with pattern case insensitive
   grep -wci "$pattern" access_log.txt
fi
if [[ $inverted == "y" ]]; then
#display count of lines not containing pattern
   grep -v -wci "$pattern" access_log.txt
fi

#search through every line of access_log.txt
for line in $(cat access_log.txt); do
#check if pattern is in log, if user answered "y" and "n" to second and fourth questions
    if [[ $line == *"$pattern"* ]] &&  [[ $exact == "y" ]] && [[ $inverted == "n" ]]; then
        #display lines containing matches
        echo "$line"
# check if pattern is in log if users answered "n" to second question"
    elif  [[ $exact == "n" ]]; then
    #check if pattern is in log
            if  [[ $line == *"$pattern"* ]]; then
            #display lines containing matches
            echo "$line"
            fi
#check if pattern is not in log if user anwers "y" to questions one and four
    elif [[ $exact == "y" ]] && [[ $inverted == "y" ]]; then
       #Display lines that don't contain pattern
       grep -v "$pattern" access_log.txt
    fi
done

#return orig_ifs to default
IFS=orig_ifs
#exit program
exit 0
