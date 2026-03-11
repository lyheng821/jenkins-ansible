## NOTE 
>  Note for setting up the k8s clusters

- 3 masteres (8GB)
- 1 worker (4GB)


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
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
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
https://35.213.173.163:31327 

kubectl -n kubernetes-dashboard create token admin-user --duration=24h
# generate the token in order to access the dashboard with RBAC 
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

eyJhbGciOiJSUzI1NiIsImtpZCI6IlpFaVJOaVQyVGxLQXNLMWhkejJZLWpIZGNGNnVYWjlDdnlDd2xvOWlrZGcifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLnByby5jbHVzdGVyIl0sImV4cCI6MTc3MjYwOTQ2MywiaWF0IjoxNzcyNTIzMDYzLCJpc3MiOiJodHRwczovL2t1YmVybmV0ZXMuZGVmYXVsdC5zdmMucHJvLmNsdXN0ZXIiLCJqdGkiOiIwNWVhYWQ3Mi04ZWMyLTQzODctYmE3Mi1kOTFkMjQ2NDkxNWYiLCJrdWJlcm5ldGVzLmlvIjp7Im5hbWVzcGFjZSI6Imt1YmVybmV0ZXMtZGFzaGJvYXJkIiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImFkbWluLXVzZXIiLCJ1aWQiOiI1MmYwYjZmMy01NjY5LTQyNDItYjYwZS04MTVjMzE5ZjI0Y2EifX0sIm5iZiI6MTc3MjUyMzA2Mywic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmVybmV0ZXMtZGFzaGJvYXJkOmFkbWluLXVzZXIifQ.D_EhhxNFYpd1AobOHb6s9c4-jRw9xnZemEI0Q1j8T4c9MRX6ib3SgsqmuYxvAHyWm6KGhIxQui8-rO5yplfWLdG5O8E1-9Y8VTZGxuTCfEsTrGRvxqzfiu3hWurxAKfe-C0ld29KrvR8nW1AYvsmWUnJe_x_Kl1LvT0TULWwnbz0aeWXmOvsgrWhIug30MRbwXTw9zbvRNiGJnCgS0FdkcPoYvFe8YLCa-1rmiPavFj1A7nLBxZBEBwB1Z5hM_OptG6aToGgFUtX9UtXcqRQlOWsl3RYqhU1unDoDn8sRtaJ407n8vwfpGbCPOfGttLM_RCg1pvbkpmXclbOhgDgfA

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
- '--publish-status-address=10.170.0.10,10.170.0.11'
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
```