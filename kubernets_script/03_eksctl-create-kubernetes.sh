#!/usr/bin/env sh
#This script will create the EKS cluster. Optionally you can add or delete parameters as per your requirement.
#This script requires the following parameters
name=$1   #Name of the EKS cluster
version=$2   #Version of the EKS cluster
region=$3    #Region in which EKS cluster will be created
vpcprivate1=$4    #Private Subnet of the cluster, data nodes will be created here.
vpcprivate2=$5    #Private Subnet of the cluster, data nodes will be created here. 
vpcpublic1=$6     #Public Subnet of the cluster, master plane will be deployed here.
vpcpublic2=$7     #Public Subnet of the cluster, master plane will be deployed here.
vpcpublic3=$8     #Public Subnet of the cluster, master plane will be deployed here.
nodetype=$9       #Instance Type of the data nodes
min="${10}"       #Minimum number of data nodes 
max="${11}"       #Maximu number of data nodes
key="${12}"       #SSH key for the data nodes 
nodegroupname="${13}"  #Nodegroup name
nodevolumesize="${14}"   #Disk size of the data nodes
echo "Name: $name"
echo "Version: $version"
echo "Region: $region"
echo "Private Subnet- $vpcprivate1,$vpcprivate2"
echo "Public Subnet - $vpcpublic1,$vpcpublic2,$vpcpublic3"
echo "NodeType $nodetype"
echo "min,max = $min,$max"
echo "key = $key"
echo "Nodegroupname=$nodegroupname"
time eksctl create cluster \
        --name $name \
        --version $version \
        --region $region \
        --vpc-private-subnets=$vpcprivate1,$vpcprivate2 \
        --vpc-public-subnets=$vpcpublic1,$vpcpublic2,$vpcpublic3 \
        --node-private-networking \
        --nodegroup-name $nodegroupname \
        --node-type $nodetype \
        --nodes-min $min \
        --nodes-max $max \
        --ssh-access \
        --ssh-public-key $key \
        --managed \
        --node-volume-size=$nodevolumesize \
        --disable-pod-imds
