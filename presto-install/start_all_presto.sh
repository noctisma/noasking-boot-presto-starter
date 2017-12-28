#/bin/bash
#startup presto
export PRESTO_CONF="./conf/presto.conf"
presto_ip=($(awk 'NR==1{print}' $PRESTO_CONF))
dbuser=($(awk 'NR==5{print}' $PRESTO_CONF))
presto_version=($(awk 'NR==6{print}' $PRESTO_CONF))
dbpassword=$dbuser
dbhome=/home/$dbuser
presto_name=$presto_version
presto_directory=/home/$dbuser/$presto_name
#echo $PRESTO_CONF
#presto_ip=($(awk 'NR==1{print}' $PRESTO_CONF))
OLD_IFS="$IFS"
IFS="#"
arr="${presto_ip}"
for i in ${arr[@]}
do
	ssh -T root@${i} <<-EOF
	su - $dbuser
	echo "${i} presto start"
	/bin/sh $presto_directory/bin/launcher start
	exit
	EOF
done
