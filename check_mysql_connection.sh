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

mysql --defaults-file=/root/.my.cnf -e 'select count(id) from information_schema.processlist;' > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Critical, too many connections on mysql."
    exit 2
fi

current=$(mysql --defaults-file=/root/.my.cnf -e 'select count(id) from information_schema.processlist;'| grep [0-9])
if [ $current -ge $crit ]; then
    echo "Critical! Current connections on mysql: $current"
    exit 2
elif [ $current -ge $warn ]; then
    echo "Warning! Current connections on mysql: $current"
    exit 1
else
    echo "OK, Current connections on mysql: $current"
    exit 0
fi

