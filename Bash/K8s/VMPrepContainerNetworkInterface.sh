#!/bin/bash -xe

# ╔════════════╗
# ║   Calico   ║
# ╚════════════╝

# Based on reference below, there are 2 ways to implement Calico:
# (1) Calico Operator (Bloated Version)
# (2) Calico Manifest (Simple Version)
#
# Reference :
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/config-options
#
# Concepts
#
# Calico Operator
# Calico is installed by an operator which manages the installation, upgrade, and general lifecycle of a Calico cluster.
# The operator is installed directly on the cluster as a Deployment, and is configured through one or more custom Kubernetes API resources.
#
# Calico Manifest
# Calico can also be installed using raw manifests as an alternative to the operator.
# The manifests contain the necessary resources for installing Calico on each node in your Kubernetes cluster.
# Using manifests is not recommended as they cannot automatically manage the lifecycle of the Calico as the operator does.
# However, manifests may be useful for clusters that require highly specific modifications to the underlying Kubernetes resources.

# To Do :
# Find a Better Container Network Interface (CNI), Calico has been acting up too much, pushing us towards their own agendas, similar to what Microsoft or Google have been doing.

sudo echo "Executing $0 $1 $2 $3 $4 $5 $6 $7 $8 $9"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/K8sServerEnvironmentVariable.sh;sudo chmod 777 $HOME/K8sServerEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/K8sServerEnvironmentVariable.sh;source $HOME/K8sServerEnvironmentVariable.sh

Loop_Period="9s"

# Change the values into empty string '' or "", if you just want to install the latest versions but don't know which version is the latest one.
CalicoVersion=''

# CalicoBlockSize=24         # <<<--- Calico Operator Parameter



declare -a file_url
declare -a file_name
declare -a file_acl
declare -a file_own
declare -a file_result

# ###################
# # Calico Operator #
# ###################

# if [ -z "$CalicoVersion" ] ; then
#  file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/master/manifests/tigera-operator.yaml"         # <<<--- Calico Operator Parameter
# else
#  file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/v$CalicoVersion/manifests/tigera-operator.yaml"         # <<<--- Calico Operator Parameter
# fi
# file_name[0]="$HOME/calico-operator.yaml"
# file_acl[0]="644"
# file_own[0]="ubuntu:ubuntu"

# if [ -z "$CalicoVersion" ] ; then
#  file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/master/manifests/custom-resources.yaml"         # <<<--- Calico Operator Parameter
# else
#  file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/v$CalicoVersion/manifests/custom-resources.yaml"         # <<<--- Calico Operator Parameter
# fi
# file_name[1]="$HOME/calico-resources.yaml"
# file_acl[1]="644"
# file_own[1]="ubuntu:ubuntu"

# max_counter=1



###################
# Calico Manifest #
###################

if [ -z "$CalicoVersion" ] ; then
 file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml"         # <<<--- Calico Manifest Parameter
else
 file_url[0]="https://raw.githubusercontent.com/projectcalico/calico/v$CalicoVersion/manifests/calico.yaml"         # <<<--- Calico Manifest Parameter
fi
file_name[0]="$HOME/calico.yaml"
file_acl[0]="644"
file_own[0]="ubuntu:ubuntu"

max_counter=0



###############
# Common Part #
###############

URLRegEx="^(http:\/\/|https:\/\/)?[a-z0-9]+((\-|\.)[a-z0-9]+)*\.[a-z]{2,}(:[0-9]{1,5})?(\/.*)*$"

for counter in $(seq 0 $max_counter) ; do
 if [[ ${file_url[$counter]} =~ $URLRegEx ]] ; then
  file_result[$counter]=$(/usr/bin/curl -fksSL --retry 333 -w "%{http_code}" ${file_url[$counter]} -o ${file_name[$counter]})
  if [[ ${file_result[$counter]} == 200 ]] ; then
   echo "$counter ; HTTP ${file_result[$counter]} ; ${file_name[$counter]} download complete."
   chown ${file_own[$counter]} ${file_name[$counter]}
   chmod ${file_acl[$counter]} ${file_name[$counter]}
  else
   echo "$counter ; HTTP ${file_result[$counter]} ; Failed to download ${file_name[$counter]} ; Continuing . . ."
  fi
 else
  echo "$counter ; Reference to the ${file_name[$counter]} was not a URL ; Continuing . . ."
 fi
done



# ###################
# # Calico Operator #
# ###################

# kubectl create -f $HOME/calico-operator.yaml

# cat $HOME/calico-resources.yaml | sed -n '/^ *- blockSize: [0-9]\+$/p'
# sed -i 's/- blockSize: [0-9]\+$/- blockSize: '"$CalicoBlockSize"'/g' $HOME/calico-resources.yaml
# cat $HOME/calico-resources.yaml | sed -n '/^ *- blockSize: [0-9]\+$/p'

# cat $HOME/calico-resources.yaml | sed -n '/^ *cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$/p'
# sed -i 's#cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$#cidr: '"$PodNetworkCIDR"'#g' $HOME/calico-resources.yaml
# cat $HOME/calico-resources.yaml | sed -n '/^ *cidr: [0-9]\+.[0-9]\+.[0-9]\+.[0-9]\+\/[0-9]\+$/p'

# kubectl apply -f $HOME/calico-resources.yaml



###################
# Calico Manifest #
###################

kubectl apply -f $HOME/calico.yaml



# ###################
# # Calico Operator #
# ###################

# Loop="Yes"
# while ( [ "$Loop" == "Yes" ] ) ; do
#  if [ `kubectl get pod --namespace calico-system --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --namespace calico-system -o wide --no-headers | grep "Running" | wc -l` -ge `kubectl get pod --namespace calico-system --no-headers | wc -l` ] ; then
#   echo "`date +%Y%m%d%H%M%S` Calico is Ready."
#   Loop="No"
#  else
#   echo "`date +%Y%m%d%H%M%S` Waiting for Calico to be Ready."
#   sleep $Loop_Period
#  fi
# done



###################
# Calico Manifest #
###################

Loop="Yes"
while ( [ "$Loop" == "Yes" ] ) ; do
 if [ `kubectl get pod --all-namespaces --no-headers | wc -l` -gt 0 ] && [ `kubectl get pod --all-namespaces -o wide --no-headers | grep -e "Completed" -e "Running" | wc -l` -ge `kubectl get pod --all-namespaces --no-headers | wc -l` ] ; then
  echo "`date +%Y%m%d%H%M%S` All Pods are Completed or Running."
  Loop="No"
 else
  echo "`date +%Y%m%d%H%M%S` Waiting for All Pods to be Completed or Running."
  sleep $Loop_Period
 fi
done



#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

# ###################
# # Calico Operator #
# ###################

# kubectl get pods --namespace calico-system



###################
# Calico Manifest #
###################

kubectl get pods --all-namespaces



#╔═════════╗
#║   End   ║
#╚═════════╝
