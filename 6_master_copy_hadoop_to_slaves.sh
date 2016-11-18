#!/bin/bash

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
	
