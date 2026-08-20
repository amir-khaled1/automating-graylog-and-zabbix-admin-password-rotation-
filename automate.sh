#!/bin/bash 
set -a 
source .env
set +a
./graylog.exp ${GRAYLOG_PWD_TOHASH} ${GRAYLOG_ENTRY_USER} ${GRAYLOG_SERVER_IP} ${GRAYLOG_RSIADMIN_PWD} ${GRAYLOG_ROOT_PWD} ${GRAYLOG_CONFIG_FILE_PATH}
#TODO add the password to the myPassword databas 
# Mypassword –p admin@graylog


