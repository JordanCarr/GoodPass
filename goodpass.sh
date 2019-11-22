#!/bin/bash

set -o errexit -o pipefail -o noclobber -o nounset

DICTIONARY="/usr/share/dict/american-english"

STRONG=false
WORDS=1
NUMBER=1

if [[ ${#} -eq 0 ]] ; then
	FILE=""
else
	FILE="${@: -1}"
fi

while getopts "s:w:n:" opt; do
	case ${opt} in
		s)
			STRONG=true
			shift $((OPTIND-1))
			;;
		w)
			WORDS=$OPTARG
			;;
		n)	
			NUMBER=$OPTARG
			;;
		\? )
			echo "Invalid option: $OPTARG" 1>&2
			exit 1
			;;
	esac
done

DICTLNS=$(wc -l $DICTIONARY | awk '{print $1}')

for n in $NUMBER; do
	PASSWORD=""
	for ((i=1; i <= $WORDS; i++)); do
		WORD="$(sed -n "$(shuf -i 1-$DICTLNS -n 1)p" $DICTIONARY)"
		PASSWORD=$PASSWORD$WORD
	done
	PASSWORD="${PASSWORD//\'}"
	echo $PASSWORD
done

# echo $DICTLNS
# echo $RAND

# echo $DICTLNS
# echo $MULT
# echo $STRONG
# echo $WORDS
# echo $NUMBER
# echo $FILE
exit 0;
