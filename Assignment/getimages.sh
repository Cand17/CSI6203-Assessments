#!/bin/bash

#Candice Shepherd 10024859



curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=ml-2018-campus/" > temp1.txt
cat temp1.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' > filelist.txt

files=`cat "filelist.txt"`

#Check if user input is all numbers, correct length and that the file exists
validate () 
{
   while true;do
    if ! [[ $digits =~ ^[0-9]+$ ]] || ! [ ${#digits} -eq 4 ];then
                   echo "Invalid input, please try again"
                   read -p "Please enter the last four digits of the filename: " digits
                   
    else
        break
    fi
   done 
   
   while true;do 
    if grep -Fxq "DSC0$digits.jpg" filelist.txt
      then
         echo "Filename exists"
         break
    else
          echo "Filename not available or does not exist"
          read -p "Please enter the last four digits of the filename: " digits
    fi
   done    
    
}
#Check if directory already exists. If it doesn't, create it
valdir ()
{

             if [ -d $usrdir ];then
               echo "This directory already exists"
               else
                   mkdir $usrdir
                   echo "Created directory $usrdir"
             fi    
}
#Check if file already exists in directory. If it does and user wants to overwrite it, delete existing file
searchfile ()
{     
     
      file=$usrdir/DSC0$digits.jpg
      if [[ -f $file ]];then
        read -p "File already exists,do you wish to overwrite?(y/n): " over
           if [[ $over =~ ^([yY][eE][sS])$ ]];then
             rm -r $file
             
           fi                              
      fi     
}
#Check if user input is all number and correct length. Check if given range exists.
vallower ()
{
 while true;do   
    if ! [[ $lower =~ ^[0-9]+$ ]] || ! [ ${#lower} -eq 4 ];then
                   echo "Invalid input, please try again"
                   read -p "Please enter last four digits: " lower                                    
    else
         echo "Input is a number and correct length"
         break
    fi 
 done  

 while true;do 
    if ! [ $lower -lt 0200 ] && ! [ $lower -gt 0674 ];then          
         break
    else
          echo "Number entered not in range"
          read -p "Please enter the last four digits of the start of the range: " lower
    fi
 done    
}
#Check if user input is all numbers and correct length. Check if given range exists
valupper ()
{
 while true;do
    if ! [[ $upper =~ ^[0-9]+$ ]] || ! [ ${#upper} -eq 4 ];then
                   echo "Invalid input, please try again"
                   read -p "Please enter the last four digits of the end of the range: " upper
    else
         echo "Input is a number and correct length"
         break
    fi 
 done  

 while true;do 
    if ! [ $upper -lt 0200 ] && ! [ $upper -gt 0674 ];then          
         break
    else
          echo "Number entered not in range"
          read -p "Please enter the last four digits of the start of the range: " upper
    fi
 done        
}
#Check that user input is all numbers and number of images requested can be downloaded
valnumimage ()
{
  while true;do 
   if ! [[ $numimage =~ ^[0-9]+$ ]] || [ $numimage -gt 147 ];then
      echo "Invalid input, please try again"
      read -p "Please enter again: " numimage
   else
       break
   fi    
  done     
}
#Check if the upper value is higher than the lower value in range      
valrange ()
{
    if [[ $lower > $upper ]];then
          echo "Incorrect ranges, files won't download. Lower range must be higher than upper range"
    else
        break
    fi  
}
#Check if file in range already exists in directory, ask user if they want to overwrite
filerange ()
{
    for number in `seq $lower $upper`;do
        file=$usrdir/DSC00$number.jpg
            if [[ -f $file ]];then
             read -p "DSC00$number already exists,do you wish to overwrite?(y/n): " over
                if [[ $over =~ ^([yY][eE][sS])$ ]];then
                   rm -r $file           
               fi 
            else
                echo "DSC00$number will be downloaded"
                break              
            fi
    done
}
#Strips filelist so only number exist. 
#Extracts the number of random images
#Checks if these images already exist in directory
valrandom ()
{
    sed -e 's/.jpg//g' \
        -e 's/DSC0//g' filelist.txt > random.txt 
          
    awk -v a=$lower -v b=$upper '$0 > a && $0 < b' random.txt | shuf -n $numimage -o morerandom.txt
    random=`cat "morerandom.txt"`

    for number in $random;do
      file=$usrdir/DSC0$number.jpg
        if [[ -f $file ]];then
        read -p "DSC0$number already exists,do you wish to overwrite?(y/n): " over
            if [[ $over =~ ^([yY][eE][sS])$ ]];then
               rm -r $file           
            fi 
        else         
            break              
        fi
    done 
}
#Check user directory to see if files of same name already exist
valall ()
{
    for number in $files;do
     file=$usrdir/$number
        if [[ -f $file ]];then 
         read -p "$number already exists,do you wish to overwrite?(y/n): " over
            if [[ $over =~ ^([yY][eE][sS])$ ]];then
                rm -r $file           
            fi 
        else
            echo "$number will be downloaded"
            break              
        fi
    done

}

#Create case loop to display menu options and ask reader their choice
PS3="Please enter an option: "
options=("Download a specific thumbnail" 
"Download images in range"
"Download a specific number of images in a given range"
"Download ALL thumbnails"
"Clean up ALL files"
"Exit Program")

select opt in "${options[@]}"
do
   
   case $opt in
        "Download a specific thumbnail")
        #If user chooses option one, ask them to enter a file number then call function to validate
          read -p "Please enter the last four digits of the image you wish to download: " digits           
              validate $digits

          #Ask user for directory name and call function 
          read -p "Enter directory: " usrdir         
              valdir $usrdir

          #Call function to check that file exists
          searchfile $digits $usrdir

          #Download the file into the directory
          wget -P $usrdir "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0$digits.jpg"

          #If a file in the directory matches what was just downloaded, display its name and size in kb to two decimal places
          kb=KB 
          filesize=$(du -b $usrdir/DSC0$digits.jpg | awk '{adj=$1/1024; printf "%.2f\n", adj}')    
          echo "Downloading DCS0$digits, with the file name DSC0$digits.jpg, with a file size of $filesize$kb...File Download Complete"           
          
        ;;
       "Download images in range") 
       #Ask user for lower and upper ranges to search then call functions
          read -p "Please enter the last four digits of the start of the range: " lower
          vallower $lower
          read -p "Please enter the last four digits of the end of the range: " upper
          valupper $upper
         
          #Ask user for directory then call function
          read -p "Enter directory: " usrdir
              valdir $usrdir

          #Call functions to check for valid ranges
          filerange $lower $upper 
          valrange $lower $upper

          #Download the files in the given range to their choice of directory
           for number in `seq $lower $upper`;do        
                 wget -P  $usrdir "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC00$number.jpg"
           done
          
          #If a file in the directory matches what was just downloaded, display its name and size in kb to two decimal places
            post=/*
            filesize=0
            filetotal=0
            kb=KB
            echo "For the range DSC0$lower to DSC0$upper:"
            for number in `seq $lower $upper`;do
                file=$usrdir/DSC00$number.jpg
                if [[ -f $file ]];then
                 filesize=$(du -b $file | awk '{adj=$1/1024; printf "%.2f\n", adj}')
                 filename=$(basename $file)
                 filetotal=$(echo $filetotal $filesize | awk '{sum=$1+$2; printf "%.2f\n", sum}')
                 base=${filename//.jpg/}
                 echo "Downloading $base, with the file name $filename, with a file size of $filesize$kb...Download complete"
                fi
            done
            #Calculate the total size of all files just downloaded to two decimal places
            filetotal=$(echo $filetotal | awk '{conv=$1/1024; printf "%.2f\n", $conv}')
            echo "Total size of all files downloaded to $usrdir is $filetotal$kb"  
          
          ;;
       "Download a specific number of images in a given range")
        #Ask user for lower and upper range then call functions
          read -p "Please enter the last four digits of the start of the range: " lower
          vallower $lower
          read -p "Please enter the last four digits of the end of the range: " upper
          valupper $upper
          

          #Ask user for the number of images to download in given range then call function
          read -p "Please enter the number of images in this range you wish to download: " numimage
          valnumimage $numimage

          #Ask user what directory to store images in then call function
          read -p "Enter directory: " usrdir
              valdir $usrdir

          #Call function to check if images already in directory    
          valrandom $lower $upper

          #Check if correct ranges given
          valrange $lower $upper
              
          #Download the number of random images within the given range to the users' directory
            for number in $random;do    
                 wget -P  $usrdir "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/DSC0$number.jpg"
            done

          #If a file in the directory matches what was just downloaded, display its name and size in kb to two decimal places
            post=/*
            filesize=0
            filetotal=0
            kb=KB
            echo "For the range DSC0$lower to DSC0$upper, $numimage random images were selected:"
            for number in $random;do
               file=$usrdir/DSC0$number.jpg
               if [[ -f $file ]];then     
                   filesize=$(du -b $file | awk '{adj=$1/1024; printf "%.2f\n", adj}')
                   filename=$(basename $file)
                   filetotal=$(echo $filetotal $filesize | awk '{sum=$1+$2; printf "%.2f\n", sum}')
                   base=${filename//.jpg/}
                   echo "Downloading $base, with the file name $filename, with a file size of $filesize$kb...Download complete"
               else
                    break
               fi
            done
            #Calculate the total size of all files just downloaded to two decimal places
            filetotal=$(echo $filetotal | awk '{conv=$1/1024; printf "%.2f\n", $conv}')
            echo "Total size of all files downloaded to $usrdir is $filetotal$kb" 

          ;;
        "Download ALL thumbnails")
          #Ask user for directory name then call function
          read -p "Enter directory: " usrdir
              valdir $usrdir
          #Call function to check existence of files in directory
          valall $files
            #Download all images from website into users' directory
            cat filelist.txt | while read line || [[ -n $line ]];
            do
                wget -P $usrdir "https://secure.ecu.edu.au/service-centres/MACSC/gallery/ml-2018-campus/$line"
            done

            #If a file in the directory matches what was just downloaded, display its name and size in kb to two decimal places
            post=/*
            filesize=0
            filetotal=0
            kb=KB
            for number in $files;do
              file=$usrdir/$number
               if [[ -f $file ]];then
                 filesize=$(du -b $file | awk '{adj=$1/1024; printf "%.2f\n", adj}')
                 filename=$(basename $file)
                 filetotal=$(echo $filetotal $filesize | awk '{sum=$1+$2; printf "%.2f\n", sum}')
                 base=${filename//.jpg/}
                 echo "Downloading $base, with the file name $filename, with a file size of $filesize$kb...Download complete"
                fi
            done
            #Calulate total size of all files just downloaded in kb to two decimal places
            filetotal=$(echo $filetotal | awk '{conv=$1/1024; printf "%.2f\n", $conv}')
            echo "Total size of all files downloaded to $usrdir is $filetotal$kb"

          ;;
        "Clean up ALL files")
        #Delete temp.txt and filelist.txt
           rm -r temp1.txt
           rm -r filelist.txt
        #If user selected option 3 earlier, delete files produced
          if [[ -f random.txt ]] && [[ -f morerandom.txt ]];then
               rm -r random.txt
               rm -r morerandom.txt
          fi
        #Ask user for directory they created earlier, if it exists, delete it 
           read -p "Name of directory to delete: " deldir
           if ! [[ -d $deldir ]];then
               echo "Directory doesn't exist"   
           else
             rm -r $deldir
           fi 
          echo "Clean up complete"

          ;;
        "Exit Program")
          #Exit program
          echo "Exiting Program"
          break
          ;;
          #If user enters invalid input, ask them to try again
        *) echo "Invalid input, please try again";;   
    
    esac
done
