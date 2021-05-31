cluster_name="YOUR_CLUSTER_NAME"
region="AWS_REGION""
OIDC_Provider_url=`aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer"|awk -F "/" '{print $NF}'`
echo $OIDC_Provider_url
#List the IAM OIDC providers in your account
CNT_OIDC=`aws iam list-open-id-connect-providers | grep $OIDC_Provider_url|wc -l`
echo $CNT_OIDC
if [ $CNT_OIDC -eq 0 ];then
        eksctl utils associate-iam-oidc-provider --cluster $cluster_name --region $region --approve
fi
