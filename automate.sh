#!/bin/bash 
set -a 
source .env
set +a
#N.B keep the same arguments order
#GRAYLOG
for i in ${GRAYLOG_SERVERS_IDS}
do 
 	server_ip="GRAYLOG_SERVER_IP_$i"
	rsiadmin_pwd="GRAYLOG_RSIADMIN_PWD_$i"
	root_pwd="GRAYLOG_ROOT_PWD_$i"
	#test if the properties exist 
	if [[ -z $server_ip || -z $rsiadmin_pwd || -z $root_pwd ]]; then 
		echo "there is a property missing in the graylog server number $i. Make sure to enter in the right formatting in the .env file." >> file.log
		echo "In case the server number $i does not exist, please remove his id from GRAYLOG_SERVERS_IDS in the .env file" >> file.log
		
		continue
	fi
	#generating the password to hash 
	_New_Password=$(head /dev/urandom | tr -dc 'A-Za-z0-9#@*!' | fold -w 15 | grep   '[A-Za-z]' | grep '[0-9]' | grep '[#@%*!]' | grep '^[^#@*!]' | head -n 1)	
	hashed_password=$(echo -n "$_New_Password" | sha256sum | tr -d " -")
	if [ $? -eq 0 ]; then 
		echo "updating the admin password of graylog server ${!server_ip}"
		./graylog.exp "$hashed_password" ${!server_ip} ${!rsiadmin_pwd} ${!root_pwd} ${GRAYLOG_CONFIG_FILE_PATH}
		exit_code="$?"
		if [ $exit_code -eq 0 ]; then 
			echo "=====> success"
			echo "the admin password to the graylog server ${!server_ip} is $_New_Password" >> file.log
		else 
			echo "=====> failed"
			echo -e "\n\e[31mexit code : $exit_code\e[0m" >> file.log
		fi
	else 
		echo "there was a problem in generating the password for the graylog server number $i by the ip: ${!server_ip}" >> file.log
	fi
done 
#ZABBIX
for i in ${ZABBIX_SERVERS_IDS}
do
	rsiadmin_pwd="ZABBIX_RSIADMIN_PWD_$i"
	root_pwd="ZABBIX_ROOT_PWD_$i"
	server_ip="ZABBIX_SERVER_IP_$i"
	mysql_root_pwd="ZABBIX_MYSQL_ROOT_PWD_$i"
	if [[ -z $rsiadmin_pwd || -z $root_pwd || -z $server_ip || -z $mysql_root_pwd  ]]; then 
		echo "there is a property missing in the zabbix server number $i. Make sure to enter in the right formatting in the .env file." >&2
		echo "In case the server number $i does not exist, please remove his id from ZABBIX_SERVERS_IDS in the .env file" >&2
		continue
	fi
	_New_Password=$(head /dev/urandom | tr -dc 'A-Za-z0-9#@*!' | fold -w 15 | grep   '[A-Za-z]' | grep '[0-9]' | grep '[#@%*!]' | grep '^[^#@*!]' | head -n 1)	
	encrypted_pwd=$(htpasswd -bnBC 10 "" "$_New_Password" | tr -d ':\n')
	if [ $? -eq 0 ]; then 
		echo "updating the Admin password of zabbix server ${!server_ip}"
		./zabbix.exp "$encrypted_pwd" ${!rsiadmin_pwd} ${!root_pwd} ${!mysql_root_pwd} ${!server_ip}
		exit_code="$?"
		if [ $exit_code -eq 0 ]; then 
			echo "=====> success"
			echo "the admin password to the graylog server ${!server_ip} is $_New_Password" >> file.log
		else 
			echo "=====> failed"
			echo -e "\n\e[31mexit code : $exit_code\e[0m" >> file.log
		fi
	else 
		echo "there was a problem in generating the password for zabbix server number $i by the ip: ${!server_ip}, or there was a problem with hashing the password" >> file.log
	fi
done
