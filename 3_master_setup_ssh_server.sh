#setup ssh server
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

