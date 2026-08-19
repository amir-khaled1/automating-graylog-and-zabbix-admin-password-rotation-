#!/bin/bash 
filename="/home/amir/config/graylog/server/server.conf"
password_to_hash="amir_khaled8"
hashed_password=$( echo -n "$password_to_hash" | sha256sum | tr -d " -")
# stop the graylog server and elastic search 
sleep 2
echo "the graylog and the elastic search are down" 
if [ -e "$filename" ]; then 
	echo "the file exist "
	current_sha256_pwd=$(grep "root_password_sha2" "$filename")
	echo "current $current_sha256_pwd"
	echo "it will be changed to $hashed_password"
	sed -i "s/.*root_password_sha2.*/root_password_sha2 = $hashed_password/" "$filename"
	echo "success in changing the password"
else
	echo "file not found"
fi	
# return the graylog server and elastic serach 
sleep 2
echo "the graylog and the elastic search are up "
