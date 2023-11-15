#!/bin/bash -xe

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/K8sServerEnvironmentVariable.sh;sudo chmod 777 $HOME/K8sServerEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/K8sServerEnvironmentVariable.sh;source $HOME/K8sServerEnvironmentVariable.sh

# For Multi-Nodes K8s Cluster, additional entries to /etc/hosts is needed:
#
# $1 Subnet's Prefix
# $2 First Master's IP Address
# $3 Number of Masters (Currently only Support 1/One)
# $4 First Worker's IP Address
# $5 Number of Worker (Max Supported is 9/Nine)
#
# No defaults can be defined within this bash scripts alone.

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] ; then
 # One or more Argument(s) missing. Consider there is No Argument given.
 # Do Nothing.
else
 # All Arguments exist (NOT necessarily correct). Let's try to do this.
 set Prefix = $1
 set MasterOffset = $2
 set NumberOfMaster = $3
 set WorkerOffset = $4
 set NumberOfWorker = $5
 for counter in $(seq 1 $NumberOfMaster) ; do
  echo "$Prefix.$((MasterOffset+counter-1)) $MasterNodeNamePrefix" | sudo tee --append /etc/hosts
 done
 for counter in $(seq 1 $NumberOfWorker) ; do
  echo "$Prefix.$((WorkerOffset+counter-1)) $WorkerNodeNamePrefix" | sudo tee --append /etc/hosts
 done
fi



let counter=0;while ( (sudo lsof /var/cache/apt/archives/lock) || (sudo lsof /var/lib/apt/lists/lock) || (sudo lsof /var/lib/dpkg/lock*) || ((`(ps aux -A | grep -i -c "apt")` > 1)) );do let counter++;echo "$counter";if (sudo lsof /var/cache/apt/archives/lock);then printf "$counter sudo lsof /var/cache/apt/archives/lock\n`sudo lsof /var/cache/apt/archives/lock`\n";fi;if (sudo lsof /var/lib/apt/lists/lock);then printf "$counter sudo lsof /var/lib/apt/lists/lock\n`sudo lsof /var/lib/apt/lists/lock`\n";fi;if (sudo lsof /var/lib/dpkg/lock*);then printf "$counter sudo lsof /var/lib/dpkg/lock*\n`sudo lsof /var/lib/dpkg/lock*`\n";fi;if ((`(ps aux -A | grep -i -c "apt")` > 1));then printf "$counter ps aux -A | grep -i \"apt\"\n`ps aux -A | grep -i \"apt\"`\n";fi;sleep 1s;done
sudo apt-get update -y && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

sudo echo "@reboot   root   swapoff -a" | sudo tee -a /etc/crontab
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo echo "net.bridge.bridge-nf-call-ip6tables=1" | sudo tee -a /etc/sysctl.conf
sudo echo '1' | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables

sudo printf "overlay\nbr_netfilter" | sudo tee -a /etc/modules-load.d/containerd.conf
sudo modprobe overlay
sudo modprobe br_netfilter

sudo sysctl --system
sudo sysctl --load

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

sudo echo "/etc/fstab :"
sudo cat /etc/fstab
sudo echo "/etc/crontab :"
sudo cat /etc/crontab

sudo echo "/etc/sysctl.conf :"
sudo cat /etc/sysctl.conf
sudo echo "/proc/sys/net/bridge/bridge-nf-call-iptables :"
sudo cat /proc/sys/net/bridge/bridge-nf-call-iptables

sudo echo "/etc/modules-load.d/containerd.conf :"
sudo cat /etc/modules-load.d/containerd.conf

#╔═════════╗
#║   End   ║
#╚═════════╝
