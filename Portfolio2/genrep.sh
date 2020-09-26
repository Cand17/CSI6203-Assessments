#!/bin/bash

#Candice Shepherd 10024859

#Create variables containing characters in attacks.html we want to eliminate
pre="<td><td>"
post="<\/td><tr>"
mid="<\/td><td>"
ext="<tr><td>"


cat attacks.html | grep "<td>" | sed -e "s/^$pre//g; s/$ext//g; s/$post$//g; s/$mid/ /g" | awk  ' BEGIN {print "Attacks          Instances(Q3)"} {total=($2+$3+$4); printf $1 "%17d\n", total}'

exit 0