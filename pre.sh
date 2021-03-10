#!/bin/bash
# A Bash script to prepare an EC2 node for HDP installation
# v1.1
# 27JUN14

echo "****************************"
echo "Starting Prepare Host"
echo "****************************"

#yum update
yum update -y

#set umask
echo -e "\nSetting Umask to 022 in .bashrc"
umask 022
echo "umask 022" >> ~/.bashrc

#disable SELinux
echo -e "\nDisabling SELinux"
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo""

#Set swappiness value to 0
echo "vm.swappiness = 0" >> /etc/sysctl.conf
sysctl vm.swappiness
echo""

#Check status of IPV6
cat /proc/sys/net/ipv6/conf/all/disable_ipv6

# To disable IPV6
sudo su -c 'cat >>/etc/sysctl.conf <<EOL#net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.all.disable_ipv6 =1
net.ipv6.conf.default.disable_ipv6 =1
net.ipv6.conf.lo.disable_ipv6 =1
EOL'
echo""

#Turn on NTPD
echo "Setting up NTPD and syncing time"
#Need to add a check to see if NTPD is installed.  If not install it
sudo yum install ntp -y
service ntpd start
service ntpd status

#Iptable
echo "Stoping iptables"
service iptables stop
chkconfig iptables off
echo""

ulimit -n
ulimit -n 10000

#Disable the transparent hugepages in each node
echo""
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
cat /sys/kernel/mm/transparent_hugepage/enabled
cat /sys/kernel/mm/transparent_hugepage/defrag

#sysctl
echo""
sudo sysctl -p

echo "****************************"
echo "Prepare Nodes COMPLETE!"
echo "****************************"