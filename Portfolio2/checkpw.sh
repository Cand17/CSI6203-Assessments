#!/bin/bash

#Candice Shepherd 10024859

#Remove first line - not needed "NR>1"
#Test if password (default var 2) contains 8 or more characters AND contains a number AND contains a capital letter
#If password passes all tests, print that is meets requirements
#If password doesn't pass all tests, print that it doesn't meet requirements

awk ' NR>1 { if (length($2) >=8 && $2 ~ /[0-9]/ && $2 ~ /[A-Z]/ )
        {
            print " "$2" - meets password strength requirements " 


        }
    else
        {
            print " "$2" - does NOT meet password strength requirements "
        }
        
}   
' usrpwords.txt #sourcefile