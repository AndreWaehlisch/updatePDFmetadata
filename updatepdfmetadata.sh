#!/bin/bash

meNAME="updatePDFmetadata"
me="-$meNAME: "
defaultdumpFILE="./meta.dump"
defaultoutFILE="./out.pdf"
theIFS=';'

sedSCRIPT () {
	if [[ $1 = *"$theIFS"* ]]; then
		IFS=$theIFS
		array=($1)
		unset IFS
		oldKEY="${array[0]}"
		newKEY="${array[1]}"
	else
		oldKEY="$1"
		newKEY="${@:2}"
		newKEY="$2"
	fi
	newKEY=$(echo "$newKEY" | recode ..xml)
	# sed cmd from: https://stackoverflow.com/a/18620241/5769953
	newKEY=$(sed -e 's/[\/&]/\\&/g' <<< $newKEY)
	echo ' -e '\''/InfoKey: '$oldKEY'/{n;s/\(InfoValue: \).*/\1'"$newKEY"'/}'\'
}

# getopt code from: https://stackoverflow.com/a/16483297/5769953
TEMP=`getopt -o hpda:t:s:c: --long print-pdfinfo,dont-clean,help,author:,title:,subject:,custom: -n "$meNAME" -- "$@"`
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"

while true ; do
	case "$1" in
		-a|--author) sedscriptSTRING+=$(sedSCRIPT Author "$2") ; shift 2 ;;
		-t|--title) sedscriptSTRING+=$(sedSCRIPT Title "$2") ; shift 2 ;;
		-s|--subject) sedscriptSTRING+=$(sedSCRIPT Subject "$2"); shift 2 ;;
		-c|--custom)
			if [[ $2 = *"$theIFS"* ]]; then
				sedscriptSTRING+=$(sedSCRIPT "$2");
				shift 2;
			else
				echo "When using the --custom flag you need to also use the separator (i.e. \"$theIFS\").";
				exit 1;
			fi;;
		-p|--print-pdfinfo) printpdfinfoFLAG=1 ; shift ;;
		-d|--dont-clean) dontcleanFLAG=1 ; shift ;;
		-h|--help) echo "Usage: $0 [--author <author>] [--title <title>] [--subject <subject>] [--custom \"<PDF key>;<value>\"] [--dont-clean] [--print-pdfinfo] <PDF input file> [<output FILE>] [<dump FILE>]" ; exit 0 ;;
		--) shift ; break ;;
		*) echo $me"Error handling options." ; exit 1 ;;
	esac
done

pdfFILE=$1
outFILE=$2
dumpFILE=$3

if [[ -z "$(which pdftk)" ]]; then
	echo $me"PDFTK not found."
	exit 2
fi

if [[ -z "$(which recode)" ]]; then
	echo $me"RECODE not found."
	exit 3
fi

if [[ -z "$pdfFILE" ]]; then
	echo $me"Need an input PDF file."
	exit 4
fi

if [[ -z "$sedscriptSTRING" ]]; then
	echo $me"Supply at least one flag you want to update. Use --help to see usage."
	exit 0
fi

if [[ -z "$dumpFILE" ]]; then
	echo "Using default dump file: "$defaultdumpFILE
	dumpFILE=$defaultdumpFILE
fi
dumpnewFILE="$dumpFILE.new"

if [[ -z "$outFILE" ]]; then
	echo "Using default output file: "$defaultoutFILE
	outFILE=$defaultoutFILE
fi

# do the actual conversion
pdftk "$pdfFILE" dump_data output "$dumpFILE"
eval sed "$sedscriptSTRING" "$dumpFILE" > "$dumpnewFILE"
pdftk "$pdfFILE" update_info "$dumpnewFILE" output "$outFILE"

# delete dump files
if [[ -z "$dontcleanFLAG" ]]; then rm -f "$dumpFILE" "$dumpnewFILE"; fi

# print PDF info
if [[ -n "$printpdfinfoFLAG" ]]; then pdfinfo "$outFILE"; fi
