clustername="poc-eks-cluster"
region="your_region"
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-deployment-manifest-templates/deployment-mode/daemonset/cwagent-fluentd-xray/cwagent-fluentd-xray-quickstart.yaml | sed "s/{{cluster_name}}/$clustername/;s/{{region_name}}/$region/" | kubectl apply -f -
