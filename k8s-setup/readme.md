## NOTE 
>  Note for setting up the k8s clusters

- 3 masteres (8GB)
- 1 worker (4GB)

## delete node 
```bash
kubectl drain node5 --ignore-daemonsets --delete-emptydir-data

នេះអាចអោយ pods reschedule នៅ worker node ផ្សេង

Node4 ចូល SchedulingDisabled

kubectl delete node node5

ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root --limit=worker02 cluster.yml
ansible-playbook -i inventory/sample/inventory.ini  --become --become-user=root --limit=node5  cluster.yml

```bash
## 1. Run the playbook to create 4,5 machines 
```bash 
# inside kubespray 
cd kubespray 
pip install -r requirements.txt 
```
- Edit the inventory file for our infrastructures , it's located in here 
- `kubespray/inventory/sample/inventory.ini`

2. Define what need to installed inside our clusters 
    `kubespray/inventory/sample/groups_vars/k3s_cluster/addson.yaml`
    Chnage the addons for include these in the cluster setup
    - k8s_dashboard:true 
    - helm :true 
    - agrocd :true 
    - metric_server:true 
    - certmanager :true 
    - nginx-ingress-controller:true 
+ after the update you can run the command to start the cluster 
```bash 
cd kubespray
# To setup your HA cluster 
ansible-playbook -b -v -i inventory/sample/inventory.ini \
    cluster.yml

# to delete or reset your cluster 
ansible-playbook -b -v -i inventory/sample/inventory.ini \
    reset.yml
```

## After successful installation 
```bash
sudo kubectl get node 
sudo kubectl get node -o wide 
sudo kubectl get pod -A

```

## Type kubectl command without sudo 
```bash
#option1
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#option 2
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## ISSUES
![alt text](image.png)


## Basic command
```bash
kubectl get node
kubectl get node -o wide 
kubectl get pod 
kubectl get pod -A
kubectl get all
ip a
```

### To run kubectl without having to type sudo 
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

```
### Configure Dashboard of K8s
> addon.yaml -> enabled kubenete-dashboard 


```bash
# to show all the services inside our clusters 
kubectl get all -A

# to access our dashboard , we will use nodeport for temp access 
kubectl get svc -n kube-system
kubectl edit service/kubernetes-dashboard -n kube-system
# change type: ClusterIP -> NodePort
kubectl get svc -n kube-system # find svc of dashboard with port 
# to access our kubernetes dasboard 
https://34.126.162.82:32615/#/login

kubectl -n kubernetes-dashboard create token admin-user --duration=24h
# generate the token in order to access the dashboard with RBAC 

////////////////////////////////////////////////////////////////
# if error not not found name space 
pisethkhon888@node1 ~ (master)> kubectl -n kubernetes-dashboard create token admin-user
error: failed to create token: namespaces "kubernetes-dashboard" not found
pisethkhon888@node1 ~ (master) [1]> kubectl -n kube-system create token admin-user --duration=24h
error: failed to create token: serviceaccounts "admin-user" not found
pisethkhon888@node1 ~ (master) [1]> kubectl create serviceaccount admin-user -n kube-system
serviceaccount/admin-user created
pisethkhon888@node1 ~ (master)> kubectl create clusterrolebinding admin-user \
                                    --clusterrole=cluster-admin \
                                    --serviceaccount=kube-system:admin-user
clusterrolebinding.rbac.authorization.k8s.io/admin-user created
pisethkhon888@node1 ~ (master)> kubectl -n kube-system create token admin-user --duration=24h


////////////////////////////////////////////////////////////////
```
* create serviceaccount and clusterrole to create the token 
```yaml
# k3s-svcacc-clusterrole.yaml
# /home/pisethkhon888/jenkins-ansible-lesson/k8s-setup/k8s-basic/k8s-dashboard/k8s-svcacc-clusterrolebinding.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
 name: admin-user
 namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
 name: admin-user
roleRef:
 apiGroup: rbac.authorization.k8s.io
 kind: ClusterRole
 name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
```
kubectl -n kubernetes-dashboard create token admin-user --duration=24h


### 1.POD 
```bash
kubectl create ns namespace-demo 
kubectl apply -f pod.yaml
kubectl replace -f pod.yaml 
# default namespace , type like this 
kubectl delete pod/name 

# if namespac eis something else 
kubectl delete pod/name -n namedspace
kubectl get pod 
kubectl logs pod/pod-name 
kubectl get pod -o wide 

# to see the full confnig in yaml format 
kubectl get pod/name -o yaml 



# imperative command
kubectl run my-nginx --image=nginx:1.22.1 --restart=Never 

# one container per pod 
# to login to your pod ( if you have only one container )
kubectl exec -it pod-name -- bash
# to login to container of your pod (multiple container )
kubectl exec -it pod-name -c container-name -- bash
kubectl describe pod/pod-name # describe more info of pods such as name, node selector , event 
```
### 2. Replicaset 
Used for maintaining a specific number of pods 

```bash
kubectl get rs 
kubectl get replicaset 
watch kubectl get pod 

kubectl api-resources #networking.k8s.io/v1
```


### 3. Deployment
```bash 
kubectl get deployment 
kubectl get deploy 


```
### check cluster issuer 
```bash
kubectl get clusterissuer -n cert-manager
kubectl get ingress
kubectl get cr

kubectl describe ingress/earthdx-ingress
kubectl logs cr/nginx-k8s-demo-tls-2 

```
```bash
kubectl edit svc ingress-nginx -n ingress-nginx
kubectl get svc -n ingress-nginx
```

### if ingress and certificate false  myabe is don't know ip not 
pisethkhon888@node1 ~/j/k/k/deployment (master)> kubectl get pod -o wide
NAME                           READY   STATUS    RESTARTS      AGE     IP              NODE    NOMINATED NODE   READINESS GATES
cm-acme-http-solver-t7m8v      1/1     Running   0             2m30s   10.233.97.183   node5   <none>           <none>
earthdx-app-64c56fc5d8-kxpw5   1/1     Running   0             2m35s   10.233.74.119   node4   <none>           <none>
nginx-app-5df755f6b9-5lt69     1/1     Running   1 (90m ago)   10h     10.233.97.172   node5   <none>           <none>
pisethkhon888@node1 ~/j/k/k/deployment (master)> kubectl get cr
NAME                  APPROVED   DENIED   READY   ISSUER             REQUESTOR                                         AGE
eartdx-secret-tls-1   True                False   letsencrypt-prod   system:serviceaccount:cert-manager:cert-manager   2m45s
pisethkhon888@node1 ~/j/k/k/deployment (master) [1]> kubectl get ingress
NAME                        CLASS    HOSTS                                ADDRESS   PORTS     AGE
cm-acme-http-solver-n8ppp   <none>   earthdx-k8s.sethnexusonline.online             80        3m2s
earthdx-ingress             nginx    earthdx-k8s.sethnexusonline.online             80, 443   3m7s

```bash
kubectl edit svc ingress-nginx -n ingress-nginx 
Change:

type: LoadBalancer

To:

type: NodePort

Save and exit.

Then check:

kubectl get svc -n ingress-nginx
```


```bash
wath kubectl get pod
kubectl get pod -w
kubectl get pod -watch

kubectl describe svc/name-service
```

## Rollout and rollback 
```bash
# kubectl apply -f file.yaml --record

kubectl rollout status deployment/nginx-app-blue
# to see the revision number 
kubectl rollout history deployment/nginx-app-blue

# just like you Ctrol+Z
kubectl rollout undo deployment/nginx-app-blue
kubectl rollout undo deployment/nginx-app-blue --to-revision=2

```


## TAINT NODES 

### Taint the node 
 To prevent the master node in a Kubernetes cluster from running any services
```bash
kubectl taint nodes node2 node-role.kubernetes.io/master=:NoSchedule

# to check the tains status of the node 
kubectl get nodes -o json | jq '.items[] | {name: .metadata.name, taints: .spec.taints}'
```

### Untaint the node 
- If you later decide to allow pods to run on the master node, you can remove the taint using the following command:
```bash
kubectl taint nodes node2 node-role.kubernetes.io/master-
kubectl get node # Get nodes name
```
```bash
kubectl taint nodes node4 service=disabled:NoSchedule

#*service=disabled (Any key=value pair that you want notice or comment)
kubectl taint node node4 service-
```


## NODE AFFINITY AND NODE SELECTOR 
> we select node to run instead ! 
```bash
kubectl get nodes --show-labels | grep node4
kubectl get nodes --show-labels | grep disktype

```
```bash
kubectl get ingress
kubectl get cr 
kubectl get certificaterequest 
kubec tl get cert 
```


## Update nginx configuration for our clusters 

1. Access your dashboard first 
2. Edit the ingress configurations 


```bash 
F0809 07:03:09.996013       8 main.go:64] flags --publish-service and --publish-status-address are mutually exclusive
```

```bash
- '--watch-ingress-without-class=true'
- '--publish-status-address=10.148.0.2,10.148.0.15,10.148.0.16,10.170.0.10,10.170.0.11'
- '--publish-status-address=10.148.0.2,10.148.0.27,10.148.0.28,10.148.0.30'
#- '--publish-service=ingress-nginx/ingress-nginx' #need close line this 
# comment the --public-service part 
```

## on the resource restricting you can allow the master 
```bash
# only if you are working with k3s
kubectl taint nodes node1 \
    node-role.kubernetes.io/master:NoSchedule-

# the control-plane role 
kubectl taint nodes node1 \
    node-role.kubernetes.io/control-plane:NoSchedule-

# To taint the node of the control-plane role 
kubectl taint nodes node1 \
    node-role.kubernetes.io/control-plane:NoSchedule


```
# finding the right FQDNS 
```bash
more /etc/resolve.conf 
# check your cluster name and FQDNS config there 
kubectl run -it dns-test --rm --restart=Never --image=busybox:1.36 sh

#If you don't see a command prompt, try pressing enter.
nslookup mynginx-service.default.svc.mycluster

#Server:         169.254.25.10
#Address:        169.254.25.10:53
#Name:   mynginx-service.default.svc.mycluster
#Address: 10.233.58.50

# to get the clusterip for the nameserver of core-dns
kubectl get svc -n kube-system  | grep "coredns"
```


#  Note 
- Docker Volume 
- Storage Class 
- EmptyDir 
- hostPath
- ConfigMap 
- Secret 
- FQDNS  
- NFS 
- Storage Class 
- Dynamic Provision / Static 
- PVC , PV 
- Policies .... 

# for  hostPath 
```bash
kubectl exec -it pod/spring-app-58778db48f-2b2hs -- bash


pisethkhon888@node1 ~/j/k/p/hostpath (master) [1]> kubectl exec -it pod/spr
ing-app-58778db48f-2b2hs -- bash
bash-4.4# ls
app.jar  src
bash-4.4# cd src/
bash-4.4# ls
main
bash-4.4# cd main/resources/images
bash-4.4# ls

bash-4.4# 
```


# check config map
```bash


kubectl get configmap
10.233.74.85

kubectl get endpoints postgres-svc-headless
kubectl describe svc postgres-svc-headless
## Note for configmap 
Inside your cluster , you can connect your service with either clusterip:port , or FQDNS 
* Using clusterip 
![alt text](image.png)

* **FQDN- Fully Qualified Domain Name**
```bash
more /etc/resolve.conf 
sudo vim /etc/resolv.conf 

<service-name>.<ns>.svc.<cluster-name>
kubectl run -it dns-test --rm --restart=Never --image=busybox:1.36 sh
# inside the container , you can test to see if DNS is resolve or not 
kubectl get pod -A | grep "coredns"
kubectl get svc -n kube-system
# coredns                     ClusterIP   10.233.0.3      <none>        53/UDP,53/TCP,9153/TCP   2d15h

# change nameserver for testing config map



# change defualt nameserver ......
#  to nameserver  10.233.0.3

nslookup FQDNS
postgres-svc-headless.default.svc.mycluster
postgres-svc-headless.default.svc.cluster.local
postgres-svc-headless.default.svc.pro.cluster
postgres-svc-headless.default.svc.cluster.prod 
# mynginx-service.default.svc.mycluster
mynginx-service.default.svc.pro.cluster


kubectl edit configmap/postgress-configmap
```
```



## NOTE secret-demo


### Using imperative command to create the secret 
```bash
kubectl create secret generic \
    postgres-secret \
    --from-literal=POSTGRES_PASSWORD=password123
```


## Workign with secret for private docker registry 
```bash 
# Step1 : push image to private registry (nexusoss, ghcr.io )
docker images 
docker tag nginx:latest ghcr.io/username/image:tag 

docker logout ghcr.io #if you want to add new account

docker login ghcr.io 
# username 
# password: token (write:package )
# tokens= YOUR_TOKEN_HERE

kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<gh-token-read-package> \
  --docker-email=<github-email>


````





############### 
25. PV , PVC and Helm Part I

## NOTE for PVC and PV 
> helm will be used in this project as well 
- PV ( Persistence Volume ) 
    Think of it as a block of storage that able to store thing 

- PVC ( Persistence Volume Claims )
    think of it as a request to use specific PV 
> Normally PVC has to be bound with PV
> `1:1` relationship  

#### There are three diffferent type of access mode 
- RWO -> Read Write Once 
- ROX -> ReadOnly Many 
- RWX -> ReadWrite Many 

#### There are three `reclaim policies` 
- Retain -> Delete PVC, PV will remain 
- Delete -> Delete PVC, PV also delete 
- Recycle -> repreciated, keep pv  but format all data 


#### Provisioning ( there are two type of provisions )
- **Static Provisioning** : 
    do create pv, and pvc by yourself 
- **Dynamic Provisioning** :
     only need to create pvc, pv will created auto

```bash
helm version


alias k=kubectl 
alias h=helm


# to see the event or issue with the containercreating state 
kubectl get pod 
kubectl describe pod <pod-name> 
# create folder from the nfs path 
mkdir /srv/nfs_shared/spring_images

# ingress, nodePort type service 
kubectl port-forward svc/spring-uploader-svc  30003:80
```


#### Dynamic Provisioning 
-> PV , PVC 
-> PVC bind with PV 

Automatically create PV, from the PVC config 
```bash 
helm repo list 


# adding repo 
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/


# create kubernetes artifacts / manifests
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=10.148.0.2 \
    --set nfs.path=/srv/nfs_shared

kubectl get storageclass # nfs-client 
kubectl get pv
kubectl get pvc 
```


<!-- helms lesson ########################## -->

## NOte 
Helm -> package management for kubernetes 

Keyword for helms 
1. Chart 
2. Repository 
3. Release 

```bash
# first chart with helm 

helm create nginx-chart 
# to test your chart syntax (validation)
helm lint nginx-chart 

# to render your chart ( see the configuration after inject the value file )
helm template nginx-chart 
helm template nginx-chart --values prod-value.yaml

# to release your chart (deploy your app )
helm install nginx-release nginx-chart 
helm uninstall nginx-release 
# upgrade the old release 
helm upgrade nginx-release nginx-chart 
# if old release exist, we upgrade 
# if not we create a new one 
helm upgrade nginx-release nginx-chart --install 
helm list # show all the release 
helm list -n mesh-demo # n = namespace 
helm repo list 


# working nginx-release 
helm history nginx-release 
# if we want to revert back to version 
helm rollback nginx-release 1
# running test from 
helm test nginx-release 

# TODO
# package -> upload to registry 
# pull from registry and run it in the cluster
# create chart from scatch -> to under go template  
```

Syntax ( similar to programming is called GoTemplate)
- Jinja -> python related , {% %}, ansible
- GoTemplate -> go related , {{ }}, helm

#### Practice#01
- Use helm to create chart for reactjs 
- Reactjs -> domain , https  

```bash
# outside folder 
helm repo list

helm install planting-k8s nginx-chart --values nginx-chart/stag-values.yaml

helm install planting-k8s nginx-chart --values nginx-chart/prod-values.yaml
helm uninstall planting-k8s 
m uninstall planting-k8s -n default-name #uninstall namespace
```


Requirement: 
1. ClustterIssuer 
- letsencrypt-stagging
- letsencrypt-prod

<!-- ############################################ -->

#k8s-related/helms/custom-chart/readme.md
## NOTE 
command for working with customchart 

```bash
# render the chart from value file 
helm template custom-chart  --values custom-chart/values.yaml

helm template custom-chart  --values custom-chart/stag-values.yaml

helm template custom-chart  --values custom-chart/stag-values.yaml -debug
```



<!-- argocd -->
## NOTE 
> Working with argocd inside the k3s cluster 


1. Adding domain name for our argocd service 
```bash
 kubectl get clusterissuer 
 # letsencrypt-prod -> ns= default 

 kubectl get svc -A | grep "argocd-server"
 # get only service inside the argocd namespace 
 kubectl get svc -n argocd

 kubectl get app 
 kubectl get app -A

# username of argo is: admin 
# get your initial password 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

```

## Working with webhook

```bash
123mysecretdemo

kubectl edit secret argocd-secret -n argocd
kubectl describe secret argocd-secret -n argocd


echo -n "123mysecretdemo" | base64 

data: 
    webhook.github.secret: <your-base64-value> 
    webhook.github.secret: ...................
    
```
<!-- end of argocd -->


## NOTE for working with kubernetes dashboard 

```bash 
kubectl get all -n kube-system


# make sure to change from NodePort to ClusterIP 
kubectl get svc -n kube-system 
kubectl edit svc kubernetes-dashboard -n kube-system
# \type

k8s-dashboard.devnerd.store 
# test DNS -> IP 
nslookup k8s-dashboard.devnerd.store



kubectl get ingress -n kube-system
kubectl get cert -n kube-system # look for Ready State 
```


## IMPORTANT NOTE 
- If you removed the taint (untaint) for all the masters 
you can use master IP for the dns record 
- If not, use IP of workers instead


***
- Working with Rancher 


**************
# stateful-demo
```bash
kubectl get statefulset -o wide
```

**************


. add repo of the monitoring helm chart
```bash
helm repo add Prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# how do we install this in the specific namespace
helm install monitor-stack-release \
     Prometheus-community/kube-prometheus-stack

# To esure that everything is running
kubectl --namespace default \
	get pods \
	-l "release=monitor-stack-release"


kubectl get service | grep "monitor"
kubectl get secret -A | grep grafana
default        monitor-stack-release-grafana                                      
# run this to get password for grafana             
kubectl get secret monitor-stack-release-grafana -n default -o jsonpath="{.data.admin-password}" | base64 --decode

## Note 

1. Add repo of the monitoring helm chart 
```bash 
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# how do we install this in the specific namespace 
helm install monitor-stack-release \
    prometheus-community/kube-prometheus-stack


# To esure that everything is running 
kubectl --namespace default \
    get pods \
    -l "release=monitor-stack-release"
```

### Configure the domain name for the prometheus and grafana 


### Configute notification channel for the alert to fired 


```bash
# 1. Run commmand i order to get the orignal value 
helm show values prometheus-community/kube-prometheus-stack > values.yaml
# 2. After we update the value file , we can upgrade helm chart 
helm upgrade \
    monitor-stack-release \
    Prometheus-community/kube-prometheus-stack \
    -f values.yaml \
    -n default
```
