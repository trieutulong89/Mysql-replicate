#!/bin/bash
#Description: Check mysql connection

set -e #stop execution if a variable is no set

usage() {
  echo "Scripts check current connections on mysql:"
  echo "Usage: $0 -w number -c number"
}

if [[ -z "$1" ]]; then
    usage
    exit 
fi

while getopts "w:c:" option;
do
  case "${option}" in
  w) 
    warning=${OPTARG}
    ;;
  c) 
    critical=${OPTARG}
    ;;
  \?)
    usage
    exit
    ;;
  esac
done

#Check not number:
number='^[0-9]+$'
if ! [[ $2 =~ $number && $4 =~ $number ]] ; then
    echo "Invalid option: Not a number"; 
    usage
    exit
fi


warn=$2
crit=$4
user=thanhvan
process=$(ps -u $user | wc -l)

if [ $process -ge $crit ]; then
    echo "Critical! There are many process for user $user: $process"
    exit 2
elif [ $current -ge $warn ]; then
    echo "Warning! Warning process total for user $user: $process"
    exit 1
else
    echo "OK, Number process for $user is OK: $process"
    exit 0
fi
