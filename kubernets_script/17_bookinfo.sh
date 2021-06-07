
kubeclt create namespace bookinfo
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml --namespace=bookinfo
#######Verifying the installation 
kubectl get all --namespace=bookinfo
kubectl exec  "$(kubectl get pod -l  app=ratings --namespace bookinfo -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings --namespace bookinfo -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
kubectl apply -f sample_yaml/ingress.yml #This will implement AWS APPLICATION LOAD BALANCER
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml #Istio gateway and virtual service implementation
istioctl analyze

