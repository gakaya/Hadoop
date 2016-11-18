echo "hostname:"
read NAME

echo "" > /etc/hosts

echo "how many data nodes?"
read NUMBER
for i in `seq 1 ${NUMBER}`;
do
	if [[ $i == 1 ]]; then
		echo "enter master's IP and hostname seperated with space:"
	else
		echo "enter other slave's IPs and hostnames in order seperated with space:"
	fi
	read IPs HostNames
	str=$(echo ${IPs} ${HostNames})
	echo $str >> /etc/hosts
	if [[ $i == 1 ]]; then
		str=$(echo $IP $NAME)
		echo $str >> /etc/hosts
	fi
done
