#!/bin/bash

#Candice Shepherd 10024859

getprop(){
    #For file received:
    #Display size in kilobytes
    #Display number of words
    #Display last time modified
    filesize=$(du -k "$filename" | cut -f 1)
    wordcount=$(cat $filename | wc -w)
    modified=$(date -r $filename "+%d-%m-%Y %H:%M:%S")

    echo "The file $filename contains $wordcount words and is $filesize K in size and was last modified $modified"

}
#Ask user for a file
read -p "Please enter name of file to check: " filename
#Call function
getprop $filename