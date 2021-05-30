#This script assumes all the installations to be done in "/home/ubuntu" directory.
pth="/home/ubuntu"
cd $pth
#AWS ClI installation
awsdir=aws
if [[ ! -e $awsdir ]]; then
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
/usr/local/bin/aws --version
fi
kubectl_file="$HOME/bin/kubectl"
if [ ! -f $kubectl_file ]; then
#Kubectl installation
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
chmod u+x kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
kubectl version
fi
eksctl_comm="eksctl"
if ! command -v $eksctl_comm &> /dev/null;then
#eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
fi
#git Installation
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -neq 0 ]; then
apt-get update && apt-get install git -y
fi
