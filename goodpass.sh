#!/usr/bin/env bash

set -o errexit -o pipefail -o noclobber -o nounset

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

echo "Strong is $STRONG"
echo "Words is $WORDS"
echo "Number is $NUMBER"
echo "File is $FILE"
exit 0;
