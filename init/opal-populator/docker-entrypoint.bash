#!/bin/bash

DATA_DICTIONARY_STATE=beta

echo "Data population"
echo "-----------------------------"

echo "Initialise Project and Tables into Opal"
bash /opt/opal/bin/init_data.bash -o ${OPAL_HOST} -p ${OPAL_ADMINISTRATOR_PASSWORD} -c ${COHORT} -v ${DATA_DICTIONARY_VERSION} -s ${DATA_DICTIONARY_STATE}
