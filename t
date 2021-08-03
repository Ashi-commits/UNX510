# Assignment 3
# Course:                UNX510
# Family Name:           Sahu
# Given Name:            Ayushi
# Student Number:        143-789-188
# Login name:            asahu
# Professor:             Shahdad Shariatmadari
# Due Date:              August 2, 2021
#
# I declare that the attached assignment is my own work in accordance with
# Seneca Academic Policy.  No part of this assignment has been copied manually
# or electronically from any other source (including web sites) or distributed
# to other students.
##############################################################################


#!/bin/bash
trap 'stty icanon echo; rm /tmp/pathdisplay.temp.$$; tput cup $lineNum 0; exit 0' INT

case $# in
	0) dir=. ;;
	1) dir=$1 ;;
	*) echo "Usage: perm [ dir-name ]" >&2
	exit 1 ;;
esac

if [ ! -d $dir ]
then
	echo "$1 is not a valid directory name" >&2
	exit 1
fi
#creating an array of reliable absolute path using sed, pipe, awk and realpath commands
directories=$(realpath $dir | sed -r 's/\//& \n/g' | awk '{$1=$1} {FS="/"; OFS=""} {print "/"$1}' | sed 's/\/\//\//')

x=""
for dir in $directories
do
    x=$x$dir
    ls -dl $dir | head -2 | tail -1  >> /tmp/pathdisplay.temp.$$
done

total_lines=$(cat /tmp/pathdisplay.temp.$$ | wc -l) #total number of lines in temporary file
cur_Line =1 
filecolumn=24 #total number of columns
cursor=$(($total_lines*2+1)) # multiply cursor position to be double the lines and add 1 (because there are new lines between each row)
position=$(($total_lines*2+1)) # setting a variable to track position of cursor
temp=$(($total_lines*2+2)) #setting up a variable to display data in position
col=`tput cols` #create variable command

while true
do
	path_func(){
	then clear
    echo "Owner   Group   Other   Filename"
    echo "-----   -----   -----   --------"
    printf "\n"
    if [ echo $(ls -ld $x) | grep -qs "^d........-" ]
    then
    tput smso
    sed -n "$ cur_Line, $total_lines p" /tmp/pathdisplay.temp.$$ |
    while read line
    do
   
    (echo -n $line | cut -c2- | awk '{print $1,$9}' | sed 's/./& /1' |sed 's/./& /3' | sed 's/./&   /5' \
    | sed 's/./& /9' | sed 's/./& /11' | sed 's/./&   /13' | sed 's/./& /17' | sed 's/./& /19' | \
    sed 's/./&  /21' | sed 's/\/.*\///' | sed 's/[.][ ][/]/ \//') | cut -c -$col 

        printf "\n"

    done
    tput rmso
    else
    sed -n "$ cur_Line, $total_lines p" /tmp/pathdisplay.temp.$$ |
    while read line
    do
   
    (echo -n $line | cut -c2- | awk '{print $1,$9}' | sed 's/./& /1' |sed 's/./& /3' | sed 's/./&   /5' \
    | sed 's/./& /9' | sed 's/./& /11' | sed 's/./&   /13' | sed 's/./& /17' | sed 's/./& /19' | \
    sed 's/./&  /21' | sed 's/\/.*\///' | sed 's/[.][ ][/]/ \//') | cut -c -$col 

        printf "\n"

    done
    fi
    
    if [ $cursor -eq $position ]
    then
        tput cup $y 0 # here we put the line at one below the current cursor position
details=$(sed -n "$(($position/2)) p" /tmp/pathdisplay.temp.$$)
links=$(echo  $details | sed -n "$ details p" | awk '{print $2}')
owner=$(echo  $details | sed -n "$ details p" | awk '{print $3}')
group=$(echo  $details | sed -n "$ details p" | awk '{print $4}')
size=$(echo  $details | sed -n "$ details p" | awk '{print $5}')
modified=$(echo  $details | sed -n "$ details p" | awk '{print $6, $7, $8}')
 echo -n "  Links: "$links"   Owner: "$owner"  Group: "$group"  Size: "$size"  \nModified: "$modified ""
   fi
   
	linesNum=`tput linesNum`
	tput cup $(($linesNum-4)) 0
    	printf "Valid keys: k (up), j (down): move between filenames \n"
     	printf "            h (left), l (right): move between permissions \n"
        	printf "            r, w, x, -: change permissions;   q: quit"
    }// path_func() ends here
   fi

    command=$(dd bs=3 count=1 2> /dev/null)
    case $command in
        j) if [ $cursor -lt 25 -a $((cur_Line + cursor)) -lt $(($cur_Line* 2 + 2)) ]
                       then cursor=$((cursor + 2))
                           position=$((position+2))
                           temp=$(($temp+2))
			  path_func
		   fi ;; 
       k) if [ $cursor -gt 3 ]
                       then cursor=$((cursor - 2))
                        position=$((position - 2))
                        temp=$(($temp-2))
			path_func
                       fi;;
       h) if [ $filecolumn -gt 0 ]
          then
		  if [ $filecolumn -eq 24 ] || [ $filecolumn -eq 16 ] || [ $filecolumn -eq 8 ] #checking if the cursor position is at edge with more than 2 white space then
                          then filecolumn=$(($filecolumn - 4))
          else  
                   filecolumn=$(($filecolumn - 2))

           fi
   fi;;
 
       l) if [ $filecolumn -lt 24 ]
       then
	       if [ $filecolumn -eq 4 ] || [ $filecolumn -eq 12 ] || [ $filecolumn -eq 20 ] #checking if the cursor position is at edge with more than 2 white space then
	       then filecolumn=$(($filecolumn + 4))
	   else
		   filecolumn=$(($filecolumn + 2))
	   fi
   fi ;;

   q)rm /tmp/pathdisplay.temp.$$ #if q pressed reset the screen and exit 
           stty icanon echo
           tput cup $0
           exit 0 ;;
   *)  ;; #default nothing happens
   esac
done
