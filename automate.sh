#!/bin/bash 
set -a 
source .env
set +a
#N.B keep the same arguments order
#GRAYLOG
for i in ${GRAYLOG_SERVERS_IDS}
do 
	#generating the password to hash 
	_New_Password=$(head /dev/urandom | tr -dc 'A-Za-z0-9#@*!' | fold -w 15 | grep   '[A-Za-z]' | grep '[0-9]' | grep '[#@%*!]' | grep '^[^#@*!]' | head -n 1)	
	
	pwd_to_hash="GRAYLOG_PWD_TOHASH_$i"
	server_ip="GRAYLOG_SERVER_IP_$i"
	rsiadmin_pwd="GRAYLOG_RSIADMIN_PWD_$i"
	root_pwd="GRAYLOG_ROOT_PWD_$i"
	./graylog.exp "$_New_Password" ${!server_ip} ${!rsiadmin_pwd} ${!root_pwd} ${GRAYLOG_CONFIG_FILE_PATH}
	#TODO add the password to the myPassword database
	# Mypassword –p admin@graylog
done 
#ZABBIX
for i in ${ZABBIX_SERVERS_IDS}
do
	_New_Password=$(head /dev/urandom | tr -dc 'A-Za-z0-9#@*!' | fold -w 15 | grep   '[A-Za-z]' | grep '[0-9]' | grep '[#@%*!]' | grep '^[^#@*!]' | head -n 1)	
	encrypted_pwd=$(htpasswd -bnBC 10 "" "$_New_Password" | tr -d ':\n')
	rsiadmin_pwd="ZABBIX_RSIADMIN_PWD_$i"
	root_pwd="ZABBIX_ROOT_PWD_$i"
	server_ip="ZABBIX_SERVER_IP_$i"
	mysql_root_pwd="ZABBIX_MYSQL_ROOT_PWD_$i"
	./zabbix.exp "$encrypted_pwd" ${!rsiadmin_pwd} ${!root_pwd} ${!mysql_root_pwd} ${!server_ip}
	#TODO add the password to my password database 
	#mypassword -s Admin@zabbix -app
done
