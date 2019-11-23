#!/usr/bin/env bash
#Link01

set -o errexit -o pipefail -o noclobber -o nounset

DICTIONARY="/usr/share/dict/american-english"

STRONG=false
WORDS=3
NUMBER=1
FILE=""

while getopts "sw:n:" opt; do
	case ${opt} in
		s)
			STRONG=true
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

#Link02
#Clear all processed options leaving filename if any
shift $((OPTIND-1))

if [[ $# = 1 ]] ; then
	FILE=$1
fi

DICTLNS=$(wc -l $DICTIONARY | awk '{print $1}')

for ((n=1; n <= $NUMBER; n++)); do
	PASSWORD=""
	for ((i=1; i <= $WORDS; i++)); do
		WORD="$(sed -n "$(shuf -i 1-$DICTLNS -n 1)p" $DICTIONARY)"
		PASSWORD=$PASSWORD$WORD
	done
	#Link03
	PASSWORD="${PASSWORD//\'}"
	
	if [[ $STRONG = true ]] ; then
		REPVOWELS=(a e i o u)
	else
		VOWELS="aeiou"
		REPVOWELS=""
		for i in {1..2}; do
			#Link04
			REPVOWELS="$REPVOWELS""${VOWELS:$(( RANDOM % ${#VOWELS} )):1}"
		done
		#Link05
		REPVOWELS=($(echo "$REPVOWELS" | grep -o .))
	fi

	for VOW in ${REPVOWELS[*]} ; do
		#Link06
		CH=$(head /dev/urandom | tr -dc '0-9!"#$%&()*+,-.=?@[\]^_`{|}~' | head -c 1)
		PASSWORD=${PASSWORD//$VOW/$CH}
	done

	if [[ ! $FILE = "" ]] ; then
		$(echo "$PASSWORD" >> "$FILE")
	else
		echo $PASSWORD
	fi
done

exit 0;

#Sample Code References
#
#Link01 : https://learnxinyminutes.com/docs/bash/
#Link02 : https://unix.stackexchange.com/questions/214141/explain-the-shell-command-shift-optind-1/214151
#Link03 : https://unix.stackexchange.com/questions/104881/remove-particular-characters-from-a-variable-using-bash
#Link04 : https://stackoverflow.com/questions/48837407/how-would-i-pick-a-random-character-from-a-string-array-with-bash
#Link05 : https://stackoverflow.com/questions/7578930/bash-split-string-into-character-array
#Link06 : https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
