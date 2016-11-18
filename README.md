# Hadoop
Hadoop multinode installation bash script

#felan Hadoop install asli bashe...

Step By Step installation guide:

go in this order and do NOT close any of master or slave terminals,

1- run java_install script for master.
2- run master_add_hostname.
3- run master_setup_ssh_server.
4- run master_configs.
4.1- copy master's public key from ~/.ssh/id_rsa.pub
5- run java_install for all slaves.
6- run slave_add_hostname for all slaves.
7- run slave_setup_ssh for all slaves.
8- run master_copy_hadoop_to_slaves.
...
