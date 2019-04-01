#!/bin/bash

NO_DEFAULT=0

if [[ -n "${MONGODB_HOST}" ]]; then
	echo "Initialising MongoDB with ids and data" 2>&1
	echo "MongoDB host: [ ${MONGODB_HOST} ]" 2>&1
  echo "Opal host: [ ${OPAL_HOST} ]" 2>&1
	echo "{\"name\": \"_identifiers\", \"defaultStorage\":false, \"usage\": \"STORAGE\", \"usedForIdentifiers\":true, \"mongoDbSettings\" : {\"url\":\"mongodb://${MONGODB_HOST}:27017/opal_ids\"}}" | opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --content-type 'application/json' -m POST /system/databases
	echo "{\"name\":\"opal_data\",\"defaultStorage\":true, \"usage\": \"STORAGE\", \"mongoDbSettings\" : {\"url\":\"mongodb://${MONGODB_HOST}:27017/opal_data\"}}" | opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --content-type 'application/json' -m POST /system/databases
fi

echo "Custom database setup" 2>&1
if [[ ${NO_DEFAULT} -eq 1 && -n "${MONGO_PORT_27017_TCP_ADDR}" ]]
	then
	echo "Initializing Opal databases with MongoDB" 2>&1
	if [ -z "${MYSQLIDS_PORT_3306_TCP_ADDR}" ]; then
		sed s/@mongo_host@/$MONGO_PORT_27017_TCP_ADDR/g /opt/opal/config/mongodb-ids.json | \
    		sed s/@mongo_port@/$MONGO_PORT_27017_TCP_PORT/g | \
    		opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST /system/databases --content-type "application/json"
  fi
	sed s/@mongo_host@/${MONGO_PORT_27017_TCP_ADDR}/g /opt/opal/config/mongodb-data.json | \
    	sed s/@mongo_port@/${MONGO_PORT_27017_TCP_PORT}/g | \
    	opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST /system/databases --content-type "application/json"
fi