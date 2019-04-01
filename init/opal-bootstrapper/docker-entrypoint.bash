#!/bin/bash

DATA_DICTIONARY_STATE=beta

echo "General initialisation"
echo "-----------------------------"
echo "Initialise backend"
if [[ ${MONGODB_ENABLED} -eq "true" ]]; then
  echo "Setup MongoDB (opal_ids and opal_data)"
  bash /opt/opal/bin/init_mongodb.bash
elif [[ ${MYSQL_ENABLED} -eq "true" ]]; then
  echo "Setup MySQL (opal_ids and opal_data)"
  bash /opt/opal/bin/init_mysql.bash
fi

#echo "Initialise DataSHIELD packages"
#bash /opt/opal/bin/init_datashield.bash