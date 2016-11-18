echo "Copy and paste Master's public key in here:"
read word1 word2 word3
MasterPublicKey="${word1} ${word2} ${word3}"
echo $MasterPublicKey >> ~/.ssh/authorized_keys
mkdir -p /usr/local/hadoop_work/hdfs/datanode
mkdir -p /usr/local/hadoop_work/yarn/local
mkdir -p /usr/local/hadoop_work/yarn/log
