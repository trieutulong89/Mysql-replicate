#!/bin/bash
#Description:
if [[ -z "$1" ]];then
	echo "Usage: $0 <path-to-file>"
	exit 2
fi
FILE_NAME=$1
if [[ ! -f $FILE_NAME ]];then
	echo "Crit!File is not exists"
	exit 2
fi
CONTENT=$(cat $FILE_NAME)
if [[ -z $CONTENT ]];then
	echo "Crit!File is empty"
	exit 2
fi
REGEX="^[0-9]*$"
if [[ $CONTENT =~ $REGEX ]];then
	kill -0 $CONTENT > /dev/null 2>&1
	if [[ $? -eq 0 ]];then
		echo "Ok!Process in file is running.Value: $CONTENT"
		exit 0
	else
		echo "Crit!Process in file not running.Current Value: $CONTENT"
		exit 2
	fi
else
	echo "Crit!Value in file is not valid"
	exit 2
fi
