CLUSTER_NAME="YOUR_CLUSTER_NAME"  #Name of the EKS Cluster
REGION="region name"    #Region in which EKS Cluster is created
ACCOUNT_ID= "XXXXX"   #AWS Account ID
efspods=`kubectl get pods -n kube-system |grep -i "efs-csi" |wc -l`
if [ $efspods -eq 0 ];then
## Download the IAM policy document 
curl -S https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.2.0/docs/iam-policy-example.json -o iam-policy.json

## Create an IAM policy 
aws iam create-policy \ 
  --policy-name EFSCSIControllerIAMPolicy \ 
  --policy-document file://iam-policy.json 

## Create a Kubernetes service account 
eksctl create iamserviceaccount \ 
  --cluster=$CLUSTER_NAME \ 
  --region $REGION \ 
  --namespace=kube-system \ 
  --name=efs-csi-controller-sa \ 
  --override-existing-serviceaccounts \ 
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/EFSCSIControllerIAMPolicy \ 
  --approve


kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.1"
fi
