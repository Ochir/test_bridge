
# 1. Install ELK 
# Install repo for ELK 
helm repo add elastic https://helm.elastic.co
helm repo update
#curl -O https://raw.githubusercontent.com/elastic/Helm-charts/master/elasticsearch/values.yaml
helm install elasticsearch elastic/elasticsearch --create-namespace --namespace elk

#curl -O https://raw.githubusercontent.com/elastic/helm-charts/main/kibana/values.yaml
helm install kibana elastic/kibana --namespace elk --set service.type="LoadBalancer" 

#2. Set FQDN in DNS provicer 

# 3. Mysql installation 
kubectl create ns mysql
kubectl create secret generic mysql-pass -n mysql --from-file=password=./password.txt
kubectl apply -f mysql.yaml 
# 4. Setup two Wordpress installations
kubectl create ns client-a
kubectl create secret generic mysql-pass -n client-a --from-file=password=./password.txt
kubectl apply -f clienta-pv.yaml -n client-a
kubectl apply -f clienta.yaml

kubectl create ns client-b
kubectl create secret generic mysql-pass -n client-b --from-file=password=./password.txt
kubectl apply -f clientb-pv.yaml -n client-b
kubectl apply -f clientb.yaml

# 5. Set horizontal autoscaler 
kubectl autoscale deployment clienta -n client-a --cpu-percent=50 --min=1 --max=10
kubectl autoscale deployment clientb -n client-b --cpu-percent=50 --min=1 --max=10
