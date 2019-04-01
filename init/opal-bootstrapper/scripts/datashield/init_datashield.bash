#!/bin/bash

if [[ -n "${RSERVER_HOST}" ]]; then
	echo "Initializing Datashield" 2>&1
	echo "RServer host: [ ${RSERVER_HOST} ]" 2>&1
	echo "Opal host: [ ${OPAL_HOST} ]" 2>&1
	opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST /datashield/packages?name=datashield
fi