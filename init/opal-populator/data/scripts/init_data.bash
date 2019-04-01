#!/bin/bash

COHORT=
DATA_DICTIONARY_VERSION=
DATA_DICTIONARY_STATE=

OPAL_HOST=
OPAL_ADMINISTRATOR_PASSWORD=

function usage() {
  echo "*************************************************************************************"
  echo "* Usage                                                                             *"
  echo "*************************************************************************************"
  echo "* Please specify the Opal host and admin password you want to bootstrap             *"
  echo "* Specify Opal host name:                                                           *"
  echo "* + -o = [opal host] (only yhe dns name, without protocol and port number)          *"
  echo "* Specify password of Opal                                                          *"
  echo "* + -p = [password of opal host]                                                    *"
  echo "* Specify cohort name (lowercase)                                                   *"
  echo "* + -c = [cohort name] (lowercase for example 'gecko')                              *"
  echo "* Specify version of data dictionary                                                *"
  echo "* + -v = [version of data dictionary] (can be x_x, for example 1_0)                 *"
  echo "* Specify state of data dictionary (can be [ beta, released ])                      *"
  echo "* + -s = [state of data dictionary]                                                 *"
  echo "* For example:                                                                      *"
  echo "*   init_data \                                                                     *"
  echo "*   -o opal.gcc.rug.nl \                                                            *"
  echo "*   -p admin2019 \                                                                  *"
  echo "*   -v 1_0 \                                                                        *"
  echo "*   -v beta                                                                         *"
  echo "*************************************************************************************"
}
if [ $# -eq 0 ]; then
  usage
  exit 1
fi

while getopts :ho:p:c:v:s: opt; do
  case ${opt} in
    h) usage; exit
    ;;
    o) OPAL_HOST=${OPTARG}
    ;;
    p) OPAL_ADMINISTRATOR_PASSWORD=${OPTARG}
    ;;
    c) COHORT=${OPTARG}
    ;;
    v) DATA_DICTIONARY_VERSION=${OPTARG}
    ;;
    s) DATA_DICTIONARY_STATE=${OPTARG}
    ;;
    :) echo "Missing argument for option -${OPTARG}"; exit 1
    ;;
    \?) echo "Unknown option -${OPTARG}"; exit 1
    ;;
  esac
done

echo "########################################"

echo "Create project lifecycle_${COHORT}" 2>&1
echo "{\"name\":\"lifecycle_${COHORT}\",\"title\":\"lifecycle_${COHORT}\", \"database\": \"opal_data\"}" | opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --content-type 'application/json' -m POST /projects

echo "Create table ${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_monthly_repeated_measures" 2>&1
sed s/@table_name@/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_monthly_repeated_measurements/g /opt/opal/data/table_template.json | \
  opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST -ct 'application/json' /datasource/lifecycle_${COHORT}/tables
echo "Create table ${DATA_DICTIONARY_VERSION}_yearly_repeated_measures" 2>&1
sed s/@table_name@/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_yearly_repeated_measurements/g /opt/opal/data/table_template.json | \
  opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST -ct 'application/json' /datasource/lifecycle_${COHORT}/tables
echo "Create table ${DATA_DICTIONARY_VERSION}_non_repeated_measures" 2>&1
sed s/@table_name@/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_non_repeated_measurements/g /opt/opal/data/table_template.json | \
  opal rest -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -m POST -ct 'application/json' /datasource/lifecycle_${COHORT}/tables

echo "Upload variables for ${DATA_DICTIONARY_VERSION}_monthly_repeated_measures" 2>&1
opal file -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -up /opt/opal/data/dictionary/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_monthly_repeated_measurements.csv /home/administrator/
echo "Upload variables for ${DATA_DICTIONARY_VERSION}_yearly_repeated_measures" 2>&1
opal file -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -up /opt/opal/data/dictionary/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_yearly_repeated_measurements.csv /home/administrator/
echo "Upload variables for ${DATA_DICTIONARY_VERSION}_non_repeated_measures" 2>&1
opal file -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} -up /opt/opal/data/dictionary/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_non_repeated_measurements.csv /home/administrator/

echo "Import variables for ${DATA_DICTIONARY_VERSION}_monthly_repeated_measures" 2>&1
opal import-csv -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --path /home/administrator/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_monthly_repeated_measurements.csv --destination lifecycle_${COHORT} --tables ${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_monthly_repeated_measurements --separator , --type Participant
echo "Import variables for ${DATA_DICTIONARY_VERSION}_monthly_repeated_measures" 2>&1
opal import-csv -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --path /home/administrator/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_yearly_repeated_measurements.csv --destination lifecycle_${COHORT} --tables ${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_yearly_repeated_measurements --separator , --type Participant
echo "Import variables for ${DATA_DICTIONARY_VERSION}_monthly_repeated_measures" 2>&1
opal import-csv -o http://${OPAL_HOST}:8080 -u administrator -p ${OPAL_ADMINISTRATOR_PASSWORD} --path /home/administrator/${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_non_repeated_measurements.csv --destination lifecycle_${COHORT} --tables ${DATA_DICTIONARY_VERSION}_${DATA_DICTIONARY_STATE}_non_repeated_measurem --separator , --type Participant

echo "########################################"

