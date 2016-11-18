#/bin/bash

str1="export JAVA_HOME=\${JAVA_HOME}"
str2="export JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre"
#should be added after hadoop copy from MASTER!
sed "s;${str1};${str2};" /usr/local/hadoop/etc/hadoop/hadoop-env.sh > /usr/local/hadoop/etc/hadoop/hadoop-env.sh.tmp; mv /usr/local/hadoop/etc/hadoop/hadoop-env.sh.tmp /usr/local/hadoop/etc/hadoop/hadoop-env.sh


