#!/bin/bash
#Candice Shepherd 10024859

dirname=$1
datadir=0
emptydir=0
datafile=0
emptyfile=0

#go through every item in the given directory 
for item in $dirname; do
   if [ -d $item ]; then #check if item is a directory
     if [ -z "$(ls -A "$item")" ]; then #check if directory is NOT empty
        ((datadir=datadir+1)) #add 1 to variable
      elif ! [ -z "$(ls -A "$item")" ];then #check if directory is empty
         ((emptydir=emptydir+1)) #add 1 to variable
      fi
           
   elif [ -f $item ]; then #check if item is a file
      if [ -s $item ]; then #check if file is NOT empty
       ((datafile=datafile+1)) #add 1 to variable
      elif ! [ -s $item ]; then #check if file is empty
       ((emptyfile=emptyfile+1)) #add 1 to variable
      fi
   fi 
done
#display variable totals
echo "the $dirname contains
 $datafile files that contain data 
 $emptyfile files that are empty 
 $datadir non-empty directories
 $emptydir empty directories"

exit 0


