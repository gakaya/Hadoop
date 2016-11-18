echo "hostname:"
read NAME


### add hostname
IP=$(hostname -I | awk '{print $1;}')

echo "" > /etc/hosts

str=$(echo $IP $NAME)
echo $str > /etc/hosts

echo "How many slaves?"
read SlavesNumber

for i in `seq 1 $SlavesNumber`;
do
	echo "Enter Slave's IP and hostname seperated with space:"
	read SlaveIP[i] SlaveHostName[i]
	str=$(echo ${SlaveIP[i]} ${SlaveHostName[i]})
	echo $str >> /etc/hosts
done
