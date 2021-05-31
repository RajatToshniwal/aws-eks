

policy_name="eksctl-AWSLoadBalancerControllerIAMPolicy"
account_id="XXXXXX"
cluster_name="poc-eks-cluster"
vpc_id="vpc-00000000"
region=us-east-X
cd /tmp
#####Creating Policy for ALB controller
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name $policy_name \
    --policy-document file://iam-policy.json
policy_arn="arn:aws:iam::$account_id:policy/$policy_name"
###############Creating Service Account in Kubernetes with the permissions mentioned in policy. OIDC needs to be enabled
eksctl create iamserviceaccount --name alb-ingress-controller --namespace kube-system --cluster $cluster_name --attach-policy-arn $policy_arn --approve --override-existing-serviceaccounts --region $region
#############Verification if the service account is created or not
eksctl get iamserviceaccount --cluster $cluster_name --name alb-ingress-controller --region $region
################Create ClusterRole and ClusterRoleBindings
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
cat rbac-role.yaml  | sed '/apiVersion: v1/,/kube-system\n...\$/{d}' >  rbac-role-1.yaml
/home/ubuntu/installations/kubectl apply -f rbac-role-1.yaml
##################Deploy ALB ingress controller
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.9/docs/examples/alb-ingress-controller.yaml
sed "s/# - --aws-region=us-west-1/- --aws-region=$region/g ; s/# - --cluster-name=devCluster/- --cluster-name=$cluster_name/g ; s/# - --aws-vpc-id=vpc-xxxxxx/- --aws-vpc-id=$vpc_id/g" /tmp/alb-ingress-controller.yaml > alb-ingress-controller_apply
/home/ubuntu/installations/kubectl apply -f alb-ingress-controller_apply
kubectl rollout status deployment alb-ingress-controller -n kube-system
