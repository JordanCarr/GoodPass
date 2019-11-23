#!/usr/bin/env bash
#Link01


set -o errexit -o pipefail -o noclobber -o nounset

DICTIONARY="/usr/share/dict/american-english"

STRONG=false
WORDS=3
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
	#Link02
	PASSWORD="${PASSWORD//\'}"
	
	if [[ $STRONG = true ]] ; then
		REPVOWELS=(a e i o u)
	else
		VOWELS="aeiou"
		REPVOWELS=""
		for i in {1..2}; do
			#Link03
			REPVOWELS="$REPVOWELS""${VOWELS:$(( RANDOM % ${#VOWELS} )):1}"
		done
		#Link04
		REPVOWELS=($(echo "$REPVOWELS" | grep -o .))
	fi

	for VOW in ${REPVOWELS[*]} ; do
		#Link05
		CH=$(head /dev/urandom | tr -dc '0-9!"#$%&()*+,-.=?@[\]^_`{|}~' | head -c 1)
		PASSWORD=${PASSWORD//$VOW/$CH}
	done
done

echo $PASSWORD

exit 0;

#Sample Code References
#
#https://learnxinyminutes.com/docs/bash/
#Link02 : https://unix.stackexchange.com/questions/104881/remove-particular-characters-from-a-variable-using-bash
#Link03 : https://stackoverflow.com/questions/48837407/how-would-i-pick-a-random-character-from-a-string-array-with-bash
#Link04 : https://stackoverflow.com/questions/7578930/bash-split-string-into-character-array
#Link05 : https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
