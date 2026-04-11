## INstall ansible 

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
``` 

## Requirements 
1. Install Ansible in your jenkins machine ( or local machine (WSL) , linux )

Jenkin Machine -> Worker 1 
                -> First GCP Instance 

## IaC , CaC 
### Infrastructure as Code 
    -> Write code to define the structure of your infrastructure 
    -> If you want to create a new infrastructure , just need to run your code 

> Ex. Terraform , Ansible
### Configuration as Code 
> Ansible, Chef, Puppet , .... 
    -> Ex: 
        - Install nginx, docker, docker compose, 
        - Nexus OSS , Jenkins , K8s cluster 
    -> With CaC , you can define your configujration or software installation like you write a code ! 
    -> Provisioning 



### Related to Ansible Key Words 
> Naming style : inventory.yaml , ini 
                    hosts.yaml , hosts.ini
Inventory : 
    - .yaml, .ini file 
    - configure about machines that ansible can manage 

Playbooks: 
    - yaml files defined tasks that you want to do on the machines 

*** 
### How to configure SSH for ansible 
```bash
ssh-keygen # on ansible ( Control Node )
# Copy id_rsa.pub to authorized_keys inside slave machines 

```
### Adhoc command 
```bash 
# adhoc command syntax 
ansible -i inventory.ini machine-name -m ping 
ansible -i inventory.ini group-name -m ping

# SSH for the inventory  
ansible -i inventory.ini localhost -m ping 
ansible -i inventory.ini dev -m ping 
ansible -i inventory.ini prod -m ping 
ansible -i inventory.ini all -m ping 


# run adhoc command module 
ansible -i inventory.ini all -m command -a "uptime"
ansible -i inventory.ini all -m apt -a "name=nginx state=present" # absent: remove 
ansible -i inventory.ini all -m apt -a "name=nginx state=present" --become # sudo 



# Justfile 
sudo snap install just --classic 
```

sudo systemctl status nfs-kernel-server

cat /etc/exports

for test test # df -h


## for testing if all machine connected success
pisethkhon888@jenkins-server:~$ cd /srv/nfs_shared/
pisethkhon888@jenkins-server:/srv/nfs_shared$ ls
pisethkhon888@jenkins-server:/srv/nfs_shared$ mkdir shared_date
pisethkhon888@jenkins-server:/srv/nfs_shared$ touch text.txt
pisethkhon888@jenkins-server:/srv/nfs_shared$ 

## check in worker01 or worker02

## for testing in worker01
pisethkhon888@worker-01 /m/nfs_shared> touch filefromworker1.txt
pisethkhon888@worker-01 /m/nfs_shared> ls
filefromworker1.txt  shared_date  text.txt
pisethkhon888@worker-01 /m/nfs_shared>

## check in local(jenkins_machine) or worker02

pisethkhon888@jenkins-server:/srv/nfs_shared$ ls
filefromworker1.txt  shared_date  text.txt
pisethkhon888@jenkins-server:/srv/nfs_shared$ 

pisethkhon888@worker-01 ~ [1]> cd /mnt/nfs_shared/
pisethkhon888@worker-01 /m/nfs_shared> ls
shared_date  text.txt
pisethkhon888@worker-01 /m/nfs_shared>



## this is file for connect
pisethkhon888@worker-02:~$ cat /etc/fstab
LABEL=cloudimg-rootfs   /        ext4   discard,errors=remount-ro       0 1
LABEL=UEFI      /boot/efi       vfat    umask=0077      0 1
10.148.0.2:/srv/nfs_shared /mnt/nfs_shared nfs defaults,_netdev 0 0
pisethkhon888@worker-02:~$
## NFS ( Network File System )
Distribute file storages 
(If we have 5 machines on the network , data will be store in those five machine simultanously )

NFS Server 
NFS Client 

> NFS Storage Class, Longhorn (by Rancher )
> Samba , ...


## check docker ps
docker logs -f spring_cont