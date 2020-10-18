#!/bin/bash

#Candice Shepherd 10024859

#Create variables containing characters in attacks.html we want to eliminate
pre="<td><td>"
post="<\/td><tr>"
mid="<\/td><td>"
ext="<tr><td>"

#Read the whole file and pipe into grep, extract all lines with "<td>"
#Use sed to eliminate all remaining HTML tage, pipe to awk
#Use awk to add the total of instances, add header, print attack and instances in two coloumns

cat attacks.html | grep "<td>" | sed -e "s/^$pre//g; s/$ext//g; s/$post$//g; s/$mid/ /g" | awk  ' BEGIN {print "Attacks          Instances(Q3)"} {total=($2+$3+$4); printf $1 "%17d\n", total}'

exit 0