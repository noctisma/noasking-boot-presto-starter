#/bin/bash
export PRESTO_CONF="./conf/presto.conf"
dbuser=($(awk 'NR==5{print}' $PRESTO_CONF))
presto_version=($(awk 'NR==6{print}' $PRESTO_CONF))
dbpassword=$dbuser
dbhome=/home/$dbuser
jdk_package=jdk-8u131-linux-x64.tar.gz
presto_package=$presto_version.tar.gz
presto_name=$presto_version
presto_directory=/home/$dbuser/$presto_name
node_ip=""
node_memory=""
node_status=""
cur_meminfo=""
#echo $PRESTO_CONF
export presto_ip=($(awk 'NR==1{print}' $PRESTO_CONF))
export presto_info=($(awk 'NR==2{print}' $PRESTO_CONF))
export hive_metastore_uri=($(awk 'NR==3{print}' $PRESTO_CONF))
export presto_memory_percent=($(awk 'NR==4{print}' $PRESTO_CONF))
#default 50% percent
per_node_memory_percent=50
presto_manage_node=($(awk 'NR==2{print}' $PRESTO_CONF))
presto_max_memory=""
OLD_IFS="$IFS"
IFS="#"
arr="${presto_ip}"
echo $arr
#package copy
for i in ${arr[@]}
do
	echo "${i} create user "
	ssh root@${i} "useradd $dbuser"
        ssh root@${i} "echo $dbuser | /usr/bin/passwd --stdin $dbuser >/dev/null 2>&1"
        scp  prestorpms/$jdk_package ${i}:$dbhome
        scp  prestorpms/$presto_package ${i}:$dbhome
done
#package tar
for i in ${arr[@]}
do
	#ssh root@${i}
	echo "${i} unzip the file"
	ssh -T root@${i} <<-EOF
	su - $dbuser
	tar -zxf $dbhome/$presto_package
	tar -zxf $dbhome/$jdk_package
	exit
	EOF
done 
#jdk config
for i in ${arr[@]}
do
        #ssh root@${i}
	echo "${i} jdk config"
        ssh -T root@${i} <<-EOF
        su - $dbuser
        echo "export JAVA_HOME=$dbhome/jdk1.8.0_131" >> $dbhome/.bash_profile
        echo "export PATH="'\$'"JAVA_HOME/bin:"'\$'"PATH" >> $dbhome/.bash_profile
        echo "export CLASSPATH=.:"'\$'"JAVA_HOME/lib/dt.jar:"'\$'"JAVA_HOME/lib/tools.jar" >> $dbhome/.bash_profile
        echo "export PATH" >> $dbhome/.bash_profile
        source $dbhome/.bash_profile
        exit
	EOF
done
#presto configure pre
for i in ${arr[@]}
do
        #ssh root@${i}
        echo "${i} presto config pre"
	mm=`ssh root@${i} "cat /proc/meminfo |grep MemTotal ||awk '{print $2}'"`
        meminfo=`echo $mm | awk '{print $2}'`
        #ssh -T root@${i} <<-EOF
	#meminfo=`cat /proc/meminfo |grep MemTotal |awk '{print $2}'`
	cur_meminfo=`expr $meminfo / 1048576 `
	jvmmemory=`expr $cur_meminfo \* $presto_memory_percent`
        jvmmemory=`expr $jvmmemory / 100`
        per_node_memory=`expr $jvmmemory \* $per_node_memory_percent`
        per_node_memory=`expr $per_node_memory / 100`
        presto_max_memory=`expr $presto_max_memory + $per_node_memory`
	#EOF
done

echo "presto_max_memory:$presto_max_memory"
echo "presto_manage_node:$presto_manage_node"

#presto configure
echo "create presto config file"
node_id=1
for s in ${arr[@]}
do
	node_ip=${s}
	echo "$node_ip create configfile"
	#echo "$node_ip presto config"
        #mm=`ssh root@$node_ip "cat /proc/meminfo |grep MemTotal |awk '{print $2}'"`
        mm=`ssh root@$node_ip "cat /proc/meminfo |grep MemTotal"`
        meminfo=`echo $mm | awk '{print $2}'`
	#ssh -T root@$node_ip <<-EOF
	#meminfo=`cat /proc/meminfo |grep MemTotal |awk '{print $2}'`
        cur_meminfo=`expr $meminfo / 1048576 `
        jvmmemory=`expr $cur_meminfo \* $presto_memory_percent`
        jvmmemory=`expr $jvmmemory / 100`
        per_node_memory=`expr $jvmmemory \* $per_node_memory_percent`
        per_node_memory=`expr $per_node_memory / 100`
	
	ssh -T root@$node_ip <<-EOF
	su - $dbuser
        mkdir -p $presto_directory/etc
        mkdir -p $presto_directory/etc/catalog
        mkdir -p $presto_directory/data
        
        #hive.properties configure
        rm -rf $presto_directory/etc/catalog/hive.properties
        echo "connector.name=hive-hadoop2" >> $presto_directory/etc/catalog/hive.properties
        echo "hive.metastore.uri=thrift://$hive_metastore_uri" >> $presto_directory/etc/catalog/hive.properties
        echo "hive.config.resources=/etc/hadoop/2.4.2.0-258/0/core-site.xml,/etc/hadoop/2.4.2.0-258/0/hdfs-site.xml" >> $presto_directory/etc/catalog/hive.properties
        echo "hive.allow-drop-table=true" >> $presto_directory/etc/catalog/hive.properties
        
        #config.properties
        rm -rf $presto_directory/etc/config.properties
	if [ $node_ip = $presto_manage_node ];then 
		echo "coordinator=true" >> $presto_directory/etc/config.properties
		echo "node-scheduler.include-coordinator=true" >> $presto_directory/etc/config.properties
	fi
	if [ $node_ip != $presto_manage_node ];then 
		echo "coordinator=false" >> $presto_directory/etc/config.properties
	fi
        echo "http-server.http.port=9000" >> $presto_directory/etc/config.properties
        echo "query.max-memory=$presto_max_memory"GB"" >> $presto_directory/etc/config.properties
        echo "query.max-memory-per-node=$per_node_memory"GB"" >> $presto_directory/etc/config.properties
        echo "discovery-server.enabled=true" >> $presto_directory/etc/config.properties
        echo "discovery.uri=http://$presto_manage_node:9000" >> $presto_directory/etc/config.properties
        
        #jvm.properties
        rm -rf $presto_directory/etc/jvm.config
        echo "-server" >> $presto_directory/etc/jvm.config
        echo "-Xmx$jvmmemory"G"" >> $presto_directory/etc/jvm.config
        echo "-XX:+UseG1GC" >> $presto_directory/etc/jvm.config
        echo "-XX:G1HeapRegionSize=32M" >> $presto_directory/etc/jvm.config
	echo "-XX:+UseGCOverheadLimit" >> $presto_directory/etc/jvm.config
        echo "-XX:+ExplicitGCInvokesConcurrent" >> $presto_directory/etc/jvm.config
        echo "-XX:+HeapDumpOnOutOfMemoryError" >> $presto_directory/etc/jvm.config
        echo "-XX:OnOutOfMemoryError=kill -9 %p" >> $presto_directory/etc/jvm.config
        
        #log.properties
        echo "com.facebook.presto=DEBUG" >> $presto_directory/etc/log.properties
        
        #node.properties
        echo "node.environment=test" >> $presto_directory/etc/node.properties
        echo "node.id=$node_id" >> $presto_directory/etc/node.properties
        echo "node.data-dir=$presto_directory/data" >> $presto_directory/etc/node.properties
        
        exit
	EOF
	let node_id++
        #echo $node_ip
        #echo $node_memory
        #echo $jvmmemory
        #echo $node_status
done
#startup presto node
echo "presto node startup"
/bin/sh start_all_presto.sh
