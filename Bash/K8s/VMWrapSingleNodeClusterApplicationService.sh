#!/bin/bash -xe

sudo echo "Executing ${0} with $# parameter(s) : ${1} ${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${22}"
cd $HOME

cd $HOME;sudo curl -fksSL -O --retry 333 https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/K8sServerEnvironmentVariable.sh;sudo chmod 777 $HOME/K8sServerEnvironmentVariable.sh;sudo chown $(id -u):$(id -g) $HOME/K8sServerEnvironmentVariable.sh;source $HOME/K8sServerEnvironmentVariable.sh

declare -a file_url
declare -a file_name
declare -a file_acl
declare -a file_own
declare -a file_result

file_url[0]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMPrepOS.sh"
file_name[0]="$HOME/PrepareOS.sh"
file_acl[0]="777"
file_own[0]="ubuntu:ubuntu"

file_url[1]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMPrepContainerRuntimeInterface.sh"
file_name[1]="$HOME/PrepareContainerRuntimeInterface.sh"
file_acl[1]="777"
file_own[1]="ubuntu:ubuntu"

file_url[2]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMPrepCommonK8s.sh"
file_name[2]="$HOME/PrepareCommonK8s.sh"
file_acl[2]="777"
file_own[2]="ubuntu:ubuntu"

file_url[3]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/VMPrepK8sSingleNode.sh"
file_name[3]="$HOME/PrepareK8sSingleNode.sh"
file_acl[3]="777"
file_own[3]="ubuntu:ubuntu"

file_url[4]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/PrepApplicationService.sh"
file_name[4]="$HOME/PrepareApplicationService.sh"
file_acl[4]="777"
file_own[4]="ubuntu:ubuntu"

file_url[5]="https://raw.githubusercontent.com/hendrychandra/aws-tf-bigip-k8s/main/Bash/K8s/JigokuShoujo43x25.text"
file_name[5]="$HOME/JigokuShoujo43x25.text"
file_acl[5]="644"
file_own[5]="ubuntu:ubuntu"

max_counter=5

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

/bin/bash $HOME/PrepareOS.sh
/bin/bash $HOME/PrepareContainerRuntimeInterface.sh
/bin/bash $HOME/PrepareCommonK8s.sh $WorkerNodeStatus $KubernetesVersion
/bin/bash $HOME/PrepareK8sSingleNode.sh $PodNetworkCIDR $ServiceCIDR $ContainerNetworkInterface $K8sVersion
/bin/bash $HOME/PrepareApplicationService.sh

#╔═══════════════════╗
#║   Review Status   ║
#╚═══════════════════╝

kubectl get node -o wide
kubectl get pod --all-namespaces -o wide
kubectl get service --all-namespaces -o wide

cat $HOME/JigokuShoujo43x25.text

#╔═════════╗
#║   End   ║
#╚═════════╝
