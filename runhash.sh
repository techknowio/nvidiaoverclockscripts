cp /var/log/hashing /tmp/hashing-work
dos2unix -q -f /tmp/hashing-work
HASHES=`cat /tmp/hashing-work |grep MH |cut -d ":" -f 4 | cut -d M -f1 | cut -d "." -f 1`
TOTALHASH=0
COUNT=0
for i in $HASHES; do
        if [ "$i" != "F0]" ]; then
                COUNT=$((COUNT+1))
		if [ "$i" = "F1]" ]; then
			sleep 3
			echo -n "" > /var/log/hashing
			/root/runhash.sh
			exit
		fi
                TOTALHASH=$((TOTALHASH+i))
        fi
done
MACS=`cat /sys/class/net/*/address`

for i in $MACS; do
        if [ "$i" != "00:00:00:00:00:00" ]; then
                MAC=$i
        fi
done

IP=`ip addr show | awk '/inet/ {print $2}'`
for i in $IP; do
        if [ "$i" != "127.0.0.1/8" ]; then
                IP=`echo $i | cut -d "/" -f 1`
        fi
done
#echo $IP $MAC

#echo $hashrate
curl -X POST --data "cmd=setip&mac=$MAC&ip=$IP" http://192.168.99.207/api.php
if [ "$COUNT" == "0" ]; then
    sleep 3
    /root/runhash.sh
    exit
fi
hashrate=$((TOTALHASH / COUNT))
re='^[0-9]+$'
if ! [[ $TOTALHASH =~ $re ]] ; then
   echo "Not A Number"
   exit
fi
echo $COUNT $hashrate TH: $TOTALHASH
if [ "$COUNT" == "0" ]; then
        exit
fi
MACS=`cat /sys/class/net/*/address`

for i in $MACS; do
        if [ "$i" != "00:00:00:00:00:00" ]; then
                MAC=$i
        fi
done

IP=`ip addr show | awk '/inet/ {print $2}'`
for i in $IP; do
        if [ "$i" != "127.0.0.1/8" ]; then
                IP=`echo $i | cut -d "/" -f 1`
        fi
done
#echo $IP $MAC

#echo $hashrate
curl -X POST --data "cmd=hashrate&mac=$MAC&ip=$IP&hashrate=$hashrate" http://192.168.99.207/api.php
echo -n "" > /var/log/hashing