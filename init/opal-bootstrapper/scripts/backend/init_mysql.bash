#!/bin/bash

if [ ${MYSQL_ENABLED} -eq "true" && -n "${MYSQLIDS_PORT_3306_TCP_ADDR}" ]; then
	echo "Initializing Opal IDs database with MySQL" 2>&1
	echo "MySQL host: [ ${MYSQL_HOST} ]" 2>&1
  echo "Opal host: [ ${OPAL_HOST} ]" 2>&1

	MID_DB="opal"
	if [ -n "${MYSQLIDS_DATABASE}" ]; then
		MID_DB=${MYSQLIDS_DATABASE}
	fi

	MID_USER="root"
	if [ -n "${MYSQLIDS_USER}" ]; then
		MID_USER=${MYSQLIDS_USER}
	fi

	sed s/@mysql_host@/${MYSQLIDS_PORT_3306_TCP_ADDR}/g /opt/opal/config/mysqldb-ids.json | \
    	sed s/@mysql_port@/${MYSQLIDS_PORT_3306_TCP_PORT}/g | \
    	sed s/@mysql_db@/${MID_DB}/g | \
    	sed s/@mysql_user@/${MID_USER}/g | \
    	sed s/@mysql_pwd@/${MYSQLIDS_PASSWORD}/g | \
    	opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST /system/databases --content-type "application/json"
fi

if [ -n "$MYSQLDATA_PORT_3306_TCP_ADDR" ]; then
	echo "Initializing Opal data database with MySQL..."

	MD_DB="opal"
	if [ -n "$MYSQLDATA_PORT_3306_TCP_ADDR" ]; then
		MD_DB=$MYSQLDATA_PORT_3306_TCP_ADDR
	fi

	MD_USER="root"
	if [ -n "${MYSQLDATA_USER}" ]; then
		MD_USER=${MYSQLDATA_USER}
	fi

	MD_DEFAULT="false"
	if [ -z "${MONGO_PORT_27017_TCP_ADDR}" ]; then
		MD_DEFAULT="true"
	fi

	sed s/@mysql_host@/${MYSQLDATA_PORT_3306_TCP_ADDR}/g /opt/opal/config/mysqldb-data.json | \
    	sed s/@mysql_port@/${MYSQLDATA_PORT_3306_TCP_PORT}/g | \
    	sed s/@mysql_db@/$MD_DB/g | \
    	sed s/@mysql_user@/$MD_USER/g | \
    	sed s/@mysql_pwd@/$MYSQLDATA_PASSWORD/g | \
    	sed s/@mysql_default@/$MD_DEFAULT/g | \
    	opal rest -o http://${OPAL_HOST}:8080 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /system/databases --content-type "application/json"
fi