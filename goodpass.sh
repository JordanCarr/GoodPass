#!/usr/bin/env bash

set -o errexit -o pipefail -o noclobber -o nounset

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
			$STRONG=true
			shift $((OPTIND-1))
			;;
		w)
			$WORDS=$OPTARG
			;;
		n)	
			$NUMBER=$OPTARG
			;;
		\? )
			echo "Invalid option: $OPTARG" 1>&2
			exit 1
			;;
	esac
done

echo $STRONG
echo $WORDS
echo $NUMBER
echo $FILE
exit 0;
