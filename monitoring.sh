#!/bin/bash

arc=$(uname -a)
pcpu=$(grep 'physical id' /proc/cpuinfo | wc -l)
vcpu=$(grep 'processor' /proc/cpuinfo | wc -l)
tmem=$(free -m | grep 'Mem' | awk '{print $2}')
umem=$(free -m | grep 'Mem' | awk '{print $3}')
pmem=$(free -m | grep 'Mem' | awk '{print $3/$2*100}')
adisk=$(df --block-size=1073741824 --total | grep 'total' | awk '{print $4}')
udisk=$(df --block-size=1073741824 --total | grep 'total' | awk '{print $3}')
pdisk=$(df --total | grep 'total' | awk '{print $5}')
lcpu=$(vmstat | sed -n 3p | awk '{print 100-$15}')
lb=$(who -b | awk '{print $2,$3}')
lvm=$(if [ $(lsblk | grep 'lvm' | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)
tcp=$(netstat | grep 'ESTABLISHED' |wc -l)
user=$(who | wc -l)
ip=$(hostname -I)
mac=$(ip a | grep 'link/ether' | awk '{print $2}')
sudo=$(cat /var/log/sudo/sudo.log | grep -a 'COMMAND' | wc -l)

wall "
#Architecture: $arc
#CPU physical: $pcpu
#vCPU: $vcpu
#Memory Usage: $umem/${tmem}MB ($pmem%)
#Disk Usage: $udisk/${adisk}GB ($pdisk)
#CPU load: $lcpu%
#Last boot: $lb
#LVM use: $lvm
#Connections TCP: $tcp ESTABLISHED
#User log: $user
#Network: IP $ip ($mac)
#Sudo: $sudo cmd
"
