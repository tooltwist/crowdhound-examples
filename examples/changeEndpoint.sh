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

# Check the endpoints have no already been changed
FROM=training.crowdhound.io
TO=$1
ME=$(basename $0)

echo ""
echo "Checking for previous endpoint change"
if ls -l *${BACKUP_SUFFIX} ; then
	echo ""
	echo "Error: Endpoints have already been converted with this command."
	echo ""
	echo "You may wish to return to the original files by running:"
	echo ""
	echo "	$0 -r"
	echo ""
	echo "No files changed."
	exit 1
fi

# Make changes in the files, keeping a backup of each changed file.
echo ""
echo "No previous change. Proceeding..."
echo ""
for file in $(grep -lr "${FROM}" .) ; do
	if  echo ${file} | grep "${BACKUP_SUFFIX}" > /dev/null; then
		# This is a backup
		#echo " - ignore ${file}"
		true
	elif  echo ${file} | grep "${ME}" > /dev/null; then
		# This script
		#echo " - ignore me ${file}"
		true
	else
		# Needs to be converted
		echo "Convert ${file}"
		sed -i "${BACKUP_SUFFIX}" "s/${FROM}/${TO}/" $file
	fi
done

echo ""
echo "IMPORTANT"
echo "---------"
echo "The endpoints have now been changed. Please DO NOT commit"
echo "these changes to the example files back to github!"
echo ""
exit 0

