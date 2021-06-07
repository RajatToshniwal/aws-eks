CLUSTER_NAME="YOUR_CLUSTER_NAME"    #Name of the EKS Cluster
REGION="AWS_REGION"   #Region in which EKS cluster is created
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/daemonset/cwagent-fluentd-xray/cwagent-fluentd-xray-quickstart.yaml | sed "s/{{cluster_name}}/$CLUSTER_NAME/;s/{{region_name}}/$REGION/" | kubectl apply -f -
