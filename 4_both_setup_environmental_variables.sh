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

source ~/.bashrc

JAVA_HOME=/usr/lib/jvm/java-7-oracle/jre
HADOOP_HOME=/usr/local/hadoop
HADOOP_MAPRED_HOME=$HADOOP_HOME
HADOOP_COMMON_HOME=$HADOOP_HOME
YARN_HOME=$HADOOP_HOME
HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

