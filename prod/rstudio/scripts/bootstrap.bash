#!/bin/bash

USER_ARRAY=()

echo "[init-add-user] initialise adding users to passwd"
if [ -z "${USERS}" ]; then
  echo "[add-user] no users specified"
else
  USER_ARRAY=(${USERS})
fi

for USER in "${USER_ARRAY[@]}"
do
    echo "[add-user] adding user ${USER}"
    useradd -m -p $(perl -e 'print crypt($ARGV[0], "password")' ${USER}) ${USER}   
done

/init