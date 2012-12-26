#!/bin/bash
# Signus
# User-Password Hash Comparison Tool v1.0
# Simple utility that allows for the comparison between a file with a 'user:hash' format to a separate file with a 'hash:password' format. The comparison matches the hashes and returns an output file in the format 'user:password'

# Example of 'user:hash' -> george:c21cfaebe1d69ac9e2e4e1e2dc383bac
# Example of 'hash:password' -> c21cfaebe1d69ac9e2e4e1e2dc383bac:password
# 'user:hash' obtained from creddump suite: http://code.google.com/p/creddump/
# Note: Used custom 'dshashes.py' file: http://ptscripts.googlecode.com/svn/trunk/dshashes.py
# 'hash:password' obtained from ocl-Hashcat output

usage="Usage: $0 [-i user:hash input] [-t hash:password input] [-o output]"

declare -a a1
declare -a a2
declare -A o

index1=0
index2=0
countA1=0
countA2=0
matchCount=0

if [ -z "$*" ]; then
  echo $usage
	exit 1
fi

if [ $# -ne 6 ]; then
	echo "Error: Invalid number of arguments."
	echo $usage
	exit 1
fi

echo -e
echo "---Checking Files---"
while getopts ":i:t:o:" option; do
	case $option in
		i) inputFile1="$OPTARG"
		if [ ! -f $inputFile1 ]; then
			echo "Unable to find or open file: $inputFile1"
			exit 1
		fi
		echo "Reading...$inputFile1"
		;;
		t) inputFile2="$OPTARG"
		if [ ! -f $inputFile2 ]; then
			echo "Unable to find or open file: $inputFile2"
			exit 1
		fi
		echo "Reading...$inputFile2"
		;;
		o) outputFile="$OPTARG"
		echo "Writing...$outputFile"
		;;
		[?]) echo $usage >&2
			exit 1
		;;
	esac
done
shift $(($OPTIND-1))


#First read the files and cut each line into an array
echo -e
echo "---Reading Files---"
while read LINE
do
	a1[$index1]="$LINE"
	index1=$(($index1+1))
	countA1=$(($countA1+1))
done < $inputFile1
echo "Read $countA1 lines in $inputFile1"

while read LINE
do
	a2[$index2]="$LINE"
	index2=$(($index2+1))
	countA2=$(($countA2+1))
done < $inputFile2
echo "Read $countA2 lines in $inputFile2"


#Then cut each item out of the array and store it into separate variables
echo -e
echo "Searching for Matches..."
for (( j=0; j<${#a2[@]}; j++ ))
do
	hash2=$(echo ${a2[$j]} | cut -d: -f1)
	pword=$(echo ${a2[$j]} | cut -d: -f2)

	for (( i=0; i<${#a1[@]}; i++ ))
	do
		us=$(echo ${a1[$i]} | cut -d: -f1)
		hash1=$(echo ${a1[$i]} | cut -d: -f2)

		if [ "$hash2" = "$hash1" ]; then
			matchCount=$(($matchCount+1))
			o["$us"]=$pword
			echo -e "Match Found[$matchCount]: \t Username:$us  \t  Password:$pword" 
			break
		fi
	
	done
done

echo -e "Matches Found: $matchCount\n" >> $outputFile
for k in ${!o[@]}
do
	echo -e "Username: $k  \t  Password: ${o[$k]}" >> $outputFile
done
echo -e "\nWrote $matchCount lines to $outputFile"

unset o
