#!/bin/bash 
user="amir"
host="192.168.90.137"
sshpass -f myPassword ssh "$user@$host" 'bash -s' < local_script.sh 
