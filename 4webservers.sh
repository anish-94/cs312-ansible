#!/bin/bash
#TODO enter the four host IPs
host1=192.168.1.20
host2=192.168.1.27
host3=192.168.1.23
host4=192.168.1.25
#Here are our IPs of the machines we want to spin up webservers on
declare -a arr=($host1 $host2 $host3 $host4)

#make an rsa key
ssh-keygen -t rsa;


#share keys with the machines
for ip in "${arr[@]}"
do
	ssh-copy-id -i ~/.ssh/id_rsa root@"$ip"
done;

echo "[mynodes]" >> newhosts.ini;

for ip in "${arr[@]}"
do
	echo "$ip" >> newhosts.ini
done;

echo "
[mynodes:vars]
ansible_connection=ssh
ansible_port=22
ansible_user=root
ansible_python_interpreter=/usr/bin/python3
" >> newhosts.ini;


ansible mynodes -i ./newhosts.ini -b -m raw -a "apk -U add python3";


ansible-playbook ./webserver.yaml -i ./newhosts.ini;
