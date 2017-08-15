# NVIDIA Overclock Scripts
A couple of scripts I use to overclock the nvidia 1070 cards for Ethereum, I can't take full credit for these.  I found and then modified the scripts.  Couple of important notes.

1.  Make sure you have coolbits set in your xorg.conf 
I use: Option         "Coolbits" "31"

Here is an exmaple of one of my devices:<br />
Section "Device"<br />
&nbsp;&nbsp;&nbsp;Identifier     "Device0"<br />
&nbsp;&nbsp;&nbsp;Driver         "nvidia"<br />
&nbsp;&nbsp;&nbsp;VendorName     "NVIDIA Corporation"<br />
&nbsp;&nbsp;&nbsp;BoardName      "GeForce GTX 1070"<br />
&nbsp;&nbsp;&nbsp;BusID          "PCI:1:0:0"<br />
&nbsp;&nbsp;&nbsp;Option         "CustomEDID" "DFP-0:/etc/X11/edid.bin"<br />
&nbsp;&nbsp;&nbsp;Option         "ConnectedMonitor" "DFP-0"<br />
&nbsp;&nbsp;&nbsp;Option         "Coolbits" "31"<br />
&nbsp;&nbsp;&nbsp;Option  "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerDefaultAC=0x1"<br />
EndSection<br />

2.  You have to be using an older version of the nvidia drivers (nvidia removed overclock ability) 375 should work.


I included my xorg.conf so you can see a full script.  This is for the 7 card Asus z270a


# Method
We use a custom Debian 9 that PXE boots (I hope to post this image later)

1.  Boot to a small initrd

2.  Mount NFS

3.  Create 6 GB Ramfs (All Systems outfitted with 8gb of ram)

4.  Copy the image to Ramfs

5.  Mount as local.

6.  Chroot and boot

7.  Auto login as root /etc/systemd/system/getty@tty1.service.d/override.conf

8.  Read .bashrc, if it's the local tty then we execute some scripts (fans.sh and overclock.sh located /root)

9.  fans.sh contains all the settings to set the fans to a speed of 100% I have found that heat detection is terrible when not using X

10.  overclock.sh performs the overclock, These are the most optimal settings I have found and have had rigs up for weeks on this -200 GPU and +1200 memory, if you happen to have a card with Samsung memory you can probably push the mem clock a bit further.

11.  Start ethminer (included a compiled debian 9 version of ethminer):<br />
	sha256 - 8943de02b0b548611b08c7aa1f9198198413418046091bf0d113f8483b1810f2  /home/john/ethminer.tar.bz2<br />
	sha1 - 07580ef243af500ee5294061926b48d999697d6e  /home/john/ethminer.tar.bz2<br />
	sha512 - 21d5ba726eb8aa2fadf0de24af9a37fd80fba738ce5837304759ed15786bac838a1bdef030e224cba32fee1243376cee496c361b4c8df83bb543a456318d2555  /home/john/ethminer.tar.bz2<br />
	md5sum - c5fc5485300adea00b8e7b05ea91790c  /home/john/ethminer.tar.bz2<br />

# Remote Monitoring

Remotely monitoring ethminer, is kind of a pain (no included API).  but we do have a solution.

By starting ethminer in a logged screen session we can grab the log file, parse it and post it, this is runhash.sh make sure you change the ip addresses to the place you want to actually run against.

api.php is the script that inserts or updates the sql database (gpuMiners.db)

index.php is a simple table display of the miners work.

You want to make sure to put runhash.sh into a cronjob and run it every minute, so your stats are never more then a minute old.

downUpdater.php runs every minute in a cronjob and sets a miners status to down if it hasn't reported in 5 minutes, this will highlight the miner red in the online.

included in index.php is the tripplite snmpset to shut off a plug, You could have your monitor machine shoot the node in the head to have it come back online again, right now we aren't doing this.

# Swag

If you find ANY of this useful you could drop me some BTC or ETH:

BTC: 1DYvxdfZNkv8QZshtLeRdyYtiTU1FxKGy5<br/>
ETH: C352455DbA90d0520A7667f8aBfd270b2943DDf2<br />


--John
