CLUSTER_NAME="YOUR_CLUSTER_NAME"    #Name of the EKS Cluster
ACCOUNT_ID="XXXXX"  #AWS Account ID
POLICY_NAME=EKSroleautoscaler-us-east-2-autoscalerpolicy #####taken from the cloudformation script output
REGION="AWS_REGION"   #Region in which EKS cluster is created
image_tag_version="1.20.0" ##### Depends upon the kubernetes version you are using
eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME\
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME \
  --override-existing-serviceaccounts \
  --region=$REGION \
  --approve
####Deploy the autoscaler
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
#####•	Patch the deployment to add the cluster-autoscaler.kubernetes.io/safe-to-evict annotation to the Cluster Autoscaler pods 
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
KUBE_EDITOR="sed -z 's/<YOUR.*NAME>/$CLUSTER_NAME/' -i " kubectl -n kube-system edit deployment.apps/cluster-autoscaler
KUBE_EDITOR="sed   '/$CLUSTER_NAME/a \        - --balance-similar-node-groups\n\        - --skip-nodes-with-system-pods=false' -i "  kubectl -n kube-system edit deployment.apps/cluster-autoscaler
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v$image_tag_version

