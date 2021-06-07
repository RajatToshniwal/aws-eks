

POLICY_NAME="eksctl-AWSLoadBalancerControllerIAMPolicy" #Name of the policy for AWS Ingress. 
ACCOUNT_ID="XXXXX"  #AWS Account ID
CLUSTER_NAME="YOUR_CLUSTER_NAME"    #Name of the EKS Cluster
VPC_ID="vpc-00000000"  #VPC ID in which Cluster exist
REGION="AWS_REGION"   #Region in which EKS cluster is created
cd /tmp
#####Creating Policy for ALB controller
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.8/docs/examples/iam-policy.json

aws iam create-policy \
    --policy-name $POLICY_NAME \
    --policy-document file://iam-policy.json
policy_arn="arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME"
###############Creating Service Account in Kubernetes with the permissions mentioned in policy. OIDC needs to be enabled
eksctl create iamserviceaccount --name alb-ingress-controller --namespace kube-system --cluster $CLUSTER_NAME --attach-policy-arn $policy_arn --approve --override-existing-serviceaccounts --region $REGION
#############Verification if the service account is created or not
eksctl get iamserviceaccount --cluster $CLUSTER_NAME --name alb-ingress-controller --region $region
################Create ClusterRole and ClusterRoleBindings
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
cat rbac-role.yaml  | sed '/apiVersion: v1/,/kube-system\n...\$/{d}' >  rbac-role-1.yaml
kubectl apply -f rbac-role-1.yaml
##################Deploy ALB ingress controller
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.9/docs/examples/alb-ingress-controller.yaml
sed "s/# - --aws-region=us-west-1/- --aws-region=$REGION/g ; s/# - --cluster-name=devCluster/- --cluster-name=$CLUSTER_NAME/g ; s/# - --aws-vpc-id=vpc-xxxxxx/- --aws-vpc-id=$VPC_ID/g" /tmp/alb-ingress-controller.yaml > alb-ingress-controller_apply
kubectl apply -f alb-ingress-controller_apply
kubectl rollout status deployment alb-ingress-controller -n kube-system
