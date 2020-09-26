#!/bin/bash

#Candice Shepherd 100248509

#Declare an array
declare -a VALUES
#Read values from file into array
VALUES=(`cat "values.txt"`)
#Assign length of array to variable
len=${#VALUES[*]}

#Create c-style loop, check every value of array for critieria
for (( i=0; i<${len}; i++ ));do
   for item in "${VALUES[@]}";do   
  #Check if array value is numbers only
    if [[ $item =~ ^[0-9]+$ ]];then
         echo "$item is compromised of numbers only"
  #Check if array value is letters only
    elif [[ "$item" =~ ^[a-zA-Z]+$ ]];then
         echo "$item is comprised of letters only"
  #If array value is neither only numbers or letters, it must be comprised of both
    else
         echo "$item is comprised of numbers and letters"

        fi
   done
   #After all array values checked, exit loop
   exit 1 
done

exit 0
