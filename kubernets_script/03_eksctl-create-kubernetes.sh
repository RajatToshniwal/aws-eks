#!/usr/bin/env sh
name=$1
version=$2
region=$3
vpcprivate1=$4
vpcprivate2=$5
vpcpublic1=$6
vpcpublic2=$7
vpcpublic3=$8
nodetype=$9
min="${10}"
max="${11}"
key="${12}"
nodegroupname="${13}"
nodevolumesize="${14}"
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
