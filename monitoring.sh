#!/bin/bash
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -H /home/ --output=avail | grep "[0-9]")
udisk=$(df -m /home/ --output=used | grep "[0-9]")
pdisk=$(df /home/ --output=pcent | grep "[0-9]")
lvm=$(lsblk | grep "lvm" |wc -l)
{
echo "#Architecture: $(uname -a)"
echo "#CPU physical: $(nproc)"
echo "#vCPU: $(grep "^processor" /proc/cpuinfo | wc -l)"
echo "#Memory Usage: $uram/$fram"MB" ($pram%)"
echo "#Disk Usage: $udisk/${fdisk//[[:blank:]]/}"b" (${pdisk//[[:blank:]]/})"
echo "#CPU load: $(top -bn1 | grep '^%Cpu' | cut -c 10- | xargs | awk '{printf("%.1f%%", $1 + $3)}')"
echo "#Last boot: $(who -b | awk '$1 == "system" {print $3 " " $4}')"
echo "#LVM use: $(if [ $lvm -eq 0 ]; then echo no; else echo yes; fi)"
echo "#Connexions TCP: $(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}') ESTABLISHED"
echo "#User log: $(users | wc -w)"
echo "#Network: IP $(hostname -I | awk '{print $1}') ($(ip link show | awk '$1 == "link/ether" {print $2}'))"
echo "Sudo: $(cat /var/log/sudo/logs |grep -c COMMAND) cmd"
} > > (tee temp) 2>&1
wall -n temp
