cluster_name="poc-eks-cluster"
region="EKS region"
namespace="YOUR_namespace"
cd /home/ubuntu/installations/
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.10.0/
export PATH=$PWD/bin:$PATH

##############Istio depenencoes check
aws eks --region $region update-kubeconfig --name $cluster_name
istioctl x precheck
######Install istio on Kubernetes
istioctl install --set profile=default --set values.gateways.istio-ingressgateway.type=NodePort -y
#istioctl install --set profile=default -y
kubectl label namespace $namespace istio-injection=enabled
