cluster_name=poc-eks-cluster
account_id=XXXXXXXX
policy_name=EKSroleautoscaler-us-east-2-autoscalerpolicy #####taken from the cloudformation script output
region=region
image_tag_version="1.20.0" ##### Depends upon the kubernetes version you are using
eksctl create iamserviceaccount \
  --cluster=$cluster_name\
  --namespace=kube-system \
  --name=cluster-autoscaler \
  --attach-policy-arn=arn:aws:iam::$account_id:policy/$policy_name \
  --override-existing-serviceaccounts \
  --region=$region \
  --approve
####Deploy the autoscaler
/home/ubuntu/installations/kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
#####•	Patch the deployment to add the cluster-autoscaler.kubernetes.io/safe-to-evict annotation to the Cluster Autoscaler pods 
/home/ubuntu/installations/kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
KUBE_EDITOR="sed -z 's/<YOUR.*NAME>/$cluster_name/' -i " kubectl -n kube-system edit deployment.apps/cluster-autoscaler
KUBE_EDITOR="sed   '/$cluster_name/a \        - --balance-similar-node-groups\n\        - --skip-nodes-with-system-pods=false' -i "  kubectl -n kube-system edit deployment.apps/cluster-autoscaler
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v$image_tag_version

