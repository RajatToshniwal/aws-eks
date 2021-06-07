CLUSTER_NAME="YOUR_CLUSTER_NAME"    #Name of the EKS Cluster
REGION="AWS_REGION"   #Region in which EKS cluster is created
OIDC_Provider_url=`aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.identity.oidc.issuer"|awk -F "/" '{print $NF}'`
echo $OIDC_Provider_url
#List the IAM OIDC providers in your account
CNT_OIDC=`aws iam list-open-id-connect-providers | grep $OIDC_Provider_url|wc -l`
echo $CNT_OIDC
if [ $CNT_OIDC -eq 0 ];then
        eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --region $REGION --approve
fi
