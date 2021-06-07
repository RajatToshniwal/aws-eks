
CLUSTER_NAMESPACE="YOUR_namespace" #Cluster name space where you wanted to enable istio
cd /home/ubuntu/installations/
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.10.0/
export PATH=$PWD/bin:$PATH

##############Istio depenencoes check
aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
istioctl x precheck
######Install istio on Kubernetes
istioctl install --set profile=default --set values.gateways.istio-ingressgateway.type=NodePort -y
#istioctl install --set profile=default -y
kubectl label namespace $CLUSTER_NAMESPACE istio-injection=enabled
