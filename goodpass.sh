#!/usr/bin/env bash
#Link01

#Specified dictionary
DICTIONARY="/usr/share/dict/american-english"

STRONG=false
WORDS=3
NUMBER=1
FILE=""
UNDSCR=""

#Handle option arguments for strength, num of words, and num of passwords
while getopts "suw:n:" opt; do
	case ${opt} in
		s)
			STRONG=true
			;;
		u)
			UNDSCR=true
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

#If there is a remaining argument this will be interpreted as a filename to store the passwords
if [[ $# = 1 ]] ; then
	FILE=$1
fi

#Count how many words in dictionary file by line count
DICTLNS=$(wc -l $DICTIONARY | awk '{print $1}')

#Outer loop loops for each password to be generated
for ((n=1; n <= $NUMBER; n++)); do
	PASSWORD=""
	# Exctract random words from dictionary
	for ((i=1; i <= $WORDS; i++)); do
		WORD="$(sed -n "$(shuf -i 1-$DICTLNS -n 1)p" $DICTIONARY)"
		#Handle adding underscore between words or not
		if [[ ! -z $UNDSCR ]] && [[ $i > 1 ]] ; then
			PASSWORD=$PASSWORD"_"$WORD
		else
			PASSWORD=$PASSWORD$WORD
		fi
	done
	
	#Link03
	#Remove unnecessary puntuation in dictionary word
	PASSWORD="${PASSWORD//\'}"
	
	#Handle replace some or all vowels in password string
	if [[ $STRONG = true ]] ; then
		REPVOWELS=(a e i o u)
	else
		VOWELS="aeiou"
		REPVOWELS=""
		NUMREP=$((($RANDOM % 3) + 1))
		for (( i=1; i <= $NUMREP; i++)) ; do
			#Link04
			#Choose random vowel to be replaced
			REPVOWELS="$REPVOWELS""${VOWELS:$(( RANDOM % ${#VOWELS} )):1}"
		done
		#Link05
		#Break string into character array
		REPVOWELS=($(echo "$REPVOWELS" | grep -o .))
	fi

	for VOW in ${REPVOWELS[*]} ; do
		#Link06
		#Replace vowel with generally password compatible character or digit 
		CH=$(head /dev/urandom | tr -dc '0-9!"#$%&()*+,-.=?@[\]^`{|}~' | head -c 1)
		PASSWORD=${PASSWORD//$VOW/$CH}
	done

	#If a file was specified append password to file otherwise echo password
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
