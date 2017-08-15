#!/bin/bash
CLOCK=-200
MEM=1200
COUNT=`/usr/bin/nvidia-smi -q |grep "Product Name" | wc -l`
echo "Total Cards: $COUNT"
COUNT=$(expr $COUNT - 1)
export DISPLAY=:0
xinit &
sleep 5
#chvt 1
CMD=/usr/bin/nvidia-settings
for (( i=0; i<=$COUNT; i++ ))
  do
    #enable persistent mode
    #/usr/bin/nvidia-smi -i ${i} -pm 1
	#max Wattage 170 watts
    #/usr/bin/nvidia-smi -i ${i} -pl 200
	#set the max cpu/Memory
    #/usr/bin/nvidia-smi -i ${i} -ac 4004,1911

    ${CMD} -a [gpu:${i}]/GPUPowerMizerMode=1
    #${CMD} -a [gpu:${i}]/GPUFanControlState=1
    #${CMD} -a [fan:${i}]/GPUTargetFanSpeed=100

    for x in {3..3}
      do
        ${CMD} -a [gpu:${i}]/GPUGraphicsClockOffset[${x}]=${CLOCK}
        ${CMD} -a [gpu:${i}]/GPUMemoryTransferRateOffset[${x}]=${MEM}
    done

done

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_ALLOC_PERCENT=100

screen -L /var/log/hashing -dmS ethminer /usr/local/bin/ethminer -U -F http://192.168.99.207:8080/shop --farm-recheck 200

#screen -L /var/log/hashing -dmS ethdcrminer64 /usr/src/ethdcrminer64 -epool http://192.168.99.207:8080/shop

#kill -9 `pidof Xorg`