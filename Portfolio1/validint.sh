#!/bin/bash
#Candice Shepherd 10024859

#num is an input that must be an integer for two characters
num='^[0-9]+$'

while true; do
#prompt the reader to enter a number
     read -p 'Enter a two digit integer between 20 and 40: ' int
     #if the number is NOT two digits OR it is less than 20 OR greater than 40, prompt user to try again
       if ! [[ $int =~ $num ]] || [ $int -lt 20 ] || [ $int -gt 40 ]; then
           echo "Invalid input, please try again"
       else #if number meets criteria, exit loop
           break
       fi
done
echo "Thank you, correct input entered"
exit 0