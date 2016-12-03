#!/bin/bash
#
#	Replace the crowdhound server's endpoint
#
BACKUP_SUFFIX=".original"


if [ -z "$1" ] ; then
	echo
	echo "usage: $0 <new-endpoint>    (Use a new Crowdhound server)"
	echo "       $0 -r                (Return to the original server)"
	echo ""
	exit 1
fi

if [ "$1" = "-r" ] ; then
	# Resuming the original endpoint
	echo "Warning: this will overwrite any changes to the files."
	echo -n "Is this okay (y/N)? "
	read ans
	#echo ${ans}
	#echo ${ans} | grep '^[yY]'
	#echo $?
	if echo ${ans} | grep '^[yY]' ; then
		echo ""
		echo Restoring files
		for n in *${BACKUP_SUFFIX} ; do
			if [ "$n" = "*${BACKUP_SUFFIX}" ] ; then
				echo "No changes found to restore."
				exit 1
			fi
			newname=$(echo $n | sed "s/${BACKUP_SUFFIX}$//")
			echo "${n} -> ${newname}"
			mv "${n}" "${newname}"

		done
		exit 0
	else
		echo ""
		echo "Aborting, no files changed."
		exit 1
	fi
fi

FROM=zjjzjjzjjj
FROM=trial.crowdhound.io
FROM=crowdhound-examples:4521
#TO=auf.crowdhound.io
#FROM=auf.crowdhound.io
#TO=zjjzjjzjjj
#TO=crowdhound-examples:4521
TO=$1
BACKUP_OPT="-i${BACKUP_SUFFIX}"

ME=$(basename $0)

for file in $(grep -lr "${FROM}" .) ; do
	if  echo ${file} | grep "${BACKUP_SUFFIX}" > /dev/null; then
		# This is a backup
		echo " - ignore ${file}"
	elif  echo ${file} | grep "${ME}" > /dev/null; then
		# This script
		echo " - ignore me ${file}"
	else
		# Needs to be converted
		echo "Convert ${file}"
		sed -i "${BACKUP_SUFFIX}" "s/${FROM}/${TO}/" $file
	fi
done


