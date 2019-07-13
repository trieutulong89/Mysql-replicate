#!/bin/bash
#####################################
USER=$(sed '2q;d' /etc/.my.cnf |grep user |awk {'print $3'})
PASS=$(sed '3q;d' /etc/.my.cnf |grep password |awk {'print $3'})
#### List user,time,state, info ######################

TIME=$(mysql -u $USER -p$PASS -e "SELECT time FROM information_schema.processlist where state like 'Waiting for table%' order by time desc limit 1;"|sed '2q;d')

INFO=$(mysql -u $USER -p$PASS -e "SELECT info FROM information_schema.processlist where state like 'Waiting for table%' order by time desc limit 1;"|sed '2q;d')

WHO=$(mysql -u $USER -p$PASS -e "SELECT user FROM information_schema.processlist where state like 'Waiting for table%' order by time desc limit 1;"|sed '2q;d')

if [ "$TIME" -ge 200  ];then
 echo "Critical! ${WHO} taken ${TIME}s for query: ${INFO:0:50}..."
 exit 2
elif [ "$TIME" -ge 100 ] && [ "TIME" -lt 200 ];then
 echo "Warning! ${WHO} taken ${TIME}s for query: ${INFO:0:50}..." 
 exit 1
else
 echo "Ok-Query is Normal"
 exit 0
fi
