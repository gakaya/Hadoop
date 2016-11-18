#!/bin/bash

echo "master/slave?"
read TYPE
echo "hostname:"
read NAME
### install java
apt-get update
add-apt-repository ppa:webupd8team/java -y
apt-get update
apt-get install oracle-java7-installer -y
### add hostname
IP=$(hostname -I | awk '{print $1;}')

echo "" > /etc/hosts

if [[ $TYPE == 'master' ]]; then
	str=$(echo $IP $NAME)
	echo $str > /etc/hosts
fi

if [[ $TYPE == 'slave' ]]; then
	echo "how many data nodes?"
	read NUMBER
	for i in `seq 1 ${NUMBER}`;
	do
		if [[ $i == 1 ]]; then
			echo "enter master's IP and hostname seperated with space:"
		else
			echo "enter other slave's IPs and hostnames:"
		fi
		read IPs HostNames
		str=$(echo ${IPs} ${HostNames})
		echo $str >> /etc/hosts
		if [[ $i == 1 ]]; then
			str=$(echo $IP $NAME)
			echo $str >> /etc/hosts
		fi
	done
else
	echo "How many slaves?"
	read SlavesNumber
	for i in `seq 1 $SlavesNumber`;
	do
		echo "Enter Slave's IP and hostname:"
		read SlaveIP[i] SlaveHostName[i]
		str=$(echo ${SlaveIP[i]} ${SlaveHostName[i]})
		echo $str >> /etc/hosts
	done
fi

# sed "/127.0.0.1 localhost/a ${str}" /etc/hosts > /etc/hosts.bak; mv /etc/hosts.bak /etc/hosts
### setup SSH server
if [[ $TYPE == 'master' ]]; then
	apt-get install openssh-server -y
	ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa -N ""
	cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/authorized_keys
	ssh -o "StrictHostKeyChecking no" localhost
	### Download and install hadoop
	cd /usr/local/
	wget http://www.us.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
	tar -xzvf hadoop-2.7.3.tar.gz >> /dev/null
	mv hadoop-2.7.3 /usr/local/hadoop
	mkdir -p /usr/local/hadoop_work/hdfs/namenode
	mkdir -p /usr/local/hadoop_work/hdfs/namesecondary
else
	echo "Copy and paste Master's public key in here:"
	read word1 word2 word3
	MasterPublicKey="${word1} ${word2} ${word3}"
	echo $MasterPublicKey >> ~/.ssh/authorized_keys
	mkdir -p /usr/local/hadoop_work/hdfs/datanode
	mkdir -p /usr/local/hadoop_work/yarn/local
	mkdir -p /usr/local/hadoop_work/yarn/log

fi
### Set up environment variables
echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre" >> ~/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bashrc
echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export PATH=$PATH:${HADOOP_HOME}/bin" >> ~/.bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin" >> ~/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export YARN_HOME=$HADOOP_HOME" >> ~/.bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native" >> ~/.bashrc
echo "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_HOME/lib\"" >> ~/.bashrc
echo "export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:." >> ~/.bashrc
echo "export HADOOP_OPTS=\"$HADOOP_OPTS -Djava.security.egd=file:/dev/../dev/urandom\"" >> ~/.bashrc
JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre
HADOOP_HOME=/usr/local/hadoop
HADOOP_MAPRED_HOME=$HADOOP_HOME
HADOOP_COMMON_HOME=$HADOOP_HOME
YARN_HOME=$HADOOP_HOME
HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

source ~/.bashrc

str1="export JAVA_HOME=\${JAVA_HOME}"
str2="export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre"
#should be added after hadoop copy from MASTER!
sed "s;${str1};${str2};" /usr/local/hadoop/etc/hadoop/hadoop-env.sh > /usr/local/hadoop/etc/hadoop/hadoop-env.sh.tmp; mv /usr/local/hadoop/etc/hadoop/hadoop-env.sh.tmp /usr/local/hadoop/etc/hadoop/hadoop-env.sh


### Configuration:
## NameNode
if [[ $TYPE == 'master' ]]; then
	hadoop_core_xml_conf="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
	<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>
	<configuration>
	<property>
	<name>fs.defaultFS</name>
	<value>hdfs://NameNode:8020/</value>
	</property>
	<property>
	<name>io.file.buffer.size</name>
	<value>131072</value>
	</property>
	</configuration>"
	#touch $HADOOP_HOME/etc/hadoop/core-site.xml
	echo $hadoop_core_xml_conf > $HADOOP_HOME/etc/hadoop/core-site.xml
	## hdfs-site.xml
	hadoop_hsfs_site_xml="<?xml version=\"1.0\"?>
	<!-- hdfs-site.xml -->
	<configuration>
	<property>
	<name>dfs.namenode.name.dir</name>
	<value>file:/usr/local/hadoop_work/hdfs/namenode</value>
	</property>
	<property>
	<name>dfs.datanode.data.dir</name>
	<value>file:/usr/local/hadoop_work/hdfs/datanode</value>
	</property>
	<property>
	<name>dfs.namenode.checkpoint.dir</name>
	<value>file:/usr/local/hadoop_work/hdfs/namesecondary</value>
	</property>
	<property>
	<name>dfs.replication</name>
	<value>2</value>
	</property>
	<property>
	<name>dfs.block.size</name>
	<value>134217728</value>
	</property>
	</configuration>"
	#touch $HADOOP_HOME/etc/hadoop/hdfs-site.xml
	echo $hadoop_hsfs_site_xml > $HADOOP_HOME/etc/hadoop/hdfs-site.xml
	## mapred-site.xml
	cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml
	hadoop_mapred_site_xml="<?xml version=\"1.0\"?>
	<!-- mapred-site.xml -->
	<configuration>
	<property>
	<name>mapreduce.framework.name</name>
	<value>yarn</value>
	</property>
	<property>
	<name>mapreduce.jobhistory.address</name>
	<value>NameNode:10020</value>
	</property>
	<property>
	<name>mapreduce.jobhistory.webapp.address</name>
	<value>NameNode:19888</value>
	</property>
	<property>
	<name>yarn.app.mapreduce.am.staging-dir</name>
	<value>/user/app</value>
	</property>
	<property>
	<name>mapred.child.java.opts</name>
	<value>-Djava.security.egd=file:/dev/../dev/urandom</value>
	</property>
	</configuration>"
	echo $hadoop_mapred_site_xml > $HADOOP_HOME/etc/hadoop/mapred-site.xml
	## yarn-site.xml
	hadoop_yarn_site_xml="<?xml version=\"1.0\"?>
	<!-- yarn-site.xml -->
	<configuration>
	<property>
	<name>yarn.resourcemanager.hostname</name>
	<value>NameNode</value>
	</property>
	<property>
	<name>yarn.resourcemanager.bind-host</name>
	<value>0.0.0.0</value>
	</property>
	<property>
	<name>yarn.nodemanager.bind-host</name>
	<value>0.0.0.0</value>
	</property>
	<property>
	<name>yarn.nodemanager.aux-services</name>
	<value>mapreduce_shuffle</value>
	</property>
	<property>
	<name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
	<value>org.apache.hadoop.mapred.ShuffleHandler</value>
	</property>
	<property>
	<name>yarn.log-aggregation-enable</name>
	<value>true</value>
	</property>
	<property>
	<name>yarn.nodemanager.local-dirs</name>
	<value>file:/usr/local/hadoop_work/yarn/local</value>
	</property>
	<property>
	<name>yarn.nodemanager.log-dirs</name>
	<value>file:/usr/local/hadoop_work/yarn/log</value>
	</property>
	<property>
	<name>yarn.nodemanager.remote-app-log-dir</name>
	<value>hdfs://NameNode:8020/var/log/hadoop-yarn/apps</value>
	</property>
	</configuration>"
	echo $hadoop_yarn_site_xml > $HADOOP_HOME/etc/hadoop/yarn-site.xml
### Set up master
	touch $HADOOP_HOME/etc/hadoop/masters
	echo "${NAME}" > $HADOOP_HOME/etc/hadoop/masters
	
	for i in `seq 1 $SlavesNumber`; 
	do
		echo "i equals to $i"
		scp -r /usr/local/hadoop ${SlaveHostName[i]}:/usr/local
	done
	$HADOOP_HOME/bin/hadoop namenode -format
	echo "export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh
	echo "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_PREFIX/lib\"" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh
	echo "export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
	echo "export HADOOP_OPTS=\"-Djava.library.path=$HADOOP_PREFIX/lib\"" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
	#copy hadoop to datanodes

fi

