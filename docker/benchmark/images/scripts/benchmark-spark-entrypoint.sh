#!/bin/bash

SQL_RESULT=""
while [[ "${SQL_RESULT}" != 1 ]]
do
	echo "Wait for table initialization to complete..."
	sleep 1
	SQL_RESULT=$(mysql -h mysql -P 3306 --database=metastore \
	  --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" \
	  --execute="select VER_ID from VERSION;" \
	  -s -N)
done
echo "MySQL initialization is successful, starting Spark Thrift Server..."

sbin/start-thriftserver.sh