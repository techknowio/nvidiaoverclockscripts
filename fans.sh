#!/bin/bash
CLOCK=1974
MEM=3802
COUNT=`/usr/bin/nvidia-smi -q |grep "Product Name" | wc -l`
echo "Total Cards: $COUNT"
cp /etc/X11/xorg.conf.$COUNT /etc/X11/xorg.conf
COUNT=$(expr $COUNT - 1)
export DISPLAY=:0
CMD=/usr/bin/nvidia-settings
xinit &
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_USE_SYNC_OBJECTS=1
sleep 5
#chvt 1
for (( i=0; i<=$COUNT; i++ ))
  do
    #enable persistent mode
    /usr/bin/nvidia-smi -i ${i} -pm 1
	#max Wattage 170 watts
    /usr/bin/nvidia-smi -i ${i} -pl 200
	#set the max cpu/Memory
    #/usr/bin/nvidia-smi -i ${i} -ac 4004,1911

    #${CMD} -a [gpu:${i}]/GPUPowerMizerMode=1
    ${CMD} -a [gpu:${i}]/GPUFanControlState=1
    ${CMD} -a [fan:${i}]/GPUTargetFanSpeed=100

    #for x in {3..3}
    #  do
    #    ${CMD} -a [gpu:${i}]/GPUGraphicsClockOffset[${x}]=${CLOCK}
    #    ${CMD} -a [gpu:${i}]/GPUMemoryTransferRateOffset[${x}]=${MEM}
    #done

done

PID=`pidof Xorg`
kill -9 `pidof Xorg`

#wait for the Xorg pid to go away...

while kill -0 $PID 2> /dev/null; do sleep 1; done;
root@ethereum1:~# 
