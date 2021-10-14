Kubernetes Security Best Practices - Ian Lewis, Google
https://www.youtube.com/watch?v=wqsUfvRyYpw



### Section 2

### 7. Practice - Configure "gcloud" command
#### Create instance From GUI
Virtual machines => VM instances => Create Instance
```
VM:
 name: cks-master | cks-worker
 Region: asia-northeast1(Tokyo) any near you
 Machine: e2-medium(2vCPU,4GB)
 Boot Disk: Ubuntu 18.04LTS(50GB)
```
#### Create instance From CUI
```sh
# CREATE cks-master VM using gcloud command
# not necessary if created using the browser interface
gcloud compute instances create cks-master --zone=europe-west3-c \
--machine-type=e2-medium \
--image=ubuntu-1804-bionic-v20201014 \
--image-project=ubuntu-os-cloud \
--boot-disk-size=50GB

# CREATE cks-worker VM using gcloud command
# not necessary if created using the browser interface
gcloud compute instances create cks-worker --zone=europe-west3-c \
--machine-type=e2-medium \
--image=ubuntu-1804-bionic-v20201014 \
--image-project=ubuntu-os-cloud \
--boot-disk-size=50GB
```

#### Login to instance
```sh
gcloud projects list
gcloud config set project PROJECT_ID
gcloud config get-value project
gcloud compute ssh cks-master
gcloud compute ssh cks-worker
```


#### cks-master

sudo -i
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_master.sh)


#### cks-worker
sudo -i
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/latest/install_worker.sh)


#### add worker to Cluster
```
run the printed kubeadm-join-command from the master on the worker
```
#### 2-9 firewall rules for NodePorts
gcloud compute firewall-rules create nodeports --allow tcp:30000-40000

#### 10.Notice
Always to stop Instances to save credits
```
# start instance
gcloud compute instances start cks-master
gcloud compute instances start cks-worker

# access instance
gcloud compute ssh cks-master
gcloud compute ssh cks-worker

# stop instance
gcloud compute instances stop cks-master
gcloud compute instances stop cks-worker
```


### Section 3

#### 12 Intro

![Archtecture](images/Section3-12_Intro.PNG)



![PKI and CA](images/Section3-12_Intro_PKI_CA.PNG)

![PKI and CA2](images/Section3-12_Intro_PKI_CA_2.PNG)

![PKI](images/Section3-12_Intro_PKI_CA_3.PNG)

#### 13 Practice

![K8s certificates](images/Section3-13_Practice_k8s_certificate.PNG)

cd /etc/kubernetes/pki/

ll

```shell
total 68
drwxr-xr-x 3 root root 4096 Feb 12 21:11 ./
drwxr-xr-x 4 root root 4096 Feb 12 21:11 ../
-rw-r--r-- 1 root root 1135 Feb 12 21:11 apiserver-etcd-client.crt
-rw------- 1 root root 1675 Feb 12 21:11 apiserver-etcd-client.key
-rw-r--r-- 1 root root 1143 Feb 12 21:11 apiserver-kubelet-client.crt
-rw------- 1 root root 1679 Feb 12 21:11 apiserver-kubelet-client.key
-rw-r--r-- 1 root root 1269 Feb 12 21:11 apiserver.crt
-rw------- 1 root root 1675 Feb 12 21:11 apiserver.key
-rw-r--r-- 1 root root 1066 Feb 12 21:11 ca.crt
-rw------- 1 root root 1679 Feb 12 21:11 ca.key
drwxr-xr-x 2 root root 4096 Feb 12 21:11 etcd/
-rw-r--r-- 1 root root 1078 Feb 12 21:11 front-proxy-ca.crt
-rw------- 1 root root 1679 Feb 12 21:11 front-proxy-ca.key
-rw-r--r-- 1 root root 1103 Feb 12 21:11 front-proxy-client.crt
-rw------- 1 root root 1675 Feb 12 21:11 front-proxy-client.key
-rw------- 1 root root 1679 Feb 12 21:11 sa.key
-rw------- 1 root root  451 Feb 12 21:11 sa.pub
```

##### 4.etcd

ll etcd/

```java
total 40
drwxr-xr-x 2 root root 4096 Feb 12 21:11 ./
drwxr-xr-x 3 root root 4096 Feb 12 21:11 ../
-rw-r--r-- 1 root root 1058 Feb 12 21:11 ca.crt
-rw------- 1 root root 1675 Feb 12 21:11 ca.key
-rw-r--r-- 1 root root 1139 Feb 12 21:11 healthcheck-client.crt
-rw------- 1 root root 1679 Feb 12 21:11 healthcheck-client.key
-rw-r--r-- 1 root root 1184 Feb 12 21:11 peer.crt
-rw------- 1 root root 1675 Feb 12 21:11 peer.key
-rw-r--r-- 1 root root 1184 Feb 12 21:11 server.crt
-rw------- 1 root root 1675 Feb 12 21:11 server.key
```

##### 6. scheduler

cat /etc/kubernetes/scheduler.conf

##### 7. controller manager

cat /etc/kubernetes/controller-manager.conf

##### 8. Kubelet api

cat /etc/kubernetes/kubelet.conf

##### 9. kubeclet pki

cd /var/lib/kubelet/pki

ll

```java
total 20
drwxr-xr-x 2 root root 4096 Feb 12 21:11 ./
drwxr-xr-x 8 root root 4096 Feb 12 21:11 ../
-rw------- 1 root root 2810 Feb 12 21:11 kubelet-client-2021-02-12-21-11-36.pem
lrwxrwxrwx 1 root root   59 Feb 12 21:11 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2021-02-12-21-11-36.pem
-rw-r--r-- 1 root root 2266 Feb 12 21:11 kubelet.crt
-rw------- 1 root root 1675 Feb 12 21:11 kubelet.key
```
#### 14.Recap
All You Need to Know About Certificates in Kubernetes
https://www.youtube.com/watch?v=gXz4cq3PKdg

Kubernetes Components
https://kubernetes.io/docs/concepts/overview/components

PKI certificates and requirements
https://kubernetes.io/docs/setup/best-practices/certificates



### Section 4
##### 15 Intro

- Containers and Images

![Containers and Images](images/Section4-15_Intro_ConatinerAndImage.PNG)

Containers

![Containers](images/Section4-15_Intro_Container.PNG)

- Namespaces and cgroups

Kernel vs User Space

![Kernel vs User Space](images/Section4-15_Intro_KernelVSUserSpace.PNG)

Technical Overview: Containers and system calls

![Technical Overview: Containers and system calls](images/Section4-15_Intro_TechnicalOverview.PNG)

Containers and Docker

![Containers and Docker](images/Section4-15_Intro_ContainersAndDocker.PNG)

Containers and Docker 2

![Containers and Docker](images/Section4-15_Intro_ContainersAndDocker2.PNG)

Linux Kernel Namespace PID

![Linux Kernel Namespace PID](images/Section4-15_LinuxKernelNamespace.png)



Linux Kernel Namespace Mount

![Linux Kernel Namespace Mount](images/Section4-15_LinuxKernelNamespaceMount.png)

Linux Kernel Namespace Network

![Linux Kernel Namespace Mount](images/Section4-15_LinuxKernelNamespaceNetwork.png)

Linux Kernel Namespace User

![Linux Kernel Namespace User](images/Section4-15_LinuxKernelNamespace User.png)

##### Linux Kernel Isolation

![Linux Kernel Isolation](images/Section4-15_LinuxKernelIsolation.png)











### Section 4:Foundation-Containers under the hood

#### 16. Practice The PID Namespace

###### Docker isolation in action

1.run a container in different pid namespace

```sh
#create a container
docker run --name c1 -d ubuntu sh -c 'sleep 1d'

#execute a command in a running container
docker exec c1 ps aux
--------------------------------------------------------------------------------
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   2608   544 ?        Ss   23:29   0:00 sh -c sleep 1d
root         6  0.0  0.0   2508   528 ?        S    23:29   0:00 sleep 1d
root         7  0.0  0.0   5896  2812 ?        Rs   23:33   0:00 ps aux
--------------------------------------------------------------------------------
docker run --name c2 -d ubuntu sh -c 'sleep 999d'

docker exec c2 ps aux
--------------------------------------------------------------------------------
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.4  0.0   2608   544 ?        Ss   23:35   0:00 sh -c sleep 999d
root         6  0.0  0.0   2508   536 ?        S    23:35   0:00 sleep 999d
root         7  0.0  0.0   5896  2832 ?        Rs   23:36   0:00 ps aux
--------------------------------------------------------------------------------

ps aux  | grep sleep
```

2.run a container in same pid namespace 

```sh
docker rm c2 --force
#create a container which with same namespace
docker run --name c2 --pid=container:c1 -d ubuntu sh -c 'sleep 999d'
docker exec c2 ps aux
------------------------------------------------------------------------------------------
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   2608   544 ?        Ss   23:29   0:00 sh -c sleep 1d
root         6  0.0  0.0   2508   528 ?        S    23:29   0:00 sleep 1d
root        12  0.0  0.0   2608   556 ?        Ss   23:38   0:00 sh -c sleep 999d
root        17  0.0  0.0   2508   528 ?        S    23:38   0:00 sleep 999d
root        18  0.0  0.0   5896  2760 ?        Rs   23:39   0:00 ps aux
------------------------------------------------------------------------------------------
```


#### 17. Recap
 What have containers done for you lately?
https://www.youtube.com/watch?v=MHv6cWjvQjM

- Containers
- Virtual Machines
- Namespaces
- Cgroups
- Docker

### Section 5: Cluster Setup - Network Policies

#### 18. Cluster Reset

- NetworkPolicies
- Default Deny
- Scenarios

#### 19 Introduction 2

- NetworkPolicies
  - Firewall Rules in Kubernetes
  - Implemented by the Network Plugins CNI(Calico/Weave)
  - Namespace level
  - Restrict the Ingress and/or Egress for a group of Pods based on certain rules and conditions
  - Without NetworkPolicies
    - By default every pod can access every pod
    - Pods are not isolated
  - Parameters
    - PodSelector:from pods
      - policyType: Ingress
    - namespaceSelector: from namespaces
      - policyType:Ingress
    - ipBlock: traffice to/from ip range(10.0.0.0/24)
      - policyType:Egress
      - policyType:Ingress

#### 20 Introduction 2

##### NetworkPolicies 1

![NetworkPolicies](images/Section5 Cluster Setup NetworkPolicies/Screenshot_1.png)

##### Multiple NetworkPolicies 

![Multiple NetworkPolicies](images/Section5 Cluster Setup NetworkPolicies/Screenshot_2.png)

##### Multiple NetworkPolicies  examples

![Multiple NetworkPolicies examples](images/Section5 Cluster Setup NetworkPolicies/Screenshot_3.png)

#### 21 Practice Default Deny

##### Default Deny

![Default Deny](images/Section5 Cluster Setup NetworkPolicies/Screenshot_4.png)

```sh
sudo -i
k get node

k run frontend --image=nginx
k run backend --image=nginx

k expose pod frontend --port 80
k expose pod backend --port 80

k get pod,svc
------------------------------------------------------------------------------------------------------
NAME           READY   STATUS    RESTARTS   AGE
pod/backend    1/1     Running   0          45s
pod/frontend   1/1     Running   0          2m46s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/backend      ClusterIP   10.111.27.213   <none>        80/TCP    34s
service/frontend     ClusterIP   10.97.79.94     <none>        80/TCP    111s
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP   3d1h
------------------------------------------------------------------------------------------------------

k exec frontend -- curl backend
------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0   119k      0 --:--:-- --:--:-- --:--:--  119k
------------------------------------------------------------------------------------------------------
k exec backend -- curl frontend
------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0  87428      0 --:--:-- --:--:-- --:--:-- 87428
------------------------------------------------------------------------------------------------------
vim default-deny.yaml
------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
------------------------------------------------------------------------------------------------------
example https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource

k -f default-deny.yaml create
#can't from pod to pod
k exec frontend -- curl backend
------------------------------------------------------------------------------------------------------
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
------------------------------------------------------------------------------------------------------
k exec backend -- curl frontend
------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0
------------------------------------------------------------------------------------------------------
```

#### 21 Practice Frontend to Backend traffic

![Frontend to Backend traffic](images/Section5 Cluster Setup NetworkPolicies/Screenshot_5.png)

```sh
vim frontend.yaml
-----------------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: frontend
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          run: backend
-----------------------------------------------------------------------------------------------------------------
example https://kubernetes.io/docs/concepts/services-networking/network-policies/#networkpolicy-resource

k -f frontend.yaml
k exec frontend -- curl backend
-----------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
-----------------------------------------------------------------------------------------------------------------
cp frontend.yaml backend.yaml
vim backend.yaml
-----------------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: frontend
-----------------------------------------------------------------------------------------------------------------
k -f backend.yaml create


k exec frontend -- curl backend
-----------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:03 --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
-----------------------------------------------------------------------------------------------------------------


k get pod --show-labels -o wide
-----------------------------------------------------------------------------------------------------------------
NAME       READY   STATUS    RESTARTS   AGE   IP          NODE         NOMINATED NODE   READINESS GATES   LABELS
backend    1/1     Running   1          12h   10.44.0.2   cks-worker   <none>           <none>            run=backend
frontend   1/1     Running   1          12h   10.44.0.1   cks-worker   <none>           <none>            run=frontend
-----------------------------------------------------------------------------------------------------------------

# access backend's ip
 k exec frontend -- curl 10.44.0.2
-----------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   119k      0 --:--:-- --:--:-- --:--:--  119k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
-----------------------------------------------------------------------------------------------------------------
```





Allow DNS resolution

![Allow DNS resolution](images/Section5 Cluster Setup NetworkPolicies/Screenshot_6.png)

```sh
#because frontend -> backend is ok,but not network policy for backend -> frontend
k exec backend -- curl 10.44.0.1
---------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0
---------------------------------------------------------------------------------  
```



#### 23. Practice Backend to Database traffic

source:https://github.com/killer-sh/cks-course-environment/tree/master/course-content/cluster-setup/network-policies/frontend-backend-database

##### Network Policy

![Network Policy](images/Section5 Cluster Setup NetworkPolicies/Screenshot_7.png)

```sh
#create new namespace
k create ns cassandra


k edit ns cassandra
------------------------------------------------------------------------
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2021-02-16T11:49:08Z"
  name: cassandra
  resourceVersion: "245776"
  uid: 1276af52-f926-417c-ad4b-624a4583cd8b
  labels:
    ns: cassandra
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
------------------------------------------------------------------------

# create cassandra pod in namespace cassandra
k -n cassandra run cassandra --image=nginx

k -n cassandra get pod -o wide
--------------------------------------------------------------------------------------------------------------------------------
NAME        READY   STATUS    RESTARTS   AGE   IP          NODE         NOMINATED NODE   READINESS GATES
cassandra   1/1     Running   0          60s   10.44.0.3   cks-worker   <none>           <none>
--------------------------------------------------------------------------------------------------------------------------------

k exec backend -- curl 10.44.0.3
--------------------------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:11 --:--:--     0
--------------------------------------------------------------------------------------------------------------------------------


# create egress for backend
vim backend.yaml
--------------------------------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: frontend
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          ns: cassandra
--------------------------------------------------------------------------------------------------------------------------------



 k exec backend -- curl 10.44.0.3
-------------------------------------------------------------------------------------------------------------------------------- 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
--------------------------------------------------------------------------------------------------------------------------------


vim cassandra-deny.yaml
--------------------------------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cassandra-deny
  namespace: cassandra
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
--------------------------------------------------------------------------------------------------------------------------------
# create network policy deny ingress and egress from cassandra
k -f cassandra-deny.yaml create

k exec backend -- curl 10.44.0.3
--------------------------------------------------------------------------------------------------------------------------------
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0^
--------------------------------------------------------------------------------------------------------------------------------


cp backend.yaml cassandra.yaml
k -f cassandra.yaml create
--------------------------------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cassandra
  namespace: cassandra
spec:
  podSelector:
    matchLabels:
      run: cassandra
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          ns: default
--------------------------------------------------------------------------------------------------------------------------------


k -f cassandra.yaml create

k exec backend -- curl 10.44.0.3
--------------------------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
--------------------------------------------------------------------------------------------------------------------------------

k edit ns default 
--------------------------------------------------------------------------------------------------------------------------------
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2021-02-12T21:11:49Z"
  name: default
  resourceVersion: "248694"
  selfLink: /api/v1/namespaces/default
  uid: d38ab06a-c83c-447b-b5e3-928aaf37a492
  labels:
    ns: default
spec:
  finalizers:
  - kubernetes
status:
  phase: Active
--------------------------------------------------------------------------------------------------------------------------------


k exec backend -- curl 10.44.0.3
--------------------------------------------------------------------------------------------------------------------------------
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0   597k      0 --:--:-- --:--:-- --:--:--  597k
--------------------------------------------------------------------------------------------------------------------------------
```





#### 24. Recap

https://kubernetes.io/docs/concepts/services-networking/network-policies

![24 Recap](images/Section5 Cluster Setup NetworkPolicies/Screenshot_8.png)





#### Section 6: Cluster Setup - GUI Elements

##### GUI Elements

![GUI Elements](images/Section 6 Cluster Setup GUI Elements/Screenshot_1.png)

##### GUI Elements and the Dashboard

![GUI Elements and the Dashboard](images/Section 6 Cluster Setup GUI Elements/Screenshot_1.png)

##### Kubernetes has some demerits

![Kubernetes has some demerits](images/Section 6 Cluster Setup GUI Elements/Screenshot_3.png)



##### Kubernetes proxy

![Kubernetes proxy](images/Section 6 Cluster Setup GUI Elements/Screenshot_4.png)



![Kubernetes proxy 2](images/Section 6 Cluster Setup GUI Elements/Screenshot_5.png)



![Kubernetes port-forward](images/Section 6 Cluster Setup GUI Elements/Screenshot_6.png)



![Kubernetes port-forward 2](images/Section 6 Cluster Setup GUI Elements/Screenshot_7.png)



Ingress

![Ingress](images/Section 6 Cluster Setup GUI Elements/Screenshot_8.png)

#### 27. Practice - Install Dashboard

##### Install and access the Dashboard



https://github.com/kubernetes/dashboard

```shell
# install kubernetes dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml

#
k get ns
k -n kubernetes-dashboard get pod,svc
```



##### 28. Practice Outside Insecure Access

##### Dashboard available externally

![Dashboard available externally](images/Section 6 Cluster Setup GUI Elements/Screenshot_9.png)

```sh
k -n kubernetes-dashboard get pod,svc
# edit deploy
k -n kubernetes-dashboard edit deploy kubernetes-dashboard
# https://github.com/kubernetes/dashboard/blob/master/docs/common/dashboard-arguments.md

```

      # before
      - args:
        - --auto-generate-certificates
        - --namespace=kubernetes-dashboard
        image: kubernetesui/dashboard:v2.1.0
        imagePullPolicy: Always
        livenessProbe:
        failureThreshold: 3
        httpGet:
        path: /
        port: 8443
        scheme: HTTPS
        
      #after
      - args:
        - --namespace=kubernetes-dashboard
        - --insecure-port=9090
        image: kubernetesui/dashboard:v2.1.0
        imagePullPolicy: Always
        livenessProbe:
        failureThreshold: 3
        httpGet:
        path: /
        port: 9090
        scheme: HTTP

```sh
# edit svc
k -n kubernetes-dashboard edit svc kubernetes-dashboard
```

```sh
#before
  ports:
  - port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: ClusterIP
```



```sh
#after
  ports:
  - port: 9090
    protocol: TCP
    targetPort: 9090
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: NodePort


```



```sh
k -n kubernetes-dashboard get svc
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
dashboard-metrics-scraper   ClusterIP   10.99.15.60     <none>        8000/TCP         12h
kubernetes-dashboard        NodePort    10.101.88.186   <none>        9090:30639/TCP   12h
```

###### can't access because the access control

http://$exteralIP:30639/#/workloads?namespace=default

http://$exteralIP:30639/#/workloads?namespace=default

##### 28. Practice RBAC for the Dashboard

![RBAC for the Dashboard](images/Section 6 Cluster Setup GUI Elements/Screenshot_10.png)

```sh
k -n kubernetes-dashboard get sa
-----------------------------------------------------
NAME                   SECRETS   AGE
default                1         12h
kubernetes-dashboard   1         12h
-----------------------------------------------------
k get clusterroles | grep view

k -n kubernetes-dashboard create rolebinding insecure --serviceaccount kubernetes-dashboard:kubernetes-dashboard --clusterrole view -o yaml --dry-run=client 
-----------------------------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: insecure
  namespace: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kubernetes-dashboard
-----------------------------------------------------

#create rolebinding
k -n kubernetes-dashboard create rolebinding insecure --serviceaccount kubernetes-dashboard:kubernetes-dashboard --clusterrole view 
```



http://$ExternalIP:30639/#/pod?namespace=kubernetes-dashboard

![kubernetes dashboard](images/Section 6 Cluster Setup GUI Elements/Screenshot_11.png)

```sh
k -n kubernetes-dashboard create clusterrolebinding insecure --serviceaccount kubernetes-dashboard:kubernetes-dashboard --clusterrole view
```

##### kubernetes dashboard 2

![kubernetes dashboard 2](images/Section 6 Cluster Setup GUI Elements/Screenshot_12.png)

##### Dashboard arguments

![Dashboard arguments](images/Section 6 Cluster Setup GUI Elements/Screenshot_13.png)

##### 30. Recap

https://github.com/kubernetes/dashboard/blob/master/docs/common/dashboard-arguments.md

https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/README.md



[Kubernetes CKS Challenge Series](https://github.com/killer-sh/cks-challenge-series)

[Kubernetes CKS Course Environment](https://github.com/killer-sh/cks-course-environment)

 

### Section 7 Cluster Setup - Secure Ingress

#### 32. Introduction

##### What is Ingress

![What is Ingress](images/Section7_ClusterSetup-SecureIngress/Screenshot_1.png)

##### What is Ingress

![What is Ingress](images/Section7_ClusterSetup-SecureIngress/Screenshot_2.png)

##### Setup an example Ingress

##### Install NGINX Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml

##### K8s Ingress Docs
https://kubernetes.io/docs/concepts/services-networking/ingress



#### 33 Pratice - Create an Ingress

##### Setup an example Ingress

![Setup an example Ingress](images/Section7_ClusterSetup-SecureIngress/Screenshot_3.png)

##### Install NGINX Ingress

https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

```sh
#create ingress nginx service
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml

#show svc and pod of ingress-nginx namespace
k -n ingress-nginx get pod,svc
-----------------------------------------------------------------------------------------------------------------------------
NAME                                            READY   STATUS      RESTARTS   AGE
pod/ingress-nginx-admission-create-96l7b        0/1     Completed   0          62s
pod/ingress-nginx-admission-patch-phm8g         0/1     Completed   0          62s
pod/ingress-nginx-controller-785557f9c9-nwkcl   1/1     Running     0          63s

NAME                                         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/ingress-nginx-controller             NodePort    10.108.254.76   <none>        80:30670/TCP,443:31240/TCP   63s
service/ingress-nginx-controller-admission   ClusterIP   10.98.43.141    <none>        443/TCP                      63s
-----------------------------------------------------------------------------------------------------------------------------


curl http://$ExternalIP:30670
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```



##### K8s Ingress Docs

https://kubernetes.io/docs/concepts/services-networking/ingress



```sh
#before
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80

```
```sh
vim ingress.yaml
--------------------------------------------------------------------------
#after
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /service1
        pathType: Prefix
        backend:
          service:
            name: service1
            port:
              number: 80
      - path: /service2
        pathType: Prefix
        backend:
          service:
            name: service2
            port:
              number: 80
--------------------------------------------------------------------------              
k -f ingress.yaml create              
k get ing
--------------------------------------------------------------------------
NAME             CLASS    HOSTS   ADDRESS   PORTS   AGE
secure-ingress   <none>   *                 80      8s
--------------------------------------------------------------------------
              
```

```sh
k run pod1 --image=nginx
k run pod2 --image=httpd
k expose pod pod1 --port 80 --name service1
k expose pod pod2 --port 80 --name service2
```



##### 34. Practice - Secure an Ingress

![Setup an example Ingress](images/Section7_ClusterSetup-SecureIngress/Screenshot_4.png)

```sh
# not found gateway 504
curl http://35.187.199.19:30670/service1
curl http://34.85.100.111:30670/service2

curl https://34.85.100.111:32755/service1 -k
curl https://34.85.100.111:32755/service2 -k
curl https://34.85.100.111:32755/service2 -kv

kubectl get netpol
-------------------------------------------
NAME           POD-SELECTOR   AGE
backend        run=backend    4d
default-deny   <none>         4d1h
frontend       run=frontend   4d1h
-------------------------------------------

#delete network policies and can access the url
kubectl delete netpol backend default-deny frontend 
-------------------------------------------
NAME           POD-SELECTOR   AGE
backend        run=backend    4d
default-deny   <none>         4d1h
frontend       run=frontend   4d1h
-------------------------------------------
curl http://35.187.199.19:30255/service1

curl https://35.187.199.19:32755/service1
```





```sh
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
----------------------------------------------------------------------------------------------------------
Can't load /root/.rnd into RNG
140531955634624:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfile.c:88:Filename=/root/.rnd
Generating a RSA private key
.....................++++
.....++++
writing new private key to 'key.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:secure-ingress.com
Email Address []:
----------------------------------------------------------------------------------------------------------

ll -ltr
----------------------------------------------------------------------------------------------------------
-rw------- 1 root root 3272 Feb 18 11:41 key.pem
-rw-r--r-- 1 root root 2017 Feb 18 11:43 cert.pem
----------------------------------------------------------------------------------------------------------
```



https://kubernetes.io/docs/concepts/services-networking/ingress/#tls

```sh
vim ingress.yaml
----------------------------------------------------------------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
      - secure-ingress.com
    secretName: secure-ingress
  rules:
  - host: secure-ingress.com
  - http:
      paths:
      - path: /service1
        pathType: Prefix
        backend:
          service:
            name: service1
            port:
              number: 80
      - path: /service2
        pathType: Prefix
        backend:
          service:
            name: service2
            port:
              number: 80
----------------------------------------------------------------------------------------------------------
 k apply -f ingress.yaml
```

```sh

curl https://secure-ingress.com:$HttpsPort/service2 -kv --resolve secure-ingress.com:$HttpsPort:$externalIP
----------------------------------------------------------------------------------------------------------
*   Trying 34.85.100.111...
* TCP_NODELAY set
* Connected to 34.85.100.111 (34.85.100.111) port 32755 (#0)
* schannel: SSL/TLS connection with 34.85.100.111 port 32755 (step 1/3)
* schannel: disabled server certificate revocation checks
* schannel: verifyhost setting prevents Schannel from comparing the supplied target name with the subject names in server certificates.
* schannel: using IP address, SNI is not supported by OS.
* schannel: sending initial handshake data: sending 147 bytes...
* schannel: sent initial handshake data: sent 147 bytes
* schannel: SSL/TLS connection with 34.85.100.111 port 32755 (step 2/3)
* schannel: failed to receive handshake, need more data
* schannel: SSL/TLS connection with 34.85.100.111 port 32755 (step 2/3)
* schannel: encrypted data got 1310
* schannel: encrypted data buffer: offset 1310 length 4096
* schannel: sending next handshake data: sending 93 bytes...
* schannel: SSL/TLS connection with 34.85.100.111 port 32755 (step 2/3)
* schannel: encrypted data got 51
* schannel: encrypted data buffer: offset 51 length 4096
* schannel: SSL/TLS handshake complete
* schannel: SSL/TLS connection with 34.85.100.111 port 32755 (step 3/3)
* schannel: stored credential handle in session cache
> GET /service1 HTTP/1.1
> Host: 34.85.100.111:32755
> User-Agent: curl/7.55.1
> Accept: */*
>
* schannel: client wants to read 102400 bytes
* schannel: encdata_buffer resized 103424
* schannel: encrypted data buffer: offset 0 length 103424
* schannel: encrypted data got 393
* schannel: encrypted data buffer: offset 393 length 103424
* schannel: decrypted data length: 364
* schannel: decrypted data added: 364
* schannel: decrypted data cached: offset 364 length 102400
* schannel: encrypted data buffer: offset 0 length 103424
* schannel: decrypted data buffer: offset 364 length 102400
* schannel: schannel_recv cleanup
* schannel: decrypted data returned 364
* schannel: decrypted data buffer: offset 0 length 102400
< HTTP/1.1 504 Gateway Time-out
< Date: Thu, 18 Feb 2021 20:21:48 GMT
< Content-Type: text/html
< Content-Length: 160
< Connection: keep-alive
< Strict-Transport-Security: max-age=15724800; includeSubDomains
<
<html>
<head><title>504 Gateway Time-out</title></head>
<body>
<center><h1>504 Gateway Time-out</h1></center>
<hr><center>nginx</center>
</body>
</html>
* Connection #0 to host 34.85.100.111 left intact
----------------------------------------------------------------------------------------------------------
```



[curl –resolve](https://siguniang.wordpress.com/2014/05/10/fake-http-request-hostname/)

[curl command](https://qiita.com/shtnkgm/items/45b4cd274fa813d29539)

#### Section 8: Cluster Setup - Node Metadata Protection

###### 36 Introduction

##### Protect Node Metadata and Endpoints

![Protect Node Metadata and Endpoints](images/Section8_ClusterSetup-NodeMetadataProtection/Screenshot_1.png)

##### Cloud Platform Node Metadata

![Cloud Platform Node Metadata](images/Section8_ClusterSetup-NodeMetadataProtection/Screenshot_2.png)

##### Limit permissions for instance credentials

![Limit permissions for instance credentials](images/Section8_ClusterSetup-NodeMetadataProtection/Screenshot_3.png)

##### Restrict access using NetworkPolicies

![Restrict access using NetworkPolicies](images/Section8_ClusterSetup-NodeMetadataProtection/Screenshot_4.png)

#### 37. Practice : Access Node Metadata

###### Access GCP Instance Metadata : Access GCP metadata from instance and pod



https://cloud.google.com/compute/docs/storing-retrieving-metadata

```sh
curl "http://metadata.google.internal/computeMetadata/v1/instance/disks/" -H "Metadata-Flavor: Google"

curl "http://metadata.google.internal/computeMetadata/v1/instance/disks/0" -H "Metadata-Flavor: Google"


k run nginx --image=nginx
k exec nginx -it -- bash
```

###### Metadata restriction with NetworkPolicy:

###### Only allow pods with certain label to access the endpoint

```sh
ping metadata.google.internal
PING metadata.google.internal (169.254.169.254) 56(84) bytes of data.
64 bytes from metadata.google.internal (169.254.169.254): icmp_seq=1 ttl=255 time=0.704 ms
64 bytes from metadata.google.internal (169.254.169.254): icmp_seq=2 ttl=255 time=0.305 ms
64 bytes from metadata.google.internal (169.254.169.254): icmp_seq=3 ttl=255 time=0.239 ms
64 bytes from metadata.google.internal (169.254.169.254): icmp_seq=4 ttl=255 time=0.315 ms
```

https://github.com/killer-sh/cks-course-environment/tree/master/course-content/cluster-setup/protect-node-metadata

```sh
# https://github.com/killer-sh/cks-course-environment/blob/master/course-content/cluster-setup/protect-node-metadata/np_cloud_metadata_deny.yaml
k -f np_cloud_metadata_deny.yaml create


# https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/cluster-setup/protect-node-metadata/np_cloud_metadata_allow.yaml
k -f np_cloud_metadata_allow.yaml create
k get pod --show-labels
-------------------------------------------------------------------------------------
nginx      1/1     Running   0          13m    run=nginx
-------------------------------------------------------------------------------------
k label pod nginx role=metadata-accessor
-------------------------------------------------------------------------------------
nginx      1/1     Running   0          15m    role=metadata-accessor,run=nginx
-------------------------------------------------------------------------------------
k exec nginx -it -- bash
curl "http://metadata.google.internal/computeMetadata/v1/instance/disks/" -H "Metadata-Flavor: Google"
-------------------------------------------------------------------------------------
0/
-------------------------------------------------------------------------------------
exit

# delete the label role
k label pod nginx role-
k exec nginx -it -- bash
# get nothing
curl "http://metadata.google.internal/computeMetadata/v1/instance/disks/" -H "Metadata-Flavor: Google"
```

Of particular note, 169.254.169.254 is used in Amazon EC2 and other cloud computing platforms to [distribute metadata to cloud instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html).

#### 39. Recap

###### Recap

![Recap](images/Section8_ClusterSetup-NodeMetadataProtection/Screenshot_5.png)



#### Section 9: Cluster Setup - CIS Benchmarks

###### 40. Introduction

![Introduction 1](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_1.png)

![Introduction 2](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_2.png)

##### CIS - Center for Internet Security 1

![CIS - Center for Internet Security 1](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_3.png)

##### CIS - Center for Internet Security 2

![CIS - Center for Internet Security 2](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_4.png)

#### 41. Practice - CIS in Action

![CIS Benchmarks in action](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_5.png)

#### 42. Practice - kube-bench

![CIS Benchmarks in action](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_6.png)



[Running inside a container](https://github.com/aquasecurity/kube-bench#running-inside-a-container)

```sh
# run on master
docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -t aquasec/kube-bench:latest master --version 1.20

------------------------------------------------------------
== Summary master ==
45 checks PASS
10 checks FAIL
10 checks WARN
0 checks INFO
------------------------------------------------------------

#fixed fail 1.1.12
stat -c %U:%G /var/lib/etcd
useradd etcd
chown etcd:etcd /var/lib/etcd
stat -c %U:%G /var/lib/etcd

------------------------------------------------------------
== Summary master ==
46 checks PASS
9 checks FAIL
10 checks WARN
0 checks INFO
------------------------------------------------------------

# run on worker
docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -t aquasec/kube-bench:latest node --version 1.20
```

#### 43. Recap

[Martin White - Consistent Security Controls through CIS Benchmarks](https://www.youtube.com/watch?v=53-v3stlnCo)

[Tool:Docker Bench](https://github.com/docker/docker-bench-security)

https://cloud.google.com/kubernetes-engine/docs/concepts/cis-benchmarks

![What are CIS Benchmarks](images/Section9_ClusterSetup-CISBenchmarks/Screenshot_7.png)

#### Section 10 : Cluster Setup - Verify Platform Binaries

##### 44 Introduction

###### Verify platform binaries

![Verify platform binaries](images/Section10_ClusterSetup-VerifyPlatformBinaries/Screenshot_1.png)

##### Theory and Hashes

![Theory and Hashes](images/Section10_ClusterSetup-VerifyPlatformBinaries/Screenshot_2.png)

```sh
#get k8s version 
k get node
NAME         STATUS   ROLES                  AGE   VERSION
cks-master   Ready    control-plane,master   14d   v1.20.2
cks-worker   Ready    <none>                 14d   v1.20.2
# downloade 
wget https://dl.k8s.io/v1.20.4/kubernetes-server-linux-amd64.tar.gz
sha512sum  kubernetes-server-linux-amd64.tar.gz
--------------------------------------------------------------------------------------------------------------------------------
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5 
--------------------------------------------------------------------------------------------------------------------------------
#
sha512sum kubernetes-server-linux-amd64.tar.gz > compare
#before
------------------------------------------------------------
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5  kubernetes-server-linux-amd64.tar.gz
------------------------------------------------------------
#after
------------------------------------------------------------
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5 ------------------------------------------------------------
#copy  sha512sum form https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.20.md#server-binaries 
# to compare file
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5
#vim compare
------------------------------------------------------------
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5
------------------------------------------------------------
#compare two files
cat compare | uniq
37738bc8430b0832f32c6d13cdd68c376417270568cd9b31a1ff37e96cfebcc1e2970c72bed588f626e35ed8273671c77200f0d164e67809b5626a2a99e3c5f5

```

#### 45. Practice - Download and verify K8s release

![Verify binaries from container](images/Section10_ClusterSetup-VerifyPlatformBinaries/Screenshot_3.png)

```sh
# unzip archive file 
tar xfz kubernetes-server-linux-amd64.tar.gz

#
sha512sum kubernetes/server/bin/kube-apiserver > compare

#
k -n kube-system get pod | grep api
------------------------------------------------------------
kube-apiserver-cks-master            1/1     Running   15         14d
------------------------------------------------------------
k -n kube-system get pod kube-apiserver-cks-master -oyaml | grep image

docker ps | grep apiserver
------------------------------------------------------------
491c17322c10        a8c2fdb8bf76           "kube-apiserver --ad…"   About an hour ago   Up About an hour                        k8s_kube-apiserver_kube-apiserver-cks-master_kube-system_f6c58610040386ba7cf06646b052f201_15
3d1b654402a7        k8s.gcr.io/pause:3.2   "/pause"                 About an hour ago   Up About an hour                        k8s_POD_kube-apiserver-cks-master_kube-system_f6c58610040386ba7cf06646b052f201_11
------------------------------------------------------------


docker cp 491c17322c10:/ container-fs

sha512sum container-fs/usr/local/bin/kube-apiserver >> compare

#delete contents without sha512sum 
cat compare | uniq
```

##### 47.Recap

![Recap](images/Section10_ClusterSetup-VerifyPlatformBinaries/Screenshot_4.png)



#### Section 11: Cluster Hardening - RBAC

##### 48. Intro

![RBAC 1](images/Section11_ClusterHardening-RBAC/Screenshot_1.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_2.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_3.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_4.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_5.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_6.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_7.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_8.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_9.png)

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_10.png)

##### 49. Practice - Role and Rolebinding

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_11.png)

```sh
k create ns red

k create ns blue

# Check the yaml file
k -n red create role secret-manager --verb=get --resource=secrets -oyaml --dry-run=client
------------------------------------------------------------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: null
  name: secret-manager
  namespace: red
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
------------------------------------------------------------------------------------
#Create the role resource for namespace red
k -n red create role secret-manager --verb=get --resource=secrets 
------------------------------------------------------------------------------------
role.rbac.authorization.k8s.io/secret-manager created
------------------------------------------------------------------------------------


k -n red create rolebinding secret-manager --role=secret-manager --user=jane -oyaml --dry-run=client
------------------------------------------------------------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: secret-manager
  namespace: red
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: secret-manager
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: jane
------------------------------------------------------------------------------------

#Create rolebinding for namespace red
k -n red create rolebinding secret-manager --role=secret-manager --user=jane
------------------------------------------------------------------------------------
rolebinding.rbac.authorization.k8s.io/secret-manager created
------------------------------------------------------------------------------------

#Create the role resource for namespace blue
k -n blue create role secret-manager --verb=get --verb=list --resource=secrets
------------------------------------------------------------------------------------
role.rbac.authorization.k8s.io/secret-manager created
------------------------------------------------------------------------------------

#Create rolebinding for namespace blue
k -n blue create rolebinding secret-manager --role=secret-manager --user=jane
------------------------------------------------------------------------------------
rolebinding.rbac.authorization.k8s.io/secret-manager created
------------------------------------------------------------------------------------
#check the manual
k auth can-i -h

k -n red auth can-i get secrets --as jane
yes

k -n red auth can-i get secrets --as matsu
no

k -n red auth can-i delete secrets --as jane
no
k -n red auth can-i list secrets --as jane
no

k -n blue auth can-i list secrets --as jane
yes

k -n blue auth can-i get secrets --as jane
yes

k -n blue auth can-i get pod --as jane
no

```

##### 50 Practice -ClusterRole and ClusterRoleBInding

![RBAC 2](images/Section11_ClusterHardening-RBAC/Screenshot_12.png)

##### 
##### 51 Accounts and Users

##### 52 Practice CertificateSigningRequests

##### 53 Recap

#### Section 12 Cluster Hardening Exercise caution in using ServiceAccounts
##### 54 Intro

##### 55
```sh
# from inside a Pod we can do:
cat /run/secrets/kubernetes.io/serviceaccount/token

curl https://kubernetes.default -k -H "Authorization: Bearer SA_TOKEN"
```

##### 56
https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account
##### 57
##### 58 Recap

- SA are resources with token in secret
- SAs and Pods + mounting
- Create RBAC with SAs

https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin

https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account

#### Section 13 Cluster Hardening Restrict API Access

##### 59 Intro
###### Restrict API access
- Authentication Authorization Admission
- Connect to the API in different ways
- Restrict API access in various ways

###### Request workflow

- API requests are always tied to 
  - A normal user
  - A ServiceAccount
  - Are treated as anonymous requests
- Every request must authenticate
  - Or be treated as an anonymous user

###### Restrictions

1. Don't allow anonymous access
2. Close insecure port
3. Don't expose ApiServer to the outside
4. Restrict access from Nodes to API(NodeRestriction)
5. Prevent unauthorized access(RBAC)
6. Prevent pods from accessing API
7. Apiserver port behind firewall / allowed ip ranges(cloud provider)

##### 60 Practice Anonymous Access

###### Anonymous Access

- kube-apiserver --anonymous-auth=true|false
- In 1.6+, anonymous access is enabled by default
  - if authorization mode other than AlwaysAllow
  - but ABAC and RBAC require explicit authorization for anonymous

###### Anonymous Access

**Enable/Disable anonymous access and test it **

```sh
#
cat /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
----------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443
----------------------------------------------------------------
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
----------------------------------------------------------------

root@cks-master:~# curl https://localhost:6443 -k
----------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}
----------------------------------------------------------------
root@cks-master:~#vim /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - kube-apiserver
    - --anonymous-auth=true   # add this line
    - --advertise-address=10.146.0.2
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
----------------------------------------------------------------
k -n kube-system get pod | grep api
The connection to the server 10.146.0.2:6443 was refused - did you specify the right host or port?

root@cks-master:~#k -n kube-system get pod | grep api

---------------------------------------------------------------------------
kube-apiserver-cks-master            1/1     Running   0          17s
---------------------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443 -k
---------------------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}
---------------------------------------------------------------------------


root@cks-master:~#vim /etc/kubernetes/manifests/kube-apiserver.yaml
----------------------------------------------------------------
    - kube-apiserver
    - --anonymous-auth=false   # change this line
----------------------------------------------------------------
root@cks-master:~# curl https://localhost:6443 -k
---------------------------------------------------------------------------
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "Unauthorized",
  "reason": "Unauthorized",
  "code": 401
}
---------------------------------------------------------------------------
root@cks-master:~#k -n kube-system get pod | grep api
---------------------------------------------------------------------------
kube-apiserver-cks-master            1/1     Running   0          2m14s
---------------------------------------------------------------------------
```

##### 61 Practice Insecure Access

Since K8S 1.20 the insecure access is not longer possible 

kube-apiserver --insecure-port=8080



###### HTTP / HTTPS Access

kubectl(client cert) ===Rquest(https)===>  API Server(server cert)

CA(scope): https,server cert, API Server



###### Insecure Access

- kube-apiserver --insecure-port=8080
  - HTTP
  - Request **bypasses** authentication and authorization modules
  - Admission controller still enforces
- Enable insecure access/port and use it

```sh
# before K8S 1.20
vim /etc/kuberntes/manifests/kube-apiserver.yaml

#before
------------------------------------------------------------------------------------------------------------------------
    - --insecure-port=0
------------------------------------------------------------------------------------------------------------------------
#after
------------------------------------------------------------------------------------------------------------------------
    - --insecure-port=8080
------------------------------------------------------------------------------------------------------------------------
```

##### 62 Practice Manual API Request

###### Send manual API request

**Let's have a look at the kubeconfig certs and perform a manual API query**

```sh
root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

root@cks-master:~# k config view --raw
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJUG1welZHYnExMnN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBeU1USXlNVEV4TXpGYUZ3MHlNakF5TVRJeU1URXhNelZhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRCUmMwblF2VCtZcGdpN1YKMG9PMUtNcUNZZVU4Q0tUd0ZNQXZhc2ducXI2dS9qV08yMlVrUUxwU2t2MXgvU09wNnFlaU91cGJuM253VHd1bwprR0ZGSW56Z1pWYXBKc0NUUVRPVjJjSmd5Z3hQNGZPYXJHV3djZGVQMHNic0VqWlNCcGs4N1N4dFIwbDEwQ3JOCjdlWUExd1F0L09iOGRoTE9JU1JWa0FoQmxRZzRKTDBFeU55YzBSL0RJWk94QmN0anJibXgwOENwVFIvSjBXL1YKU3ZOVkhTdDQwUUpxc2RVcDFFeUJ3U1JVaXdqdmFWZThGNVpUME9MYXFVcXdSbmxXN1RiYjFJNjZIRk1uRmgvbAp4M1BxNUZ5QWI2ankxdnE2a2l3RE9GWk1TVlVuOVIyS1ZUa2s3bnQ2cE5CNUVwYi9EZ2VhUGdrZVg5YytNMG1LCm5lWXB0d0lEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVV2VExOSytkL0s0czdxYTNmK3pmT1dTb3pJbzB3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFET0YxN1FkbWdvbjlsMW1jL2QwMU40UU9WQW8rNWpob3BpL2ZoS2dNYWZQVVNVQnN4dHI2bUN1CmZIQVNEeDI1TDVWRmNVNFhoaEhnZkhPU3F2blVVanp6MFB4NTZDQitnaE5xdXdnWmtoMml5WGwxTmRRMDNTdG0KQmVwUDhyVmkrQnhwb1RCYVRsRTVWNUEzVm5xTzJIYWJtNktuTU5jOWM5L2hMdEMwbGhra3lNeEtCS1hsaVkzSAovUlRzUUF0NmxKQ1dDNDV3RWdJTUtOZ1h2ekpqVks2cWdWNUxFSzc5Zll2MkI4d2p1VlFwMWJ3SnpPbHhQN01LCkh6RmhrOHlITlBRWEtKdWh0eUV5THNoMzY2SnpaeUlVMjBzQXQ1Rytjd3JFNmw5MXFZWnVtK1dnUVdLdDg1Sm4KeWIxYUNNY3RwcHZiMktlalRqa3BVM3VwVU9NNEEwWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdEJSYzBuUXZUK1lwZ2k3VjBvTzFLTXFDWWVVOENLVHdGTUF2YXNnbnFyNnUvaldPCjIyVWtRTHBTa3YxeC9TT3A2cWVpT3VwYm4zbndUd3Vva0dGRkluemdaVmFwSnNDVFFUT1YyY0pneWd4UDRmT2EKckdXd2NkZVAwc2JzRWpaU0Jwazg3U3h0UjBsMTBDck43ZVlBMXdRdC9PYjhkaExPSVNSVmtBaEJsUWc0SkwwRQp5TnljMFIvRElaT3hCY3RqcmJteDA4Q3BUUi9KMFcvVlN2TlZIU3Q0MFFKcXNkVXAxRXlCd1NSVWl3anZhVmU4CkY1WlQwT0xhcVVxd1JubFc3VGJiMUk2NkhGTW5GaC9seDNQcTVGeUFiNmp5MXZxNmtpd0RPRlpNU1ZVbjlSMksKVlRrazdudDZwTkI1RXBiL0RnZWFQZ2tlWDljK00wbUtuZVlwdHdJREFRQUJBb0lCQUVqeEhwQVlnN21IYnpUTwpKOG8za3ovTWwzZHoxUmRqUitQLzNMVVNFZzgxWWNpU2hTVVZHTlFuSko5cGpheU5yNXZlL3ZXQ1RFNlNvK1pBCndLeUsyZWdZVVFSN1Q5VGttRUVHMWlINGZDQWJVSmdqaG5saVQxQXRrcEk4QlE5emRWSTY2OVRkOC8yMkljU0sKTWhPMDRJNDNvVEVabHhWMGxJNFVHNXhWMjhxemRhaHhKaVdlb0x3Ty91OUhqaUlwSG13NzMrTVZPaUNsa0NnSgorT0F6RGxMemsyWFhzdE9UcWo4NHZvRXpXMmIwVWdWaTRyQXhGRjlpUEduNHJVTUtmV0xoY3E1SWx2RGY5bmo3CjF1SlZVUUNrZ2FrMWJJTXZORU95ektFRy9VSytONTFyS0ZaUURERm1ZeTlWdnNjcnMvMHQreGRkZ1ZKWnRHM3gKQVNXRmFwRUNnWUVBMVRjZmxEL0FWNHI4dFgyVjRMNGdUdFJkdjdTMlhxR0hlNG5PM3kwOGIrb2VqbGYrM3NsagpzeUpqOHpvVUVqbDVCVHR6cWUvbVNpZXc1TFYrV1pEMHpKTXU2aFdlNXFnajM2VUh1NHRrSU0zcHV2QUppMFNQCnRNc0dYM1hpblk0OWFET2Y3N2RkQmE3R2RYdUhpNXdyc2MzWXNLc0J6U2JDbXBVdGlvRmhpbHNDZ1lFQTJEY04KbTlQKzFiV3lkc0RxNnZBTnJDQWFIZjJWMTcwWGE2T00rSkJiME5UOHhPTXVBcmwrUmFoOGx0ZEgxdFBlb3RHMQpVVjVLeXh1WjlhNHBIaTVIR3psM1VESytvYktsdjNBbGRJY01kWWhkRytPVUFpeEJqMndvb0VVdlNYNlg5NmRqCk03bGhDNHJuRUtQTzFvcGJpR3BpVkdUQXJqODBQbE1DbTU2ZjVOVUNnWUFXQm5XNnFNTkR4OVhISWN3RHhXQXQKQkg4U3VLWkdMRVdFbTMzRlREVDhFcUZKYndtakZnYTRrSXJtcTA4N2VyaG5zL2FFellWcWo2TVVYVE5LS1ZGQQplTXZWM3BubGxlVHV5MnQ3RWpFcnVsbTB0K3NrZWRhbWhIcUtEZkYwK1NhYXh3cDBodXFURmJUbW1mWXNrOXRuCnFLNER3Z2FUbkxkcHBKTnB4V2ZBRlFLQmdCNlZPdkdOdlFBUm9WcTIwd1BFVE1yS0I2ZXlWTjJkTzVEWUkzcU4KUU05N01QM1FmSk9hRlVoWkdyWmpZUi83L0FQZjBkdmVrSW5HTDdMV25hNU5NWFdpWFVRVXlXNHB6TlFWVXRiMgp1MFpzc1c3ZWMvTVN1M3REKzBNZ1JoNEpNQW14dlpCMWFrcXRyUjFuYmp4ZWViQUVERUNQdDhsdDJ6L3RrZkxkCkx4UzVBb0dBVG9DVFlxSGFkT1RNRzRaL3NsNm1OSm4yMGdIR2toU2lFQzcxVUV4Z3pYNW1kYXlDMVphZWR0YXkKbUtiVGh2WE56eXd1OThDdnIyNjJGYUlXUjlWcE1yQTUzSXJpd2s4ZjBSSnhoTnptWm9jYXJrNkxkTjEvbUNLaQpYMjB3UVNVV2pZTlZNYTNYcnJOWjhPZjdOR2RWYXRkNUNsOHVNblJZbWVTY05lakljbzQ9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==


#check the kubw config fiel
vim .kubw/config

# copy certificate-authority-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg== | base64 -d
-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIxMDIxMjIxMTEzMVoXDTMxMDIxMDIxMTEzMVowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANOR
4rSx1o6MgI5/GTB7Z4EUrO9snNVE0W0Ezpvi2b07HEIEJjN0ywAdIo/3QXeyEU/g
DAaBpJmEAQZ9RBTQyv4GUDdh767slfg2ZnuKs6rWEZH7kUwWXDSaeLiP6N0Yse5i
XaXc8idhDK7/Th95XUax9kczb3HJDWly2tSxnYFsVR3HHnBPNT+TIQVTk/dzN7x+
p5C1MYnoiv2MPRzCddGafJpgVrZqzXigq97xCYmpNU/7Z60tMscvm0asM86aqbSU
CoSgIon47FUHlFrWbVEfsSeJUjQUtBgJqaMfsfikXD7qaZwHxC56VYb9ru8fTL8K
1JfKXIgrsERIpOesFAsCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFL0yzSvnfyuLO6mt3/s3zlkqMyKNMA0GCSqGSIb3
DQEBCwUAA4IBAQA4dx4SpyJj6wUtcvBpJIziTe7uZpeUn9H8LMPiHghl8kTYfuUr
ZdL6CrToOmtVLEDxlYZJjtAYAj1u71ytS4abh13L5rW0NHhQJ+acKnbFmssl2K8F
n15u7tMJKV0KFqVSj+aYl/+Xr3LlcvzDF7HX11BC4jllP+SW0vjdF+dnv+xlBCQn
Vm4GXwsslzvyk5k84wzR7JBUeQ0ZNwRd0zQk/PEjm8Lro95GNQqy7FyWFrdWIvx4
GLeDT/GvGWw1OPbQJWKnYxaDmgFAS2YDnlU3G99VePfv7hsYydlLc2TEVetZYaJs
/9vb1QkqiiN6SW+0iWXZKnLTT0zoHE+4pmJz
-----END CERTIFICATE-----
# copy certificate-authority-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ESXhNakl4TVRFek1Wb1hEVE14TURJeE1ESXhNVEV6TVZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTk9SCjRyU3gxbzZNZ0k1L0dUQjdaNEVVck85c25OVkUwVzBFenB2aTJiMDdIRUlFSmpOMHl3QWRJby8zUVhleUVVL2cKREFhQnBKbUVBUVo5UkJUUXl2NEdVRGRoNzY3c2xmZzJabnVLczZyV0VaSDdrVXdXWERTYWVMaVA2TjBZc2U1aQpYYVhjOGlkaERLNy9UaDk1WFVheDlrY3piM0hKRFdseTJ0U3huWUZzVlIzSEhuQlBOVCtUSVFWVGsvZHpON3grCnA1QzFNWW5vaXYyTVBSekNkZEdhZkpwZ1ZyWnF6WGlncTk3eENZbXBOVS83WjYwdE1zY3ZtMGFzTTg2YXFiU1UKQ29TZ0lvbjQ3RlVIbEZyV2JWRWZzU2VKVWpRVXRCZ0pxYU1mc2Zpa1hEN3FhWndIeEM1NlZZYjlydThmVEw4SwoxSmZLWElncnNFUklwT2VzRkFzQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMMHl6U3ZuZnl1TE82bXQzL3MzemxrcU15S05NQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNGR4NFNweUpqNndVdGN2QnBKSXppVGU3dVpwZVVuOUg4TE1QaUhnaGw4a1RZZnVVcgpaZEw2Q3JUb09tdFZMRUR4bFlaSmp0QVlBajF1NzF5dFM0YWJoMTNMNXJXME5IaFFKK2FjS25iRm1zc2wySzhGCm4xNXU3dE1KS1YwS0ZxVlNqK2FZbC8rWHIzTGxjdnpERjdIWDExQkM0amxsUCtTVzB2amRGK2Rudit4bEJDUW4KVm00R1h3c3NsenZ5azVrODR3elI3SkJVZVEwWk53UmQwelFrL1BFam04THJvOTVHTlFxeTdGeVdGcmRXSXZ4NApHTGVEVC9HdkdXdzFPUGJRSldLbll4YURtZ0ZBUzJZRG5sVTNHOTlWZVBmdjdoc1l5ZGxMYzJURVZldFpZYUpzCi85dmIxUWtxaWlONlNXKzBpV1haS25MVFQwem9IRSs0cG1KegotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg== | base64 -d > ca

#client-certificate-data
root@cks-master:~# echo LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJUG1welZHYnExMnN3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBeU1USXlNVEV4TXpGYUZ3MHlNakF5TVRJeU1URXhNelZhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXRCUmMwblF2VCtZcGdpN1YKMG9PMUtNcUNZZVU4Q0tUd0ZNQXZhc2ducXI2dS9qV08yMlVrUUxwU2t2MXgvU09wNnFlaU91cGJuM253VHd1bwprR0ZGSW56Z1pWYXBKc0NUUVRPVjJjSmd5Z3hQNGZPYXJHV3djZGVQMHNic0VqWlNCcGs4N1N4dFIwbDEwQ3JOCjdlWUExd1F0L09iOGRoTE9JU1JWa0FoQmxRZzRKTDBFeU55YzBSL0RJWk94QmN0anJibXgwOENwVFIvSjBXL1YKU3ZOVkhTdDQwUUpxc2RVcDFFeUJ3U1JVaXdqdmFWZThGNVpUME9MYXFVcXdSbmxXN1RiYjFJNjZIRk1uRmgvbAp4M1BxNUZ5QWI2ankxdnE2a2l3RE9GWk1TVlVuOVIyS1ZUa2s3bnQ2cE5CNUVwYi9EZ2VhUGdrZVg5YytNMG1LCm5lWXB0d0lEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVV2VExOSytkL0s0czdxYTNmK3pmT1dTb3pJbzB3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFET0YxN1FkbWdvbjlsMW1jL2QwMU40UU9WQW8rNWpob3BpL2ZoS2dNYWZQVVNVQnN4dHI2bUN1CmZIQVNEeDI1TDVWRmNVNFhoaEhnZkhPU3F2blVVanp6MFB4NTZDQitnaE5xdXdnWmtoMml5WGwxTmRRMDNTdG0KQmVwUDhyVmkrQnhwb1RCYVRsRTVWNUEzVm5xTzJIYWJtNktuTU5jOWM5L2hMdEMwbGhra3lNeEtCS1hsaVkzSAovUlRzUUF0NmxKQ1dDNDV3RWdJTUtOZ1h2ekpqVks2cWdWNUxFSzc5Zll2MkI4d2p1VlFwMWJ3SnpPbHhQN01LCkh6RmhrOHlITlBRWEtKdWh0eUV5THNoMzY2SnpaeUlVMjBzQXQ1Rytjd3JFNmw5MXFZWnVtK1dnUVdLdDg1Sm4KeWIxYUNNY3RwcHZiMktlalRqa3BVM3VwVU9NNEEwWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo= | base64 -d > crt

#client-key-data
root@cks-master:~# echo LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb2dJQkFBS0NBUUVBdEJSYzBuUXZUK1lwZ2k3VjBvTzFLTXFDWWVVOENLVHdGTUF2YXNnbnFyNnUvaldPCjIyVWtRTHBTa3YxeC9TT3A2cWVpT3VwYm4zbndUd3Vva0dGRkluemdaVmFwSnNDVFFUT1YyY0pneWd4UDRmT2EKckdXd2NkZVAwc2JzRWpaU0Jwazg3U3h0UjBsMTBDck43ZVlBMXdRdC9PYjhkaExPSVNSVmtBaEJsUWc0SkwwRQp5TnljMFIvRElaT3hCY3RqcmJteDA4Q3BUUi9KMFcvVlN2TlZIU3Q0MFFKcXNkVXAxRXlCd1NSVWl3anZhVmU4CkY1WlQwT0xhcVVxd1JubFc3VGJiMUk2NkhGTW5GaC9seDNQcTVGeUFiNmp5MXZxNmtpd0RPRlpNU1ZVbjlSMksKVlRrazdudDZwTkI1RXBiL0RnZWFQZ2tlWDljK00wbUtuZVlwdHdJREFRQUJBb0lCQUVqeEhwQVlnN21IYnpUTwpKOG8za3ovTWwzZHoxUmRqUitQLzNMVVNFZzgxWWNpU2hTVVZHTlFuSko5cGpheU5yNXZlL3ZXQ1RFNlNvK1pBCndLeUsyZWdZVVFSN1Q5VGttRUVHMWlINGZDQWJVSmdqaG5saVQxQXRrcEk4QlE5emRWSTY2OVRkOC8yMkljU0sKTWhPMDRJNDNvVEVabHhWMGxJNFVHNXhWMjhxemRhaHhKaVdlb0x3Ty91OUhqaUlwSG13NzMrTVZPaUNsa0NnSgorT0F6RGxMemsyWFhzdE9UcWo4NHZvRXpXMmIwVWdWaTRyQXhGRjlpUEduNHJVTUtmV0xoY3E1SWx2RGY5bmo3CjF1SlZVUUNrZ2FrMWJJTXZORU95ektFRy9VSytONTFyS0ZaUURERm1ZeTlWdnNjcnMvMHQreGRkZ1ZKWnRHM3gKQVNXRmFwRUNnWUVBMVRjZmxEL0FWNHI4dFgyVjRMNGdUdFJkdjdTMlhxR0hlNG5PM3kwOGIrb2VqbGYrM3NsagpzeUpqOHpvVUVqbDVCVHR6cWUvbVNpZXc1TFYrV1pEMHpKTXU2aFdlNXFnajM2VUh1NHRrSU0zcHV2QUppMFNQCnRNc0dYM1hpblk0OWFET2Y3N2RkQmE3R2RYdUhpNXdyc2MzWXNLc0J6U2JDbXBVdGlvRmhpbHNDZ1lFQTJEY04KbTlQKzFiV3lkc0RxNnZBTnJDQWFIZjJWMTcwWGE2T00rSkJiME5UOHhPTXVBcmwrUmFoOGx0ZEgxdFBlb3RHMQpVVjVLeXh1WjlhNHBIaTVIR3psM1VESytvYktsdjNBbGRJY01kWWhkRytPVUFpeEJqMndvb0VVdlNYNlg5NmRqCk03bGhDNHJuRUtQTzFvcGJpR3BpVkdUQXJqODBQbE1DbTU2ZjVOVUNnWUFXQm5XNnFNTkR4OVhISWN3RHhXQXQKQkg4U3VLWkdMRVdFbTMzRlREVDhFcUZKYndtakZnYTRrSXJtcTA4N2VyaG5zL2FFellWcWo2TVVYVE5LS1ZGQQplTXZWM3BubGxlVHV5MnQ3RWpFcnVsbTB0K3NrZWRhbWhIcUtEZkYwK1NhYXh3cDBodXFURmJUbW1mWXNrOXRuCnFLNER3Z2FUbkxkcHBKTnB4V2ZBRlFLQmdCNlZPdkdOdlFBUm9WcTIwd1BFVE1yS0I2ZXlWTjJkTzVEWUkzcU4KUU05N01QM1FmSk9hRlVoWkdyWmpZUi83L0FQZjBkdmVrSW5HTDdMV25hNU5NWFdpWFVRVXlXNHB6TlFWVXRiMgp1MFpzc1c3ZWMvTVN1M3REKzBNZ1JoNEpNQW14dlpCMWFrcXRyUjFuYmp4ZWViQUVERUNQdDhsdDJ6L3RrZkxkCkx4UzVBb0dBVG9DVFlxSGFkT1RNRzRaL3NsNm1OSm4yMGdIR2toU2lFQzcxVUV4Z3pYNW1kYXlDMVphZWR0YXkKbUtiVGh2WE56eXd1OThDdnIyNjJGYUlXUjlWcE1yQTUzSXJpd2s4ZjBSSnhoTnptWm9jYXJrNkxkTjEvbUNLaQpYMjB3UVNVV2pZTlZNYTNYcnJOWjhPZjdOR2RWYXRkNUNsOHVNblJZbWVTY05lakljbzQ9Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg== | base64 -d > key

root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

# get server url
root@cks-master:~# k config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://10.146.0.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: REDACTED
    client-key-data: REDACTED

root@cks-master:~# curl https://10.146.0.2:6443
curl: (60) SSL certificate problem: unable to get local issuer certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.



root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca
{
  "kind": "Status",
  "apiVersion": "v1",
  "metadata": {

  },
  "status": "Failure",
  "message": "forbidden: User \"system:anonymous\" cannot get path \"/\"",
  "reason": "Forbidden",
  "details": {

  },
  "code": 403
}

root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca --cert crt
curl: (58) unable to set private key file: 'crt' type PEM

# get api info
root@cks-master:~# curl https://10.146.0.2:6443 --cacert ca --cert crt --key key{
  "paths": [
    "/.well-known/openid-configuration",
    "/api",
    "/api/v1",
    "/apis",
    "/apis/",
    "/apis/admissionregistration.k8s.io",
    "/apis/admissionregistration.k8s.io/v1",
    "/apis/admissionregistration.k8s.io/v1beta1",
    "/apis/apiextensions.k8s.io",
    "/apis/apiextensions.k8s.io/v1",
    "/apis/apiextensions.k8s.io/v1beta1",
    "/apis/apiregistration.k8s.io",
    "/apis/apiregistration.k8s.io/v1",
    "/apis/apiregistration.k8s.io/v1beta1",
    "/apis/apps",
    "/apis/apps/v1",
    "/apis/authentication.k8s.io",
    "/apis/authentication.k8s.io/v1",
    "/apis/authentication.k8s.io/v1beta1",
    "/apis/authorization.k8s.io",
    "/apis/authorization.k8s.io/v1",
    "/apis/authorization.k8s.io/v1beta1",
    "/apis/autoscaling",
    "/apis/autoscaling/v1",
    "/apis/autoscaling/v2beta1",
    "/apis/autoscaling/v2beta2",
    "/apis/batch",
    "/apis/batch/v1",
    "/apis/batch/v1beta1",
    "/apis/certificates.k8s.io",
    "/apis/certificates.k8s.io/v1",
    "/apis/certificates.k8s.io/v1beta1",
    "/apis/coordination.k8s.io",
    "/apis/coordination.k8s.io/v1",
    "/apis/coordination.k8s.io/v1beta1",
    "/apis/discovery.k8s.io",
    "/apis/discovery.k8s.io/v1beta1",
    "/apis/events.k8s.io",
    "/apis/events.k8s.io/v1",
    "/apis/events.k8s.io/v1beta1",
    "/apis/extensions",
    "/apis/extensions/v1beta1",
    "/apis/flowcontrol.apiserver.k8s.io",
    "/apis/flowcontrol.apiserver.k8s.io/v1beta1",
    "/apis/networking.k8s.io",
    "/apis/networking.k8s.io/v1",
    "/apis/networking.k8s.io/v1beta1",
    "/apis/node.k8s.io",
    "/apis/node.k8s.io/v1",
    "/apis/node.k8s.io/v1beta1",
    "/apis/policy",
    "/apis/policy/v1beta1",
    "/apis/rbac.authorization.k8s.io",
    "/apis/rbac.authorization.k8s.io/v1",
    "/apis/rbac.authorization.k8s.io/v1beta1",
    "/apis/scheduling.k8s.io",
    "/apis/scheduling.k8s.io/v1",
    "/apis/scheduling.k8s.io/v1beta1",
    "/apis/storage.k8s.io",
    "/apis/storage.k8s.io/v1",
    "/apis/storage.k8s.io/v1beta1",
    "/healthz",
    "/healthz/autoregister-completion",
    "/healthz/etcd",
    "/healthz/log",
    "/healthz/ping",
    "/healthz/poststarthook/aggregator-reload-proxy-client-cert",
    "/healthz/poststarthook/apiservice-openapi-controller",
    "/healthz/poststarthook/apiservice-registration-controller",
    "/healthz/poststarthook/apiservice-status-available-controller",
    "/healthz/poststarthook/bootstrap-controller",
    "/healthz/poststarthook/crd-informer-synced",
    "/healthz/poststarthook/generic-apiserver-start-informers",
    "/healthz/poststarthook/kube-apiserver-autoregistration",
    "/healthz/poststarthook/priority-and-fairness-config-consumer",
    "/healthz/poststarthook/priority-and-fairness-config-producer",
    "/healthz/poststarthook/priority-and-fairness-filter",
    "/healthz/poststarthook/rbac/bootstrap-roles",
    "/healthz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/healthz/poststarthook/start-apiextensions-controllers",
    "/healthz/poststarthook/start-apiextensions-informers",
    "/healthz/poststarthook/start-cluster-authentication-info-controller",
    "/healthz/poststarthook/start-kube-aggregator-informers",
    "/healthz/poststarthook/start-kube-apiserver-admission-initializer",
    "/livez",
    "/livez/autoregister-completion",
    "/livez/etcd",
    "/livez/log",
    "/livez/ping",
    "/livez/poststarthook/aggregator-reload-proxy-client-cert",
    "/livez/poststarthook/apiservice-openapi-controller",
    "/livez/poststarthook/apiservice-registration-controller",
    "/livez/poststarthook/apiservice-status-available-controller",
    "/livez/poststarthook/bootstrap-controller",
    "/livez/poststarthook/crd-informer-synced",
    "/livez/poststarthook/generic-apiserver-start-informers",
    "/livez/poststarthook/kube-apiserver-autoregistration",
    "/livez/poststarthook/priority-and-fairness-config-consumer",
    "/livez/poststarthook/priority-and-fairness-config-producer",
    "/livez/poststarthook/priority-and-fairness-filter",
    "/livez/poststarthook/rbac/bootstrap-roles",
    "/livez/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/livez/poststarthook/start-apiextensions-controllers",
    "/livez/poststarthook/start-apiextensions-informers",
    "/livez/poststarthook/start-cluster-authentication-info-controller",
    "/livez/poststarthook/start-kube-aggregator-informers",
    "/livez/poststarthook/start-kube-apiserver-admission-initializer",
    "/logs",
    "/metrics",
    "/openapi/v2",
    "/openid/v1/jwks",
    "/readyz",
    "/readyz/autoregister-completion",
    "/readyz/etcd",
    "/readyz/informer-sync",
    "/readyz/log",
    "/readyz/ping",
    "/readyz/poststarthook/aggregator-reload-proxy-client-cert",
    "/readyz/poststarthook/apiservice-openapi-controller",
    "/readyz/poststarthook/apiservice-registration-controller",
    "/readyz/poststarthook/apiservice-status-available-controller",
    "/readyz/poststarthook/bootstrap-controller",
    "/readyz/poststarthook/crd-informer-synced",
    "/readyz/poststarthook/generic-apiserver-start-informers",
    "/readyz/poststarthook/kube-apiserver-autoregistration",
    "/readyz/poststarthook/priority-and-fairness-config-consumer",
    "/readyz/poststarthook/priority-and-fairness-config-producer",
    "/readyz/poststarthook/priority-and-fairness-filter",
    "/readyz/poststarthook/rbac/bootstrap-roles",
    "/readyz/poststarthook/scheduling/bootstrap-system-priority-classes",
    "/readyz/poststarthook/start-apiextensions-controllers",
    "/readyz/poststarthook/start-apiextensions-informers",
    "/readyz/poststarthook/start-cluster-authentication-info-controller",
    "/readyz/poststarthook/start-kube-aggregator-informers",
    "/readyz/poststarthook/start-kube-apiserver-admission-initializer",
    "/readyz/shutdown",
    "/version"
  ]
}

```

##### 63 Practice External Apiserver Access

###### Send API request from outside

**Make Kuberntes API reachable from the outside**

access using kubectl (copy kubeconfig)



kubectl(client cert) ===Rquest(https)===>  API Server(server cert)

CA(scope): https,server cert, API Server



```sh
root@cks-master:~# k get svc | grep kubernetes
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP   23d


root@cks-master:~# k edit svc kubernetes
# before
------------------------
  type: ClusterIP
------------------------  
#after
------------------------  
  type: NodePort
------------------------

root@cks-master:~# k get svc | grep kubernetes
kubernetes   NodePort    10.96.0.1        <none>        443:31234/TCP   23d


# from master node
k config view --raw > conf

# inspect apiserver cert
cd /etc/kubernetes/pki
openssl x509 -in apiserver.crt -text




# copy conf file to local server
# from local server
k --kubeconfig conf get ns

#add the ip to hosts
sudo vim /etc/hosts
$wokers externalIP kubernetes

#change ExternalIP to kubernetes
vim conf

k --kubeconfig conf get ns

```

##### 64 NodeRestriction AdmissionController

- Admission Controller
  - kube-apiserver --enable-admission-plugins=NodeRestriction
  - Limits the Node labels a kubelet can modify
- Ensure secure workload isolation via labels
  - No one can pretend to be a "secure" node and schedule secure pods(why?)

##### 65 Practice Verify NodeRestriction

###### NodeRestriction in action

**Verify the NodeRestriciton works**

Use worker node kubelet kubeconfig to set labels

```sh
root@cks-master:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission
    - --enable-admission-plugins=NodeRestriction



root@cks-worker:~# k config view
apiVersion: v1
clusters: null
contexts: null
current-context: ""
kind: Config
preferences: {}
users: null

root@cks-worker:~# export KUBECONFIG=/etc/kubernetes/kubelet.conf
root@cks-worker:~# k get ns
Error from server (Forbidden): namespaces is forbidden: User "system:node:cks-worker" cannot list resource "namespaces" in API group "" at the cluster scope


root@cks-worker:~# k label node cks-master cks/test=yes
Error from server (Forbidden): nodes "cks-master" is forbidden: node "cks-worker" is not allowed to modify node "cks-master"

root@cks-worker:~# k label node cks-worker cks/test=yes
node/cks-worker labeled


root@cks-worker:~# k label node cks-worker node-restriction.kubernetes.io/test=yes
Error from server (Forbidden): nodes "cks-worker" is forbidden: is not allowed to modify labels: node-restriction.kubernetes.io/test

```



##### 66 Recap

- Outside -> API
- Pod -> API
- Node -> API
- Anonymous access
- Insecure access
- Certificates

[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/concepts/security/controlling-access)

#### Section 14 Cluster Hardening Upgrade Kubernetes

##### 67 Intro

###### Why Update Kubernetes Frequently

- Release Cycles
- Version differences of components
- Upgrade

###### Why upgrade frequently

- Support
- Security fixes
- Bug fixes
- Stay up to date for dependencies

###### Kubernetes Release Cycles

major.minor.patch => 1.19.2

- Minor version every 3 months
- No LTS(Long Term Support)

###### Support

> Maintenance release branches for the most recent three minor releases(1.19,1.18,1.17)

Applicable fixes,including security fixes, may be backported to those three release branches, 

depending on severity and feasibility.

###### How to upgrade a cluster

- First upgrade the master components
  - apiserver,controller-manager,scheduler
- Then the worker components
  - kubelet,kube-proxy
- Components same minor version as apiserver

###### Possible Version Differences

###### Sequence

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |           |           |                    |
| 1.17    | Apiserver | Scheduler | Controller-Manager |

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |     Apiserver      |           |                    |
| 1.17    |  | Scheduler | Controller-Manager |

| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |  Apiserver         |    Scheduler       |                    |
| 1.17    |  |  | Controller-Manager |


| Version |           |           |                    |
| ------- | --------- | --------- | ------------------ |
| 1.19    |           |           |                    |
| 1.18    |  Apiserver         |    Scheduler       |  Controller-Manager                  |
| 1.17    |  |  |  |


| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    |           |           |                    |                    | kubectl |
| 1.18    |  Apiserver         |    Scheduler       |  Controller-Manager                  |                    |                    |
| 1.17    |  |  |  | Kubelet Kube-Proxy |  |

| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager |                    | kubectl |
| 1.18    |           |           |                    |                    |                    |
| 1.17    |  |  |  | Kubelet Kube-Proxy |  |


| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager |                    | kubectl |
| 1.18    |           |           |                    | Kubelet Kube-Proxy |                    |
| 1.17    |  |  |  |  |  |



| Version |           |           |                    |                    |  |
| ------- | --------- | --------- | ------------------ | ------------------ | ------------------ |
| 1.19    | Apiserver | Scheduler | Controller-Manager | Kubelet Kube-Proxy | kubectl |
| 1.18    |           |           |                    |  |                    |
| 1.17    |  |  |  |  |  |
##### Version differences - Rule of thumb

**Components same minor version as apiserver or one below**

###### How to upgrade a node

1. kubectl drain(排出)
   - Safety evict all pods from node
   - Mark node as SchedulingDisabled(kubectl cordon(包围隔离))
2. Do the upgrade
3. kubectl uncordon
   - Unmark（去掉标记） node as SchedulingDisabled

###### How to make your application survive(幸存) an upgrade

- Pod gracePeriod / Terminating state
- Pod Lifecycle Events
- PodDisruptionBudget(破坏预算)

##### 68. Practice Create outdated cluster

###### Create an outdated cluster

**Install an earlier version of k8s in our cluster**



```sh
# master
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/previous/install_master.sh)

# worker
bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/cluster-setup/previous/install_worker.sh)

#copy to worker and excute
kubeadm join 10.146.0.2:6443 --token $token     --discovery-token-ca-cert-hash $sha256


root@cks-master:~# kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
cks-master   Ready    master   95s   v1.19.7
cks-worker   Ready    <none>   14s   v1.19.7

```

##### 69 Practice Upgrade master node

###### Upgrade a cluster

**Upgrade the master to one minor version up**

```sh
# get error
root@cks-master:~# k drain cks-master
node/cks-master cordoned
error: unable to drain node "cks-master", aborting command...

There are pending nodes to be drained:
 cks-master
error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/kube-proxy-hkg42, kube-system/weave-net-d56rj


root@cks-master:~# k drain cks-master --ignore-daemonsets
node/cks-master already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-hkg42, kube-system/weave-net-d56rj
evicting pod kube-system/coredns-f9fd979d6-f7sc6
evicting pod kube-system/coredns-f9fd979d6-4p45l
pod/coredns-f9fd979d6-f7sc6 evicted
pod/coredns-f9fd979d6-4p45l evicted
node/cks-master evicted


root@cks-master:~# k get node
NAME         STATUS                     ROLES    AGE     VERSION
cks-master   Ready,SchedulingDisabled   master   6m47s   v1.19.7
cks-worker   Ready                      <none>   5m26s   v1.19.7


root@cks-master:~# apt-cache show kubeadm  | grep 1.20
Version: 1.20.4-00
Filename: pool/kubeadm_1.20.4-00_amd64_27807dfe9734d69677bc6a0a8daf84042d51ee42a984f9181d3c91cc037d19ce.deb
Version: 1.20.2-00
Filename: pool/kubeadm_1.20.2-00_amd64_38fa4593055ef1161d4cb322437eedda95186fb850819421b8cf75f3a943dc51.deb
Version: 1.20.1-00
Filename: pool/kubeadm_1.20.1-00_amd64_7cd8d4021bb251862b755ed9c240091a532b89e6c796d58c3fdea7c9a72b878f.deb
Version: 1.20.0-00
Filename: pool/kubeadm_1.20.0-00_amd64_18afc5e3855cf5aaef0dbdfd1b3304f9e8e571b3c4e43b5dc97c439d62a3321a.deb
Size: 8152068
Filename: pool/kubeadm_1.5.7-00_amd64_2759fc99e5b23e44c92b44c506ed9cc1c2087780786bfa97c715da02da84c55d.deb
SHA256: 2759fc99e5b23e44c92b44c506ed9cc1c2087780786bfa97c715da02da84c55d

root@cks-master:~# apt-get install kubeadm=1.20.2-00 kubelet=1.20.2-00 kubectl=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm kubectl kubelet
3 upgraded, 0 newly installed, 0 to remove and 14 not upgraded.
Need to get 0 B/34.5 MB of archives.
After this operation, 1517 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubelet_1.20.2-00_amd64.deb ...
Unpacking kubelet (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubectl_1.20.2-00_amd64.deb ...
Unpacking kubectl (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubeadm_1.20.2-00_amd64.deb ...
Unpacking kubeadm (1.20.2-00) over (1.19.7-00) ...
Setting up kubelet (1.20.2-00) ...
Setting up kubectl (1.20.2-00) ...
Setting up kubeadm (1.20.2-00) ...


root@cks-master:~# kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.19.7
[upgrade/versions] kubeadm version: v1.20.2
[upgrade/versions] Latest stable version: v1.20.4
[upgrade/versions] Latest stable version: v1.20.4
[upgrade/versions] Latest version in the v1.19 series: v1.19.8
[upgrade/versions] Latest version in the v1.19 series: v1.19.8

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
kubelet     1 x v1.19.7   v1.19.8
            1 x v1.20.2   v1.19.8

Upgrade to the latest version in the v1.19 series:

COMPONENT                 CURRENT    AVAILABLE
kube-apiserver            v1.19.7    v1.19.8
kube-controller-manager   v1.19.7    v1.19.8
kube-scheduler            v1.19.7    v1.19.8
kube-proxy                v1.19.7    v1.19.8
CoreDNS                   1.7.0      1.7.0
etcd                      3.4.13-0   3.4.13-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.19.8

_____________________________________________________________________

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
kubelet     1 x v1.19.7   v1.20.4
            1 x v1.20.2   v1.20.4

Upgrade to the latest stable version:

COMPONENT                 CURRENT    AVAILABLE
kube-apiserver            v1.19.7    v1.20.4
kube-controller-manager   v1.19.7    v1.20.4
kube-scheduler            v1.19.7    v1.20.4
kube-proxy                v1.19.7    v1.20.4
CoreDNS                   1.7.0      1.7.0
etcd                      3.4.13-0   3.4.13-0

You can now apply the upgrade by executing the following command:

        kubeadm upgrade apply v1.20.4

Note: Before you can perform this upgrade, you have to update kubeadm to v1.20.4.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________


root@cks-master:~#kubeadm upgrade apply v1.20.2
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.20.2"
[upgrade/versions] Cluster version: v1.19.7
[upgrade/versions] kubeadm version: v1.20.2
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.20.2"...
Static pod: kube-apiserver-cks-master hash: 061027db0e88e3657f1ab490806403c1
Static pod: kube-controller-manager-cks-master hash: 1c77e9039eeb896c6eb9619eb25efa58
Static pod: kube-scheduler-cks-master hash: 57b58b3eb5589cb745c50233392349fb
[upgrade/etcd] Upgrading to TLS for etcd
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
Static pod: etcd-cks-master hash: c970a064d0fe1e6f97b36ff70f3c431e
Static pod: etcd-cks-master hash: 6f9ca4ac97cad368cd838eebb7e01a6f
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests174344580"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-apiserver-cks-master hash: 061027db0e88e3657f1ab490806403c1
Static pod: kube-apiserver-cks-master hash: f6c58610040386ba7cf06646b052f201
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-controller-manager-cks-master hash: 1c77e9039eeb896c6eb9619eb25efa58
Static pod: kube-controller-manager-cks-master hash: 1a3810fb74d35de2490ad0c288bb67f6
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-03-09-23-22-23/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-scheduler-cks-master hash: 57b58b3eb5589cb745c50233392349fb
Static pod: kube-scheduler-cks-master hash: 69cd289b4ed80ced4f95a59ff60fa102
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upgrade/postupgrade] Applying label node-role.kubernetes.io/control-plane='' to Nodes with label node-role.kubernetes.io/master='' (deprecated)
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.20" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.20.2". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.

root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready,SchedulingDisabled   control-plane,master   17m   v1.20.2
cks-worker   Ready                      <none>                 15m   v1.19.7

# unable cordon(取消隔离)
root@cks-master:~# k  uncordon cks-master
node/cks-master uncordoned


root@cks-master:~# k get node
NAME         STATUS   ROLES                  AGE   VERSION
cks-master   Ready    control-plane,master   19m   v1.20.2
cks-worker   Ready    <none>                 18m   v1.19.7
```



##### 70 Practice Upgrade worker node

**cks-master**

```sh
root@cks-master:~# k drain cks-worker
node/cks-worker cordoned
error: unable to drain node "cks-worker", aborting command...

There are pending nodes to be drained:
 cks-worker
error: cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/kube-proxy-rmqgx, kube-system/weave-net-nngrx

root@cks-master:~# k drain cks-worker  --ignore-daemonsets
node/cks-worker already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-proxy-rmqgx, kube-system/weave-net-nngrx
evicting pod kube-system/coredns-74ff55c5b-lvdbz
evicting pod kube-system/coredns-74ff55c5b-6b88q
pod/coredns-74ff55c5b-6b88q evicted
pod/coredns-74ff55c5b-lvdbz evicted
node/cks-worker evicted


root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready                      control-plane,master   22m   v1.20.2
cks-worker   Ready,SchedulingDisabled   <none>                 21m   v1.19.7

```

**cks-worker**

```sh
root@cks-worker:~# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.7", GitCommit:"1dd5338295409edcfff11505e7bb246f0d325d15", GitTreeState:"clean", BuildDate:"2021-01-13T13:21:39Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}

root@cks-worker:~# apt-get install kubeadm=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 16 not upgraded.
Need to get 0 B/7706 kB of archives.
After this operation, 160 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.20.2-00_amd64.deb ...
Unpacking kubeadm (1.20.2-00) over (1.19.7-00) ...
Setting up kubeadm (1.20.2-00) ...



root@cks-worker:~# apt-cache show kubeadm  | grep 1.20.2
Version: 1.20.2-00
Filename: pool/kubeadm_1.20.2-00_amd64_38fa4593055ef1161d4cb322437eedda95186fb850819421b8cf75f3a943dc51.deb


root@cks-worker:~# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:25:59Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}


root@cks-worker:~# kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks
[preflight] Skipping prepull. Not a control plane node.
[upgrade] Skipping phase. Not a control plane node.
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.


root@cks-worker:~# apt-get install kubelet=1.20.2-00 kubectl=1.20.2-00
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 15 not upgraded.
Need to get 0 B/26.8 MB of archives.
After this operation, 1357 kB of additional disk space will be used.
(Reading database ... 106960 files and directories currently installed.)
Preparing to unpack .../kubectl_1.20.2-00_amd64.deb ...
Unpacking kubectl (1.20.2-00) over (1.19.7-00) ...
Preparing to unpack .../kubelet_1.20.2-00_amd64.deb ...
Unpacking kubelet (1.20.2-00) over (1.19.7-00) ...
Setting up kubelet (1.20.2-00) ...
Setting up kubectl (1.20.2-00) ...


root@cks-worker:~# kubelet --version
Kubernetes v1.20.2

root@cks-worker:~# kubectl version
Client Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:28:09Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?

root@cks-master:~# k get node
NAME         STATUS                     ROLES                  AGE   VERSION
cks-master   Ready                      control-plane,master   30m   v1.20.2
cks-worker   Ready,SchedulingDisabled   <none>                 29m   v1.20.2


root@cks-master:~# k uncordon cks-worker
node/cks-worker uncordoned

root@cks-master:~# k get node
NAME         STATUS   ROLES                  AGE   VERSION
cks-master   Ready    control-plane,master   31m   v1.20.2
cks-worker   Ready    <none>                 29m   v1.20.2

```

###### Upgrade a cluster

**Upgrade the worker to match with master**

##### 71 Recap

**kubeadm upgrade**
https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade

**k8s versions**
https://kubernetes.io/docs/setup/release/version-skew-policy

#### Section 15 Microservice Vunerabilites - Manage Kubernetes Secrets
##### 72. Intro

- Overview
- Create Secure Secret Scenario
- Hack some Secrets

##### Introduction

**Secret**

- Passwords
- API keys
- Credentials
- Information needed by an application

###### Introduction Secrets

![](./images/Section15/Screenshot_1.png)

![](./images/Section15/Screenshot_2.png)

Introduction K8S Secretes

![](./images/Section15/Screenshot_3.png)



##### 73. Create Simple Secret Scenario

###### Simple Secret Scenario

![](./images/Section15/Screenshot_4.png)

```sh
root@cks-master:~# k create secret generic secret1 --from-literal user=admin
secret/secret1 created


root@cks-master:~# k create secret generic secret2 --from-literal pass=123abc
secret/secret2 created


root@cks-master:~# k run pod --image=nginx -oyaml --dry-run=client
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - image: nginx
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

*1
*2

root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - image: nginx
    name: pod
    resources: {}
    env:
      - name: PASSWORD
        valueFrom:
          secretKeyRef:
            name: secret2
            key: pass
    volumeMounts:
    - name: secret1
      mountPath: "/etc/secret1"
      readOnly: true
  volumes:
  - name: secret1
    secret:
      secretName: secret1
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
pod/pod created
root@cks-master:~# k get pod
NAME   READY   STATUS              RESTARTS   AGE
pod    0/1     ContainerCreating   0          4s
root@cks-master:~# k get pod
NAME   READY   STATUS    RESTARTS   AGE
pod    1/1     Running   0          9s

root@cks-master:~# k exec pod -- env | grep PASS
PASSWORD=123abc

root@cks-master:~# k exec pod -- mount | grep secret1
tmpfs on /etc/secret1 type tmpfs (ro,relatime)


root@cks-master:~# k exec pod -- find /etc/secret1
/etc/secret1
/etc/secret1/..data
/etc/secret1/user
/etc/secret1/..2021_03_10_23_26_20.879551704
/etc/secret1/..2021_03_10_23_26_20.879551704/use

root@cks-master:~# k exec pod -- cat /etc/secret1/user
adminr
```

[*1](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-files-from-a-pod)

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

[*2](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets-as-environment-variables)

```sh
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password
  restartPolicy: Never
```

##### 74. Practice - Hack Secrets in Docker

Secrets and docker

![](./images/Section15/Screenshot_5.png)

```sh
root@cks-master:~# k get pod
NAME   READY   STATUS    RESTARTS   AGE
pod    1/1     Running   1          23h

# get the password
root@cks-worker:~# docker ps | grep nginx
d22f3301ee10        nginx                  "/docker-entrypoint.…"   13 minutes ago      Up 13 minutes                           k8s_pod_pod_default_e4de83c9-33c6-405d-a07f-6222e0da74fb_1
root@cks-worker:~# docker inspect d22f3301ee10
[
    {
        "Id": "d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af",
        "Created": "2021-03-11T22:35:22.073987855Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 4917,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-03-11T22:35:22.761475008Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:018aec2b4f302b08b4c7274b72bede1fe56ee1f2bcaa06492e3f464e05f1a9a8",
        "ResolvConfPath": "/var/lib/docker/containers/f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465/hostname",
        "HostsPath": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts",
        "LogPath": "/var/lib/docker/containers/d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af/d22f3301ee100eb972cc3da360238f8fcd987a1b3f1c1ad887659ac3ee3406af-json.log",
        "Name": "/k8s_pod_pod_default_e4de83c9-33c6-405d-a07f-6222e0da74fb_1",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/secret1:/etc/secret1:ro",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/default-token-twdg9:/var/run/secrets/kubernetes.io/serviceaccount:ro",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts:/etc/hosts",
                "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/containers/pod/456fcbd6:/dev/termination-log"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "container:f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
            "PortBindings": null,
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "container:f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 1000,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": [
                "seccomp=unconfined"
            ],
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 2,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "kubepods-besteffort-pode4de83c9_33c6_405d_a07f_6222e0da74fb.slice",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 100000,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/asound",
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658-init/diff:/var/lib/docker/overlay2/f8b80781ff34b860377540a924b9f966a4086dabf23fb9d92a52e23696fdd423/diff:/var/lib/docker/overlay2/b90eb53458a074f7b404a6a3720886439296e57aff1587e8bd21b549109d0d51/diff:/var/lib/docker/overlay2/ed7c61f17f6404f4be564fe313f691a5a7722726631f6ad4788872205ba3532d/diff:/var/lib/docker/overlay2/7d07bc8b69a87b5514b2efdf23d82d78bf2800806c839f30d5be3b03306cb75e/diff:/var/lib/docker/overlay2/ba51ab1c3cdb1ecebfb7afe6784c67b1682faa097511406bd54391a0720c4458/diff:/var/lib/docker/overlay2/ab81512a9bd8e92779ac490254ce02e81a10d519ea111aaa76388e189cbef64e/diff",
                "MergedDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/merged",
                "UpperDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/diff",
                "WorkDir": "/var/lib/docker/overlay2/73379f394014a7e41c5aade53913c3aa55d335884ee57d4b0ff5ebd3a49a0658/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/secret1",
                "Destination": "/etc/secret1",
                "Mode": "ro",
                "RW": false,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/volumes/kubernetes.io~secret/default-token-twdg9",
                "Destination": "/var/run/secrets/kubernetes.io/serviceaccount",
                "Mode": "ro",
                "RW": false,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/etc-hosts",
                "Destination": "/etc/hosts",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            },
            {
                "Type": "bind",
                "Source": "/var/lib/kubelet/pods/e4de83c9-33c6-405d-a07f-6222e0da74fb/containers/pod/456fcbd6",
                "Destination": "/dev/termination-log",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        "Config": {
            "Hostname": "pod",
            "Domainname": "",
            "User": "0",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PASSWORD=123abc",
                "KUBERNETES_SERVICE_PORT=443",
                "KUBERNETES_SERVICE_PORT_HTTPS=443",
                "KUBERNETES_PORT=tcp://10.96.0.1:443",
                "KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443",
                "KUBERNETES_PORT_443_TCP_PROTO=tcp",
                "KUBERNETES_PORT_443_TCP_PORT=443",
                "KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1",
                "KUBERNETES_SERVICE_HOST=10.96.0.1",
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.19.8",
                "NJS_VERSION=0.5.2",
                "PKG_RELEASE=1~buster"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Healthcheck": {
                "Test": [
                    "NONE"
                ]
            },
            "Image": "nginx@sha256:d5b6b094a614448aa0c48498936f25073dc270e12f5fcad5dc11e7f053e73026",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "annotation.io.kubernetes.container.hash": "9818bb8d",
                "annotation.io.kubernetes.container.restartCount": "1",
                "annotation.io.kubernetes.container.terminationMessagePath": "/dev/termination-log",
                "annotation.io.kubernetes.container.terminationMessagePolicy": "File",
                "annotation.io.kubernetes.pod.terminationGracePeriod": "30",
                "io.kubernetes.container.logpath": "/var/log/pods/default_pod_e4de83c9-33c6-405d-a07f-6222e0da74fb/pod/1.log",
                "io.kubernetes.container.name": "pod",
                "io.kubernetes.docker.type": "container",
                "io.kubernetes.pod.name": "pod",
                "io.kubernetes.pod.namespace": "default",
                "io.kubernetes.pod.uid": "e4de83c9-33c6-405d-a07f-6222e0da74fb",
                "io.kubernetes.sandbox.id": "f53d30c1346108d955b1249b7475efa7b27657ce72127299932fbcbd5b6df465",
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {}
        }
    }
]

#get the user name
root@cks-worker:~# docker cp d22f3301ee10:/etc/secret1 secret1
root@cks-worker:~# cat secret1/user
admin
```

##### 75.Practice Hack Secrets in ETCD

###### Secrets and etcd

![](./images/Section15/Screenshot_6.png)

```sh
root@cks-master:~# ETCDCTL_API=3 etcdctl endpoint health
127.0.0.1:2379 is unhealthy: failed to commit proposal: context deadline exceeded
Error:  unhealthy cluster




# access secret int etcd
root@cks-master:~# cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379


root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt endpoint health
127.0.0.1:2379 is healthy: successfully committed proposal: took = 1.132134ms

# --endpoints "https://127.0.0.1:2379" not necessary because we’re on same node

# get username and password
root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/secret1
/registry/secrets/default/secret1
k8s

v1Secret▒
▒
secret1default"*$c61cd235-6133-4487-8e56-772648f27d802▒▒▒▒z▒_
kubectl-createUpdatev▒▒▒▒FieldsV1:-
+{"f:data":{".":{},"f:user":{}},"f:type":{}}
useradminOpaque"
root@cks-master:~# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/secret2
/registry/secrets/default/secret2
k8s

v1Secret▒
▒
secret2default"*$b314de1d-4b59-42ec-b9ee-8d185944ca602▒▒▒▒z▒_
kubectl-createUpdatev▒▒▒▒FieldsV1:-
+{"f:data":{".":{},"f:pass":{}},"f:type":{}}
pass123abcOpaque"

```

###### 76. ETCD Encryption

###### Encrypt etcd



![](./images/Section15/Screenshot_7.png)

![](./images/Section15/Screenshot_8.png)

###### Encrypt (all Secrets) in etcd

![](./images/Section15/Screenshot_9.png)

```sh
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

![](./images/Section15/Screenshot_10.png)


```sh
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

##### 77. Practice Encrypt ETCD

###### Encrypt etcd

**Encrypt Secrets in ETCD at rest and test it**

> Encrypt all existing secrets using **aescbc** and a password of our choice

```sh
marsforever@cks-master:~$ sudo -i
root@cks-master:~# cd /etc/kubernetes/
root@cks-master:/etc/kubernetes# mkdir etcd
root@cks-master:/etc/kubernetes# cd etcd/
#※1
root@cks-master:/etc/kubernetes/etcd# vim ec.yaml

#add the string to ec.yaml's secret
root@cks-master:/etc/kubernetes/etcd# echo -n password | base64
cGFzc3dvcmQ=

root@cks-master:/etc/kubernetes/etcd# cat ec.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
    - secrets
    providers:
    - aescbc:
        keys:
        - name: key1
          secret: cGFzc3dvcmQ=
    - identity: {}


```

######  ※1 encrypt etcd docs page contains also example on how to read etcd secret
https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#encrypting-your-data



```sh
root@cks-master:/etc/kubernetes/etcd# cd ..
root@cks-master:/etc/kubernetes# cd manifests/
root@cks-master:/etc/kubernetes/manifests# vim kube-apiserver.yaml
spec:
  containers:
  - command:
    - kube-apiserver
#add the new line    
    - --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml
#add the new lines
#mount the path
    - mountPath: /etc/kubernetes/etcd
      name: etcd
      readOnly: true    
#add the new lines
#set the folder
  - hostPath:
      path: /etc/kubernetes/etcd
      type: DirectoryOrCreate
    name: etcd

root@cks-master:/etc/kubernetes/manifests# cd /var/log/pods
root@cks-master:/var/log/pods# tail -f kube-system_kube-apiserver-cks-master_b2f2c7bbaa5a0c135c9ebc4de2eac4ad/kube-apiserver/4.log
{"log":"Flag --insecure-port has been deprecated, This flag has no effect now and will be removed in v1.24.\n","stream":"stderr","time":"2021-03-13T03:44:50.913649642Z"}
{"log":"I0313 03:44:50.913659       1 server.go:632] external host was not specified, using 10.146.0.2\n","stream":"stderr","time":"2021-03-13T03:44:50.913789379Z"}
{"log":"I0313 03:44:50.914290       1 server.go:182] Version: v1.20.2\n","stream":"stderr","time":"2021-03-13T03:44:50.914394666Z"}
{"log":"Error: error while parsing encryption provider configuration file \"/etc/kubernetes/etcd/ec.yaml\": error while parsing file: resources[0].providers[0].aescbc.keys[0].secret: Invalid value: \"REDACTED\": secret is not of the expected length, got 8, expected one of [16 24 32]\n","stream":"stderr","time":"2021-03-13T03:44:51.375760488Z"}

root@cks-master:/var/log/pods# cd /etc/kubernetes/etcd/
root@cks-master:/etc/kubernetes/etcd# vim ec.yaml
root@cks-master:/etc/kubernetes/etcd# echo -n passwordpassword | base64
cGFzc3dvcmRwYXNzd29yZA==

root@cks-master:/etc/kubernetes/etcd# cd /var/log/pods/
root@cks-master:/var/log/pods# tail -f kube-system_kube-apiserver-cks-master_b2f2c7bbaa5a0c135c9ebc4de2eac4ad/kube-apiserver/5.log
{"log":"Flag --insecure-port has been deprecated, This flag has no effect now and will be removed in v1.24.\n","stream":"stderr","time":"2021-03-13T03:46:21.962286244Z"}
{"log":"I0313 03:46:21.962567       1 server.go:632] external host was not specified, using 10.146.0.2\n","stream":"stderr","time":"2021-03-13T03:46:21.962910321Z"}
{"log":"I0313 03:46:21.963460       1 server.go:182] Version: v1.20.2\n","stream":"stderr","time":"2021-03-13T03:46:21.963551658Z"}
{"log":"Error: error while parsing encryption provider configuration file \"/etc/kubernetes/etcd/ec.yaml\": error while parsing file: resources[0].providers[0].aescbc.keys[0].secret: Invalid value: \"REDACTED\": secret is not of the expected length, got 8, expected one of [16 24 32]\n","stream":"stderr","time":"2021-03-13T03:46:22.364017822Z"}

#Restart kube api server
root@cks-master:/var/log/pods# cd -
/etc/kubernetes/etcd
root@cks-master:/etc/kubernetes/etcd# cd ../manifests/
root@cks-master:/etc/kubernetes/manifests# mv kube-apiserver.yaml ..
# check the apiserver is stopped
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26261  0.0  0.0  14860  1004 pts/0    S+   03:50   0:00 grep --color=auto apiserver
root@cks-master:/etc/kubernetes/manifests# mv ../kube-apiserver.yaml .
root@cks-master:/etc/kubernetes/manifests# ls
etcd.yaml            kube-controller-manager.yaml
kube-apiserver.yaml  kube-scheduler.yaml
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26786 76.2  7.9 1097096 321824 ?      Ssl  03:52   0:06 kube-apiserver --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml --advertise-address=10.146.0.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root     26851  0.0  0.0  14860  1092 pts/0    R+   03:52   0:00 grep --color=auto apiserver

root@cks-master:/etc/kubernetes/manifests# k get secret
NAME                  TYPE                                  DATA   AGE
default-token-twdg9   kubernetes.io/service-account-token   3      3d4h
secret1               Opaque                                1      2d4h
secret2               Opaque                                1      2d4h

root@cks-master:/etc/kubernetes/manifests#k get secret default-token-twdg9 -oyaml
apiVersion: v1
data:
  ca.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ETXdPVEl6TURZek5Gb1hEVE14TURNd056SXpNRFl6TkZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT1QvCkR4T0VzdmxNTThCVk8zU3lCc2hVcHpyTkRjU25qOHRrUXhQN3lNSldKeW9mMEltQXR3bU5xWlJKYUd4NTB4VEgKdHl5eHNGVWRiems0RTZJbEpmSHJzMllhRVhOdk1ZSDNrZlErWHdIVFNNaTlXNkNheWNQd0NaVlV3QUJyY3lpMgpybXowMEpoTlZuMnZaTFJYSUtTaTlFNTJsaGI1cEdUdUFTVXdGU0FGMWltZGY4ZSt1ejhHUWhJSTE1bUFMcGJYCmw1clJYUERiR05XSHhCaCtXWUY3aEROemtpQXJyNjZ4VE5TV1RORUhPK0xuNGlSRWpQYW1LS1FnSnQrNTNKOHEKTTI4bmR2QnBrUnRtelhjRXlZTzdXdG9RWkpiUHN2TmNCZUN3M2toRWFQQU9zZmwvaytSWlhmSVd1eHFIK2xuMgpSRTJDTVlZL1lXVitXTHNtTU1FQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDeWdiM0hEc3I2bkxCa2hucXZGWmlBZkRYVmRNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBK1VYS2RoWGgvTDE0STlqVlV4RDlBTTg3NzllMWdvZlgvcnVsY3loa1haYXc3cWtuZQpUellWOFJDc3p6U3hQYjl1c1pxSjZJenFVQ3pFUDYrVmYrM0JSM1BLQWZacDU5c1M1ZTJUSThSYTAxanpxcWcvClJwb081TjFoRGUwVnpOaDI0ZkhQTTMrUHUwTWZ3VUJJUU9CWHRBUXZyd2dUbWNEenV6QzdNcUlic2pjUkw3VjUKREdqcG1rZm14VkRKN1l4UnUyT2FLWTNicE50TTRMYVlkb0JoQWRXWXl5WU1ZME1mMXN2ODJwMUlIRVhYTWFTWQptVnlGVlZHZDBBZTFzNSt2OE05TmdpV3FVdUUzaFoxalJsNTI2ZHgxSlpqbVlkZTl3WkZwMmVmVjFMWExOcUJmCmNaMlJjSEh4TnQ4clArVlBoVERiTzlOVjZxUVpQejdvYkk3ZAotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  namespace: ZGVmYXVsdA==
  token: ZXlKaGJHY2lPaUpTVXpJMU5pSXNJbXRwWkNJNklsSnBOemxEYmtsTFFUWldhMnBDYTJWak5pMVZhbkExVDIwNGN5MWlRbkp6VWsxeGVtbDJXbFZRYUZVaWZRLmV5SnBjM01pT2lKcmRXSmxjbTVsZEdWekwzTmxjblpwWTJWaFkyTnZkVzUwSWl3aWEzVmlaWEp1WlhSbGN5NXBieTl6WlhKMmFXTmxZV05qYjNWdWRDOXVZVzFsYzNCaFkyVWlPaUprWldaaGRXeDBJaXdpYTNWaVpYSnVaWFJsY3k1cGJ5OXpaWEoyYVdObFlXTmpiM1Z1ZEM5elpXTnlaWFF1Ym1GdFpTSTZJbVJsWm1GMWJIUXRkRzlyWlc0dGRIZGtaemtpTENKcmRXSmxjbTVsZEdWekxtbHZMM05sY25acFkyVmhZMk52ZFc1MEwzTmxjblpwWTJVdFlXTmpiM1Z1ZEM1dVlXMWxJam9pWkdWbVlYVnNkQ0lzSW10MVltVnlibVYwWlhNdWFXOHZjMlZ5ZG1salpXRmpZMjkxYm5RdmMyVnlkbWxqWlMxaFkyTnZkVzUwTG5WcFpDSTZJakUzTkRaaU1qUTRMVEZpWXpVdE5EVXlOeTFpTldGbUxUSTRPRGhoTm1FNVlUZzJaQ0lzSW5OMVlpSTZJbk41YzNSbGJUcHpaWEoyYVdObFlXTmpiM1Z1ZERwa1pXWmhkV3gwT21SbFptRjFiSFFpZlEudmFoVDFBS3g4RlVoMXJBOG4tTk96TEd6UXFhU1JuMFRBNC1zSzBzZXdydGs4SjhRNFBDbmlqV01KT0RaSTl0ajJlV2dJd284R2JPa1YtanNSeEl5MFV4WFNYb3hhOTl5WFlyZnJEdjFSS1V5UXowUVJlTGh4UnBUS0FnTGpLcU95b1pNQ1hlbWM5Z21mSUNzQ3JjVzE5Q3o4NlFyN2pvazhSNVhPRGFKb256SWowTTNhSFJ3U3FyVDFJTElmdFpLdk9NUXBlRHhCZVQ4aXU1N0piZXFEb1pSR09PbFh2SFZwUzdsel95dTcwU2ZadUNwc29NVURjLXJvYTdZdk5EZDBJb3E5U05mazZvRGotU0FRMk5SUy1ETUpobW5BWWl3bV85NFI5amFFcXEzMzV5allYdHNWTFJSMHFjRGs3ZzNLSklOZHRZTnBuam5mWXNQMGdnQjRn
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: default
    kubernetes.io/service-account.uid: 1746b248-1bc5-4527-b5af-2888a6a9a86d
  creationTimestamp: "2021-03-09T23:07:01Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:ca.crt: {}
        f:namespace: {}
        f:token: {}
      f:metadata:
        f:annotations:
          .: {}
          f:kubernetes.io/service-account.name: {}
          f:kubernetes.io/service-account.uid: {}
      f:type: {}
    manager: kube-controller-manager
    operation: Update
    time: "2021-03-09T23:07:01Z"
  name: default-token-twdg9
  namespace: default
  resourceVersion: "353"
  uid: 47c8f77f-02aa-4b69-9444-19818b562105
type: kubernetes.io/service-account-token

```



--encryption-provider-config

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#configuration-and-determining-whether-encryption-at-rest-is-already-enabled



###### read secret from etcd

https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#verifying-that-data-is-encrypted

ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/very-secure



```sh
root@cks-master:/etc/kubernetes/manifests# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/default-token-twdg9
/registry/secrets/default/default-token-twdg9
k8s

v1Secret▒
▒
default-token-twdg9default"*$47c8f77f-02aa-4b69-9444-19818b5621052▒▒▒▒b-
"kubernetes.io/service-account.namedefaultbI
!kubernetes.io/service-account.uid$1746b248-1bc5-4527-b5af-2888a6a9a86dz▒▒
kube-controller-managerUpdatev▒▒▒▒FieldsV1:▒
▒{"f:data":{".":{},"f:ca.crt":{},"f:namespace":{},"f:token":{}},"f:metadata":{"f:annotations":{".":{},"f:kubernetes.io/service-account.name":{},"f:kubernetes.io/service-account.uid":{}}},"f:type":{}}▒
ca.crt-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIxMDMwOTIzMDYzNFoXDTMxMDMwNzIzMDYzNFowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOT/
DxOEsvlMM8BVO3SyBshUpzrNDcSnj8tkQxP7yMJWJyof0ImAtwmNqZRJaGx50xTH
tyyxsFUdbzk4E6IlJfHrs2YaEXNvMYH3kfQ+XwHTSMi9W6CaycPwCZVUwABrcyi2
rmz00JhNVn2vZLRXIKSi9E52lhb5pGTuASUwFSAF1imdf8e+uz8GQhII15mALpbX
l5rRXPDbGNWHxBh+WYF7hDNzkiArr66xTNSWTNEHO+Ln4iREjPamKKQgJt+53J8q
M28ndvBpkRtmzXcEyYO7WtoQZJbPsvNcBeCw3khEaPAOsfl/k+RZXfIWuxqH+ln2
RE2CMYY/YWV+WLsmMMECAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFCygb3HDsr6nLBkhnqvFZiAfDXVdMA0GCSqGSIb3
DQEBCwUAA4IBAQA+UXKdhXh/L14I9jVUxD9AM8779e1gofX/rulcyhkXZaw7qkne
TzYV8RCszzSxPb9usZqJ6IzqUCzEP6+Vf+3BR3PKAfZp59sS5e2TI8Ra01jzqqg/
RpoO5N1hDe0VzNh24fHPM3+Pu0MfwUBIQOBXtAQvrwgTmcDzuzC7MqIbsjcRL7V5
DGjpmkfmxVDJ7YxRu2OaKY3bpNtM4LaYdoBhAdWYyyYMY0Mf1sv82p1IHEXXMaSY
mVyFVVGd0Ae1s5+v8M9NgiWqUuE3hZ1jRl526dx1JZjmYde9wZFp2efV1LXLNqBf
cZ2RcHHxNt8rP+VPhTDbO9NV6qQZPz7obI7d
-----END CERTIFICATE-----

        namespacedefault▒

token▒eyJhbGciOiJSUzI1NiIsImtpZCI6IlJpNzlDbklLQTZWa2pCa2VjNi1VanA1T204cy1iQnJzUk1xeml2WlVQaFUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tdHdkZzkiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjE3NDZiMjQ4LTFiYzUtNDUyNy1iNWFmLTI4ODhhNmE5YTg2ZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.vahT1AKx8FUh1rA8n-NOzLGzQqaSRn0TA4-sK0sewrtk8J8Q4PCnijWMJODZI9tj2eWgIwo8GbOkV-jsRxIy0UxXSXoxa99yXYrfrDv1RKUyQz0QReLhxRpTKAgLjKqOyoZMCXemc9gmfICsCrcW19Cz86Qr7jok8R5XODaJonzIj0M3aHRwSqrT1ILIftZKvOMQpeDxBeT8iu57JbeqDoZRGOOlXvHVpS7lz_yu70SfZuCpsoMUDc-roa7YvNDd0Ioq9SNfk6oDj-SAQ2NRS-DMJhmnAYiwm_94R9jaEqq335yjYXtsVLRR0qcDk7g3KJINdtYNpnjnfYsP0ggB4g#kubernetes.io/service-account-token"
```

###### get secret very-secure

```sh
root@cks-master:/etc/kubernetes/etcd# k create secret generic very-secure --from-literal cc=1234
secret/very-secure created

root@cks-master: cd /etc/kubernetes/etcd

root@cks-master:/etc/kubernetes/etcd# ETCDCTL_API=3 etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/very-secure
/registry/secrets/default/very-secure
k8s:enc:aescbc:v1:key1:▒oT▒▒▒fݬ{▒▒▒`▒[▒d0˯▒▒▒/f▒F▒�6K▒[K▒M▒!%▒▒▒▒▒▒1j▒(▒I▒~▒p▒▒▒▒g▒|▒+▒▒▒Tc▒vP▒Ҫ2▒nцK!▒+▒Z▒{▒
▒▒+p▒▒1gM▒▒▒▒▒z▒▒▒D▒V,▒5▒/▒▒▒▒ak▒▒P▒)▒▒▒B:N▒▒▒▒▒▒n▒Q▒▒▒▒▒=dN▒▒P`d▒Xg)▒▒▒^▒▒▒▒`▒▒

root@cks-master:~# k get secret very-secure -oyaml
apiVersion: v1
data:
  cc: MTIzNA==
kind: Secret
metadata:
  creationTimestamp: "2021-03-13T04:15:23Z"
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:data:
        .: {}
        f:cc: {}
      f:type: {}
    manager: kubectl-create
    operation: Update
    time: "2021-03-13T04:15:23Z"
  name: very-secure
  namespace: default
  resourceVersion: "19693"
  uid: da8b81ed-ea22-4413-a3cd-ae45c561b4de


root@cks-master:~# echo MTIzNA== | base64 -d
1234

#The tool  cut will split input into fields using space as the delimiter ( -d"" ). We then only select the 9th field using  -f 2
#sed -n 1p select the 1st line 
#tr -d '' delete the space
k get secret very-secure -oyaml | grep cc | cut -f 2 -d ":" | sed -n 1p | tr -d ' ' | base64 -d
1234

root@cks-master:~# k delete secret default-token-twdg9
secret "default-token-twdg9" deleted

# the contoller will recreate the secret
root@cks-master:~# k get secret
NAME                  TYPE                                  DATA   AGE
default-token-wlb7k   kubernetes.io/service-account-token   3      3s
secret1               Opaque                                1      8d
secret2               Opaque                                1      8d
very-secure           Opaque                                1      5d19h

#Check the secret is there
root@cks-master:/etc/kubernetes/etcd# k get secret -oyaml | grep very-secure
    name: very-secure

#check the secret of the kube-system
k get -n kube-system secret

NAME                                             TYPE                                  DATA   AGE
attachdetach-controller-token-5d5j5              kubernetes.io/service-account-token   3      9d
bootstrap-signer-token-5rfwh                     kubernetes.io/service-account-token   3      9d
bootstrap-token-5l9c78                           bootstrap.kubernetes.io/token         5      9d
certificate-controller-token-c5p2q               kubernetes.io/service-account-token   3      9d
clusterrole-aggregation-controller-token-bjtg2   kubernetes.io/service-account-token   3      9d
coredns-token-tl9fd                              kubernetes.io/service-account-token   3      9d
cronjob-controller-token-q6p5n                   kubernetes.io/service-account-token   3      9d
daemon-set-controller-token-4x4rm                kubernetes.io/service-account-token   3      9d
default-token-krzvk                              kubernetes.io/service-account-token   3      9d
deployment-controller-token-dw4zf                kubernetes.io/service-account-token   3      9d
disruption-controller-token-8v8zt                kubernetes.io/service-account-token   3      9d
endpoint-controller-token-zfcl6                  kubernetes.io/service-account-token   3      9d
endpointslice-controller-token-xh6j4             kubernetes.io/service-account-token   3      9d
endpointslicemirroring-controller-token-577mv    kubernetes.io/service-account-token   3      9d
expand-controller-token-xmht8                    kubernetes.io/service-account-token   3      9d
generic-garbage-collector-token-m4c2b            kubernetes.io/service-account-token   3      9d
horizontal-pod-autoscaler-token-x9lkt            kubernetes.io/service-account-token   3      9d
job-controller-token-ntsvh                       kubernetes.io/service-account-token   3      9d
kube-proxy-token-2vhzq                           kubernetes.io/service-account-token   3      9d
namespace-controller-token-mhh59                 kubernetes.io/service-account-token   3      9d
node-controller-token-hswlq                      kubernetes.io/service-account-token   3      9d
persistent-volume-binder-token-b6k4d             kubernetes.io/service-account-token   3      9d
pod-garbage-collector-token-jmtrz                kubernetes.io/service-account-token   3      9d
pv-protection-controller-token-kd4kn             kubernetes.io/service-account-token   3      9d
pvc-protection-controller-token-dhd5f            kubernetes.io/service-account-token   3      9d
replicaset-controller-token-ht4pf                kubernetes.io/service-account-token   3      9d
replication-controller-token-wgnlj               kubernetes.io/service-account-token   3      9d
resourcequota-controller-token-s2vmj             kubernetes.io/service-account-token   3      9d
root-ca-cert-publisher-token-vn5g4               kubernetes.io/service-account-token   3      9d
service-account-controller-token-xl6l2           kubernetes.io/service-account-token   3      9d
service-controller-token-9c8hd                   kubernetes.io/service-account-token   3      9d
statefulset-controller-token-zj8js               kubernetes.io/service-account-token   3      9d
token-cleaner-token-r8zt8                        kubernetes.io/service-account-token   3      9d
ttl-controller-token-8hjk2                       kubernetes.io/service-account-token   3      9d
weave-net-token-vd9ld                            kubernetes.io/service-account-token   3      9d


#Restart kube api server
root@cks-master:/var/log/pods# cd -
/etc/kubernetes/etcd
root@cks-master:/etc/kubernetes/etcd# cd ../manifests/
root@cks-master:/etc/kubernetes/manifests# mv kube-apiserver.yaml ..
# check the apiserver is stopped
root@cks-master:/etc/kubernetes/manifests# ps aux | grep apiserver
root     26261  0.0  0.0  14860  1004 pts/0    S+   03:50   0:00 grep --color=auto apiserver
root@cks-master:/etc/kubernetes/manifests# mv ../kube-apiserver.yaml .
#Check the aipserver is working
root@cks-master:/etc/kubernetes/etcd# ps aux | grep apiserver

root      3198  6.3  8.7 1097608 351244 ?      Ssl  23:05   2:36 kube-apiserver --encryption-provider-config=/etc/kubernetes/etcd/ec.yaml --advertise-address=10.146.0.2 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root     18586  0.0  0.0  14860  1040 pts/0    S+   23:46   0:00 grep --color=auto apiserver


k get secret -A -oyaml | kubectl replace -f -
```



#### Question 

cd /etc/kubernetes/etcd

ec.yaml identity for what



docker secret and etcd secret hacking is solved?

##### Recap
##### Why do we even have ConfigMap and Secrets?
- ConfigMaps file can keep file
- Secrets is more secure way

![](./images/Section15/Screenshot_11.png)

- Tools
  - HashiCorp
  - Vault

##### K8s Secret Risks

![](./images/Section15/Screenshot_12.png)

![](./images/Section15/Screenshot_13.png)

Recap

- What are Secrets?
- Deploying & Use Secrets
- Hacking Secrets(etcd & Docker)
- How Secrets are stored (encrypted)

#### Section 16 Microservice Vunerabilites - Container Runtime Sandboxes

##### 78.Intro

- Technical Overview
  - Containers are not contained
    - a container doesn't mean it's more protected
  - Containers / Docker
    - ![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_1.png)
    - Sandbox
      - Playground when implementing an API
      - Simulated Testing environgment
      - Development server
      - **Security layer to  reduce attack surface**
    - Containers and system calls
      - ![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_2.png)
      - Sandbox comes not for free
        - More resources needed
        - Might be better for smaller containers
        - Not good for syscall heavy workloads
        - No direct access to hardware
- Break out of container
- gVisor Kata Containers
##### 79. Practice - Container calls Linux Kernel
```sh
root@cks-master:~# k run pod --image=nginx
pod/pod created

root@cks-master:~# k exec pod -it -- bash

#show system information
root@pod:/# uname -r
5.4.0-1051-gcp

#trace system calls and signals
root@cks-master:~# strace uname -r

```
[Dirty Cow ](https://en.wikipedia.org/wiki/Dirty_COW)

Computers and devices that still use the older kernels remain vulnerable.

##### 80. Open Container Initiative OCI

OCI

- Open Container Initiative

- Linux Foundation project to design open standards for virtualization

- Specification

  - runtime,image,distribution

- Runtime

  - runc(container runtime that implements their specification)

  ![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_3.png)

![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_4.png)

![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_5.png)

##### 81. Practice - Crictl

crictl and containerd

- crictl: Provides a CLI for CRI-compatible container runtimes



```sh
# show containers
docker ps
crictl ps
#get nginx image
crictl pull nginx
Image is up to date for nginx@sha256:853b221d3341add7aaadf5f81dd088ea943ab9c918766e295321294b035f3f3e

#show pods
crictl pods
```

##### 82. Sandbox Runtime Katacontainers

![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_6.png)

Kata containers

- Strong separation layer
- Runs every container in its own private VM(Hypervisor based)
- QEMU as default
  - needs virtualisation,like nested virtualisation in cloud

##### 83. Sandbox Runtime gVisor

user-space kernel for containers

- Another layer of spearation
- NOT hypervisor/VM based
- Simulator kernel syscalls with limited functionality
- Runtime called runsc

![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_7.png)

##### 84.Practice - Create and use RuntimeClasses

```sh
vim runsc.yaml
-----
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: gvisor
handler: runsc
-----
root@cks-master:~# k -f rc.yaml create
runtimeclass.node.k8s.io/gvisor created

```



```sh
k run gvisor --image=nginx -oyaml --dry-run=client > pod.yaml
root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gvisor
  name: gvisor
spec:
  runtimeClassName: test
  containers:
  - image: nginx
    name: gvisor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
Error from server (Forbidden): error when creating "pod.yaml": pods "gvisor" is forbidden: pod rejected: RuntimeClass "test" not found

root@cks-master:~# vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gvisor
  name: gvisor
spec:
  runtimeClassName: gvisor
  containers:
  - image: nginx
    name: gvisor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f pod.yaml create
pod/gvisor created



root@cks-master:~# k get pod -w
NAME     READY   STATUS              RESTARTS   AGE
gvisor   0/1     ContainerCreating   0          30s
pod      1/1     Running             0          126m

```



##### 85.Practice - Install and use gVisor



![](./images/Section16_MicroserviceVulnerabilities-ContainerRuntimeSandboxes/Screenshot_8.png)

```sh
root@cks-worker:~#sudo -i
root@cks-worker:~#bash <(curl -s https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/microservice-vulnerabilities/container-runtimes/gvisor/install_gvisor.sh)
# use containerd
root@cks-worker:~# cat /etc/default/kubelet
KUBELET_EXTRA_ARGS="--container-runtime remote --container-runtime-endpoint unix:///run/containerd/containerd.sock"
#check kubelet
root@cks-worker:~# service kubelet status
```

cks-worker is using containerd

```sh
root@cks-master:~# k get node -owide
NAME         STATUS   ROLES                  AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
cks-master   Ready    control-plane,master   34h   v1.21.0   10.146.0.2    <none>        Ubuntu 18.04.5 LTS   5.4.0-1051-gcp   docker://20.10.7
cks-worker   Ready    <none>                 34h   v1.21.0   10.146.0.3    <none>        Ubuntu 18.04.5 LTS   5.4.0-1051-gcp   containerd://1.5.2

# gvisor using containerd
root@cks-master:~# k get pod
NAME     READY   STATUS    RESTARTS   AGE
gvisor   1/1     Running   0          10m
pod      1/1     Running   0          136m

root@cks-master:~# k exec -it gvisor -- bash
root@gvisor:/# uname -r
4.4.0
root@gvisor:/# dmesg
[    0.000000] Starting gVisor...
[    0.260793] Searching for needles in stacks...
[    0.737771] Digging up root...
[    1.161314] Conjuring /dev/null black hole...
[    1.467524] Moving files to filing cabinet...
[    1.670183] Forking spaghetti code...
[    1.765726] Checking naughty and nice process list...
[    1.861117] Daemonizing children...
[    2.041006] Feeding the init monster...
[    2.383943] Rewriting operating system in Javascript...
[    2.744631] Preparing for the zombie uprising...
[    3.014470] Ready!
```



##### Recap

- Container Sandboxes
- containerd
- kata-containers(vm)
- gvisor/runsc(kernel)
- k8s Runtimes

###### References

- Container Runtime Landscape
https://www.youtube.com/watch?v=RyXL1zOa8Bw
- Gvisor
https://www.youtube.com/watch?v=kxUZ4lVFuVo
- Kata Containers
https://www.youtube.com/watch?v=4gmLXyMeYWI



#### Section 17 Microservice Vunerabilites - OS Level Security Domains
##### 87. Intro and Security Contexts
Security Contexts
**Define privilege and access control for Pod/Container**

- userID and GroupID
- Run privilged or unprivileged

![](./images/Section17/Screenshot_1.png)



![](./images/Section17/Screenshot_2.png)

PodSecurityContext v1 core

https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/

![](./images/Section17/Screenshot_3.png)

##### 88. Practice - Set Container User and Group
** Change the user and gourp under which the conatiner processes are running

```sh
k run pod --image=busybox --command -oyaml --dry-run=client > pod.yaml -- sh -c 'sleep 1d'

root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ # id
uid=0(root) gid=0(root) groups=10(wheel)
```
add security context
```sh
vim pod.yaml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

recreate pod

```sh
k -f pod.yaml delete --force --grace-period=0


root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ $ id
uid=1000 gid=3000
/ $ touch test
touch: test: Permission denied
/ $ cd /tmp/
/tmp $ touch test
/tmp $ ls -lh test
-rw-r--r--    1 1000     3000           0 Sep 20 06:58 test

```
##### 89.　Non-Root

**Force container to run as non-root**

```sh
vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
k -f pod.yaml delete --force --grace-period=0

root@cks-master:~# k -f pod.yaml apply
pod/pod created

comment out security
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
#  securityContext:
#    runAsUser: 1000
#    runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
k delete pod pod --force --grace-period=0
k apply -f pod.yaml
# because securitycontext is root
root@cks-master:~# k get pod
NAME     READY   STATUS                       RESTARTS   AGE
gvisor   1/1     Running                      1          39h
pod      0/1     CreateContainerConfigError   0          5s

root@cks-master:~# k describe pod pod

  Warning  Failed     50s (x8 over 2m17s)  kubelet            Error: container has runAsNonRoot and image will run as root (pod: "pod_default(a0aa01b2-231b-4d21-abff-751052622d6a)", container: pod)

```

##### 90. Privileged Containers

- By default Docker containers run "unprivileged"
- possible to run as privileged to 
  - Access all devices
  - Run Docker daemon inside container
    - docker run --privilileged

**Privileged means that container user 0(root) is directly mapped to host user 0 (root)**

###### Privileged Containers in Kubernetes

By default in kubernetes container are not running privileged

```sh
spec:
  containers:
    securityContext:
      privileged: true
```

##### 91.Practice - Create Privileged Container

**Enabled privileged and test using sysctl**

```sh
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  securityContext:
   runAsUser: 1000
   runAsGroup: 3000
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k delete pod pod --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "pod" force deleted

root@cks-master:~# k apply -f pod.yaml
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ $ sysctl kernel.hostname=attacker
sysctl: error setting key 'kernel.hostname': Read-only file system

```



```sh
commentout securitycontext
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    #securityContext:
    #  runAsNonRoot: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
#recreate pod
k delete pod pod --force --grace-period=0 
k -f pod.yaml create

root@cks-master:~# k exec -it pod -- sh
/ $ sysctl kernel.hostname=attacker
sysctl: error setting key 'kernel.hostname': Read-only file system

```
Change security context to  the privileged 
```sh
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      privileged: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
recreate pod

k delete pod pod --force --grace-period=0
k -f pod.yaml create


root@cks-master:~# k exec -it pod -- sh
/ # sysctl kernel.hostname=attacker
kernel.hostname = attacker
/ # id
uid=0(root) gid=0(root) groups=10(wheel)

```

##### 92. PrivilegeEscalation

> AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process

![](./images/Section17/Screenshot_4.png)

Privileged

> means that container user 0(root) is directly mapped to host user 0(root)

PrivilegeEscalation

>Controls where the process can gain more privileges than its parent process

##### 93. Practice - Disable PriviledgeEscalation

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegedEscalation: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k exec -it pod -- sh
/ # cat /proc/1/s
sched         sessionid     smaps         stack         statm         syscall
schedstat     setgroups     smaps_rollup  stat          status
/ # cat /proc/1/sta
stack   stat    statm   status
/ # cat /proc/1/status | grep No
NoNewPrivs:     0
```

recreate pod.yaml

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: false
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k delete pod pod --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "pod" force deleted
root@cks-master:~# k -f pod.yaml create
pod/pod created

root@cks-master:~# k exec -it pod -- sh
/ # cat /proc/1/status | grep NoNew
NoNewPrivs:     1

```

##### 94.PodSecurityPolicies

- Cluster-level resource
- Controls under which security conditions a Pod has to run

![](./images/Section17/Screenshot_5.png)

![](./images/Section17/Screenshot_5.png)



![](./images/Section17/Screenshot_6.png)

##### 95.Pod Security Policies

> Create a PodSecurityPolicy to always enforce no allowPrivilegeEscalation



```sh
vim /etc/kubernetes/manifests/kube-apiserver.yaml
---    
    - --enable-admission-plugins=NodeRestriction,PodSecurityPolicy
---
```

```sh
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: default
spec:
  allowPrivilegeEscalation: false
  privileged: false  # Don't allow privileged pods!
  # The rest fills in some required fields.
  seLinux:
    rule: RunAsAny
  supplementalGroups:
    rule: RunAsAny
  runAsUser:
    rule: RunAsAny
  fsGroup:
    rule: RunAsAny
  volumes:
  - '*'
---
root@cks-master:~# k -f psp.yaml create
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/default created

```

https://kubernetes.io/docs/concepts/policy/pod-security-policy/#create-a-policy-and-a-pod

can't not create pod with deploy

```sh
root@cks-master:~# k create deploy nginx --image=nginx
deployment.apps/nginx created
root@cks-master:~# k get deploy nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   0/1     0            0           5s
root@cks-master:~# k get deploy nginx -w
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   0/1     0            0           9s

```

can create pod 

```sh
Croot@cks-master:~# k run nginx --image=nginx
pod/nginx created
root@cks-master:~# k get pod
NAME     READY   STATUS              RESTARTS   AGE
gvisor   1/1     Running             1          40h
nginx    0/1     ContainerCreating   0          2s
pod      1/1     Running             0          25m
```

create role and rolebinding

```sh
root@cks-master:~# k create role psp-access --verb=use --resource=podsecuritypolicies
role.rbac.authorization.k8s.io/psp-access created
root@cks-master:~# k create rolebinding psp-access --role=psp-access --serviceaccount=default:default
rolebinding.rbac.authorization.k8s.io/psp-access created
```

recreate nginx deploy

```sh
root@cks-master:~# k delete deploy nginx
deployment.apps "nginx" deleted
root@cks-master:~# k create deploy nginx --image=nginx
deployment.apps/nginx created
root@cks-master:~# k get deploy nginx
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           21s
```



`allowPrivilegeEscalation: true` and can't create pod

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml create
Error from server (Forbidden): error when creating "pod.yaml": pods "pod" is forbidden: PodSecurityPolicy: unable to admit pod: [spec.containers[0].securityContext.allowPrivilegeEscalation: Invalid value: true: Allowing privilege escalation for containers is not allowed]

```

`allowPrivilegeEscalation: false` and can create pod

```sh
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - command:
    - sh
    - -c
    - sleep 1d
    image: busybox
    name: pod
    resources: {}
    securityContext:
      allowPrivilegeEscalation: false
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
gvisor                   1/1     Running   1          41h
nginx                    1/1     Running   0          9m7s
nginx-6799fc88d8-4kfdc   1/1     Running   0          4m44s
pod                      1/1     Running   0          53s

```

> Create a PodSecurityPolicy to always enforce no allowPrivilegeEscalation

##### 96. Recap

![](./images/Section17/Screenshot_8.png)

![](./images/Section17/Screenshot_9.png)

#### Section 18 Microservice Vunerabilites - mTLS

##### 97.Intro

- mTLS/Pod to Pod Communication
  - mTLS -Mutual TLS
    - Mutual authntication
    - Two-way(bilateral) authentication
    - Two parties authenticating each other at the same time
- Service Meshes
- Scenarios

![](./images/Section18/Screenshot_10.png)



![](./images/Section18/Screenshot_11.png)



![](./images/Section18/Screenshot_12.png)



![](./images/Section18/Screenshot_14.png)



![](./images/Section18/Screenshot_15.png)



##### 98.Practice - Create sidecar proxy

Create a proxy sidecar which with NET_ADMIN capacity

```sh

root@cks-master:~# k run app --image=bash --command -oyaml --dry-run=client > app.yaml -- sh -c 'ping google.com'
root@cks-master:~# vim app.yaml
root@cks-master:~# k -f app.yaml create
pod/app created
root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
app                      1/1     Running   0          11s
nginx-6799fc88d8-7fdq7   1/1     Running   0          4d7h
root@cks-master:~# k logs -f app
PING google.com (172.217.27.78): 56 data bytes
64 bytes from 172.217.27.78: seq=0 ttl=121 time=2.116 ms
64 bytes from 172.217.27.78: seq=1 ttl=121 time=1.866 ms
64 bytes from 172.217.27.78: seq=2 ttl=121 time=1.780 ms
64 bytes from 172.217.27.78: seq=3 ttl=121 time=1.918 ms
64 bytes from 172.217.27.78: seq=4 ttl=121 time=1.725 ms
64 bytes from 172.217.27.78: seq=5 ttl=121 time=1.788 ms
64 bytes from 172.217.27.78: seq=6 ttl=121 time=1.905 ms
64 bytes from 172.217.27.78: seq=7 ttl=121 time=1.957 ms
64 bytes from 172.217.27.78: seq=8 ttl=121 time=1.944 ms
64 bytes from 172.217.27.78: seq=9 ttl=121 time=1.951 ms
64 bytes from 172.217.27.78: seq=10 ttl=121 time=1.813 ms
64 bytes from 172.217.27.78: seq=11 ttl=121 time=1.821 ms
64 bytes from 172.217.27.78: seq=12 ttl=121 time=2.008 ms
64 bytes from 172.217.27.78: seq=13 ttl=121 time=1.967 ms
64 bytes from 172.217.27.78: seq=14 ttl=121 time=1.659 ms
```

```sh
root@cks-master:~# vim app.yaml
root@cks-master:~# cat app.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: app
  name: app
spec:
  containers:
  - command:
    - sh
    - -c
    - ping google.com
    image: bash
    name: app
    resources: {}
  - name: proxy
    image: ubuntu
    command:
    - sh
    - -c
    - 'apt-get update && apt-get install iptables -y && iptables -L && sleep 1d'
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

root@cks-master:~# k -f app.yaml delete --force --grace-period 0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "app" force deleted
root@cks-master:~# k -f app.yaml create
pod/app created
#show two apps
root@cks-master:~# k get pod
NAME                     READY   STATUS    RESTARTS   AGE
app                      2/2     Running   1          25s
nginx-6799fc88d8-7fdq7   1/1     Running   0          4d7h

```

add "NET_ADMIN"

```sh
root@cks-master:~# vim app.yaml
root@cks-master:~# cat app.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: app
  name: app
spec:
  containers:
  - command:
    - sh
    - -c
    - ping google.com
    image: bash
    name: app
    resources: {}
  - name: proxy
    image: ubuntu
    command:
    - sh
    - -c
    - 'apt-get update && apt-get install iptables -y && iptables -L && sleep 1d'
    securityContext:
      capabilities:
        add: ["NET_ADMIN"]
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f app.yaml create
pod/app created

#show logs
root@cks-master:~# k logs app -c proxy
Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
Get:3 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [30.1 kB]
Get:4 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [791 kB]
Get:5 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [543 kB]
Get:6 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1092 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal-backports InRelease [101 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [177 kB]
Get:10 http://archive.ubuntu.com/ubuntu focal/restricted amd64 Packages [33.4 kB]
Get:11 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [1275 kB]
Get:12 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [11.3 MB]
Get:13 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [1071 kB]
Get:14 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [590 kB]
Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1537 kB]
Get:16 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [33.3 kB]
Get:17 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 Packages [2668 B]
Get:18 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [6310 B]
Fetched 19.1 MB in 13s (1525 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  libip4tc2 libip6tc2 libmnl0 libnetfilter-conntrack3 libnfnetlink0 libnftnl11
  libxtables12 netbase
Suggested packages:
  firewalld kmod nftables
The following NEW packages will be installed:
  iptables libip4tc2 libip6tc2 libmnl0 libnetfilter-conntrack3 libnfnetlink0
  libnftnl11 libxtables12 netbase
0 upgraded, 9 newly installed, 0 to remove and 5 not upgraded.
Need to get 595 kB of archives.
After this operation, 3490 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 libip4tc2 amd64 1.8.4-3ubuntu2 [18.8 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal/main amd64 libmnl0 amd64 1.0.4-2 [12.3 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal/main amd64 libxtables12 amd64 1.8.4-3ubuntu2 [28.4 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal/main amd64 netbase all 6.1 [13.1 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal/main amd64 libip6tc2 amd64 1.8.4-3ubuntu2 [19.2 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal/main amd64 libnfnetlink0 amd64 1.0.1-3build1 [13.8 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal/main amd64 libnetfilter-conntrack3 amd64 1.0.7-2 [41.4 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal/main amd64 libnftnl11 amd64 1.1.5-1 [57.8 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal/main amd64 iptables amd64 1.8.4-3ubuntu2 [390 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 595 kB in 3s (171 kB/s)
Selecting previously unselected package libip4tc2:amd64.
(Reading database ... 4127 files and directories currently installed.)
Preparing to unpack .../0-libip4tc2_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libip4tc2:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package libmnl0:amd64.
Preparing to unpack .../1-libmnl0_1.0.4-2_amd64.deb ...
Unpacking libmnl0:amd64 (1.0.4-2) ...
Selecting previously unselected package libxtables12:amd64.
Preparing to unpack .../2-libxtables12_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libxtables12:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package netbase.
Preparing to unpack .../3-netbase_6.1_all.deb ...
Unpacking netbase (6.1) ...
Selecting previously unselected package libip6tc2:amd64.
Preparing to unpack .../4-libip6tc2_1.8.4-3ubuntu2_amd64.deb ...
Unpacking libip6tc2:amd64 (1.8.4-3ubuntu2) ...
Selecting previously unselected package libnfnetlink0:amd64.
Preparing to unpack .../5-libnfnetlink0_1.0.1-3build1_amd64.deb ...
Unpacking libnfnetlink0:amd64 (1.0.1-3build1) ...
Selecting previously unselected package libnetfilter-conntrack3:amd64.
Preparing to unpack .../6-libnetfilter-conntrack3_1.0.7-2_amd64.deb ...
Unpacking libnetfilter-conntrack3:amd64 (1.0.7-2) ...
Selecting previously unselected package libnftnl11:amd64.
Preparing to unpack .../7-libnftnl11_1.1.5-1_amd64.deb ...
Unpacking libnftnl11:amd64 (1.1.5-1) ...
Selecting previously unselected package iptables.
Preparing to unpack .../8-iptables_1.8.4-3ubuntu2_amd64.deb ...
Unpacking iptables (1.8.4-3ubuntu2) ...
Setting up libip4tc2:amd64 (1.8.4-3ubuntu2) ...
Setting up libip6tc2:amd64 (1.8.4-3ubuntu2) ...
Setting up libmnl0:amd64 (1.0.4-2) ...
Setting up libxtables12:amd64 (1.8.4-3ubuntu2) ...
Setting up libnfnetlink0:amd64 (1.0.1-3build1) ...
Setting up netbase (6.1) ...
Setting up libnftnl11:amd64 (1.1.5-1) ...
Setting up libnetfilter-conntrack3:amd64 (1.0.7-2) ...
Setting up iptables (1.8.4-3ubuntu2) ...
update-alternatives: using /usr/sbin/iptables-legacy to provide /usr/sbin/iptables (iptables) in auto mode
update-alternatives: using /usr/sbin/ip6tables-legacy to provide /usr/sbin/ip6tables (ip6tables) in auto mode
update-alternatives: using /usr/sbin/arptables-nft to provide /usr/sbin/arptables (arptables) in auto mode
update-alternatives: using /usr/sbin/ebtables-nft to provide /usr/sbin/ebtables (ebtables) in auto mode
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  10.32.0.0/12         base-address.mcast.net/4
DROP       all  --  anywhere             base-address.mcast.net/4

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

```

https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

##### 99.Recap

- mTLS
- Pod to Pod Communication
- Create sidecar proxy
- NET_ADMIN capacity

#### Section 19 Open Policy Agent(OPA)
##### 100. Cluster Reset

> Every new section works with a fresh cluster



##### 101. Introduction

### Open Policy Agent

- Introduction to OPA and Gatekeeper
- Enforce Labels
- Enforce Pod Replica Count

![Request workflow](./images/Section19/Screenshot_1.png)



![](./images/Section19/Screenshot_2.png)

![](./images/Section19/Screenshot_3.png)

![](./images/Section19/Screenshot_4.png)



![](./images/Section19/Screenshot_6.png)

##### 102. Practice - Install OPA

 - Install OPA Gatekeeper

```sh
#check the admission-plugins
vim /etc/kubernetes/manifests/kube-apiserver.yaml
---
    - --enable-admission-plugins=NodeRestriction
---
#create gatekeeper-system namespace
kubectl create -f https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/opa/gatekeeper.yaml
---
namespace/gatekeeper-system created
Warning: apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
Warning: admissionregistration.k8s.io/v1beta1 ValidatingWebhookConfiguration is deprecated in v1.16+, unavailable in v1.22+; use admissionregistration.k8s.io/v1 ValidatingWebhookConfiguration
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
---
---
oot@cks-master:~# k get ns
NAME                STATUS   AGE
default             Active   15d
gatekeeper-system   Active   17s
kube-node-lease     Active   15d
kube-public         Active   15d
kube-system         Active   15d
---

root@cks-master:~# k -n gatekeeper-system get pod,svc
NAME                                                 READY   STATUS    RESTARTS   AGE
pod/gatekeeper-audit-6ffc8f5544-nt5mg                1/1     Running   0          99s
pod/gatekeeper-controller-manager-6f9c99b4d7-mwghg   1/1     Running   0          99s

NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/gatekeeper-webhook-service   ClusterIP   10.96.117.31   <none>        443/TCP   99s

```

##### 103. Practice - Deny All Policy

```sh

root@cks-master:~# k get crd
NAME                                                 CREATED AT
configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
# there is not constrainttemplates ,so can't get the resource
root@cks-master:~# k get constrainttemplates
No resources found


root@cks-master:~# vim templates.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deny-all/alwaysdeny_template.yaml
root@cks-master:~# k -f templates.yaml create
constrainttemplate.templates.gatekeeper.sh/k8salwaysdeny created


root@cks-master:~# k get K8sAlwaysDeny
No resources found


root@cks-master:~# vim constraint.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deny-all/all_pod_always_deny.yaml
root@cks-master:~# k -f constraint.yaml create
k8salwaysdeny.constraints.gatekeeper.sh/pod-always-deny created


root@cks-master:~# k get K8sAlwaysDeny
NAME              AGE
pod-always-deny   41s

#can't create a pod
root@cks-master:~# k run pod --image=nginx
Error from server ([denied by pod-always-deny] ACCESS DENIED!): admission webhook "validation.gatekeeper.sh" denied the request: [denied by pod-always-deny] ACCESS DENIED!

```



##### 104. Practice - Enforce Namespace Labels

- All namespaces created need to have the label 'cks'

  ```sh
  # create template
  vim template.yaml 
  
  https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/namespace-labels/k8srequiredlabels_template.yaml
  
  root@cks-master:~# k -f template.yaml create
  constrainttemplate.templates.gatekeeper.sh/k8srequiredlabels created
  ```

  ```sh
  # create constraints
  vim constraints.yaml
  https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/namespace-labels/all_ns_must_have_cks.yaml
  
  root@cks-master:~# k -f constraints.yaml create
  k8srequiredlabels.constraints.gatekeeper.sh/ns-must-have-cks created
  
  ```

  ```sh
  # show Custom Resources 
  root@cks-master:~# k get crd
  NAME                                                 CREATED AT
  configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
  constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
  constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
  constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
  k8salwaysdeny.constraints.gatekeeper.sh              2021-10-02T16:46:17Z
  k8srequiredlabels.constraints.gatekeeper.sh          2021-10-03T05:27:47Z
  root@cks-master:~# k get k8srequiredlabels
  NAME               AGE
  ns-must-have-cks   49s
  root@cks-master:~# k describe k8srequiredlabels ns-must-have-cks
  Name:         ns-must-have-cks
  Namespace:
  Labels:       <none>
  Annotations:  <none>
  API Version:  constraints.gatekeeper.sh/v1beta1
  Kind:         K8sRequiredLabels
  Metadata:
    Creation Timestamp:  2021-10-03T05:40:43Z
    Generation:          1
    Managed Fields:
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:spec:
          .:
          f:match:
            .:
            f:kinds:
          f:parameters:
            .:
            f:labels:
      Manager:      kubectl-create
      Operation:    Update
      Time:         2021-10-03T05:40:43Z
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:status:
          .:
          f:auditTimestamp:
          f:byPod:
          f:totalViolations:
          f:violations:
      Manager:         gatekeeper
      Operation:       Update
      Time:            2021-10-03T05:41:29Z
    Resource Version:  38159
    UID:               779ad3d3-0f58-480a-8d0d-0cc584e57a90
  Spec:
    Match:
      Kinds:
        API Groups:
  
        Kinds:
          Namespace
    Parameters:
      Labels:
        cks
  Status:
    Audit Timestamp:  2021-10-03T05:43:33Z
    By Pod:
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-audit-6ffc8f5544-nt5mg
      Observed Generation:  1
      Operations:
        audit
        status
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-controller-manager-6f9c99b4d7-mwghg
      Observed Generation:  1
      Operations:
        webhook
    Total Violations:  5
    Violations:
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                default
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                gatekeeper-system
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-node-lease
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-public
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-system
  Events:                  <none>
  ```

  

  ```sh
  # add labels to namespace default
  # Total Violations:  5 to 4
  k edit ns default
  
  ---
    labels:
      cks: amazing
  ---
  root@cks-master:~# k describe k8srequiredlabels ns-must-have-cks
  Name:         ns-must-have-cks
  Namespace:
  Labels:       <none>
  Annotations:  <none>
  API Version:  constraints.gatekeeper.sh/v1beta1
  Kind:         K8sRequiredLabels
  Metadata:
    Creation Timestamp:  2021-10-03T05:40:43Z
    Generation:          1
    Managed Fields:
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:spec:
          .:
          f:match:
            .:
            f:kinds:
          f:parameters:
            .:
            f:labels:
      Manager:      kubectl-create
      Operation:    Update
      Time:         2021-10-03T05:40:43Z
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:status:
          .:
          f:auditTimestamp:
          f:byPod:
          f:totalViolations:
          f:violations:
      Manager:         gatekeeper
      Operation:       Update
      Time:            2021-10-03T05:41:29Z
    Resource Version:  38579
    UID:               779ad3d3-0f58-480a-8d0d-0cc584e57a90
  Spec:
    Match:
      Kinds:
        API Groups:
  
        Kinds:
          Namespace
    Parameters:
      Labels:
        cks
  Status:
    Audit Timestamp:  2021-10-03T05:48:51Z
    By Pod:
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-audit-6ffc8f5544-nt5mg
      Observed Generation:  1
      Operations:
        audit
        status
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-controller-manager-6f9c99b4d7-mwghg
      Observed Generation:  1
      Operations:
        webhook
    Total Violations:  4
    Violations:
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                gatekeeper-system
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-node-lease
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-public
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-system
  Events:                  <none>
  
  ```

  ```sh
  #can't create ns without label cks
  
  root@cks-master:~# k create ns test
  Error from server ([denied by ns-must-have-cks] you must provide labels: {"cks"}): admission webhook "validation.gatekeeper.sh" denied the request: [denied by ns-must-have-cks] you must provide labels: {"cks"}
  
  ```

##### 105. Practice - Enforce Deployment replica count

```sh
# delete constraint and template
root@cks-master:~# k -f constraints.yaml delete
k8srequiredlabels.constraints.gatekeeper.sh "ns-must-have-cks" deleted
root@cks-master:~# k -f template.yaml delete
constrainttemplate.templates.gatekeeper.sh "k8srequiredlabels" deleted
root@cks-master:~# rm *.yaml
```

```sh
# create template
vim template.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deployment-replica-count/k8sminreplicacount_template.yaml

root@cks-master:~# k -f template.yaml create
constrainttemplate.templates.gatekeeper.sh/k8sminreplicacount created

root@cks-master:~# k get crd
NAME                                                 CREATED AT
configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
k8salwaysdeny.constraints.gatekeeper.sh              2021-10-02T16:46:17Z
k8sminreplicacount.constraints.gatekeeper.sh         2021-10-03T06:40:44Z
```

```sh
# create constraints
root@cks-master:~# k -f constraint.yaml create
k8sminreplicacount.constraints.gatekeeper.sh/deployment-must-have-min-replicas created
root@cks-master:~# k get k8sminreplicacount
NAME                                AGE
deployment-must-have-min-replicas   52s
```

```sh
# can't create deploy
root@cks-master:~# k create deploy test --image=nginx
error: failed to create deployment: admission webhook "validation.gatekeeper.sh" denied the request: [denied by deployment-must-have-min-replicas] you must provide 1 more replicas


root@cks-master:~# k create deploy test --image=nginx -oyaml --dry-run=client > deploy.yaml

#change replica 1 to 2
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: test
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
---

root@cks-master:~# k -f deploy.yaml create
deployment.apps/test created

```



##### 106 Practice - The Rego Playground and more examples

- Reference url
  - https://play.openpolicyagent.org
  - https://github.com/BouweCeunen/gatekeeper-policies

##### 107.Recap

- OPA overview
- Used Gatekepper's CRDs
- created templates and constraints
- Rego
- Reference url
  - https://www.youtube.com/watch?v=RDWndems-sk

#### Section 20 Supply Chain Security - Image Footprint
##### 108.Intro

- Image footprint
  - Containers and Docker
  - Reduce Image Footprint [Multi Stage]
  - Secure Images

![](./images/Section20/Screenshot_1.png)

![](./images/Section20/Screenshot_2.png)

##### 109. Practice - Reduce Image Footprint with Multi-Stage

```sh
# reference url
#https://github.com/killer-sh/cks-course-environment/tree/master/course-content/supply-chain-security/image-footprint

wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/supply-chain-security/image-footprint/Dockerfile

wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/supply-chain-security/image-footprint/app.go

chmod +x Dockerfile app.go


# build docker container
docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0

root@cks-master:~# docker image list | grep app
app                                  latest     2157eb70e068   25 minutes ago   694MB

```



```sh
vim Dockerfile
---
#stage 0
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN CGO_ENABLED=0 go build app.go

# stage 1
FROM alpine
# copy from stage 0
COPY --from=0 /app .
CMD ["./app"]
---
docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0
# the image size is very small
root@cks-master:~docker image list | grep app
app                                  latest     8f2e91e2df15   About a minute ago   7.73MB
```

##### 110. Practice - Secure and harden Image

1. Use specific package versions

```sh
cat Dockerfile
---
#stage 0
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN CGO_ENABLED=0 go build app.go

# stage 1
FROM alpine:3.12.1
# copy from stage 0
COPY --from=0 /app .
CMD ["./app"]
---
root@cks-master:~# docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0
user: root id: 0
```

2. Don't run as root

```sh
---modified---
# stage 1
FROM alpine:3.12.1
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]   
---modified---
docker build -t app .
docker run app
user: appuser id: 100
user: appuser id: 100

```

3.  Make filesystem read only

```sh
---modified---
# stage 1
FROM alpine:3.12.1
RUN chmod a-w /etc
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]
---modified---
docker build -t app .
# run app in the back ground
docker run -d app
bf89ce4d7907d5fa421726041ddd709b3f58460917253147fd47465be5b5dd5a
docker exec -it bf89ce4d7907d5fa421726041ddd709b3f58460917253147fd47465be5b5dd5a sh

# etc don't have writing privileges 
# but is not to /etc/*
/ $ ls -lh
total 60K
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 bin
drwxr-xr-x    5 root     root         340 Oct  3 08:26 dev
dr-xr-xr-x    1 root     root        4.0K Oct  3 08:26 etc
drwxr-xr-x    1 root     root        4.0K Oct  3 08:25 home
drwxr-xr-x    7 root     root        4.0K Oct 21  2020 lib
drwxr-xr-x    5 root     root        4.0K Oct 21  2020 media
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 mnt
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 opt
dr-xr-xr-x  218 root     root           0 Oct  3 08:26 proc
drwx------    2 root     root        4.0K Oct 21  2020 root
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 run
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 sbin
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 srv
dr-xr-xr-x   13 root     root           0 Oct  3 08:26 sys
drwxrwxrwt    2 root     root        4.0K Oct 21  2020 tmp
drwxr-xr-x    7 root     root        4.0K Oct 21  2020 usr
drwxr-xr-x   12 root     root        4.0K Oct 21  2020 var
```

4. remove shell access

```sh
vim Dockerfile
---modified---
# stage 1
FROM alpine:3.12.1
RUN chmod a-w /etc
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
RUN rm -rf /bin/*
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]
---modified---
docker build -t app .
root@cks-master:~# docker run app
user: appuser id: 100
user: appuser id: 100
#can't use shell to login the docker container
root@cks-master:~# docker run -d app
f5dfc110fe8338f19aeaf9b95f7efb0fb660cc659d2fbe684858e68bff526a90
root@cks-master:~# docker exec -it f5dfc110fe8338f19aeaf9b95f7efb0fb660cc659d2fbe684858e68bff526a90 sh
OCI runtime exec failed: exec failed: container_linux.go:380: starting container process caused: exec: "sh": executable file not found in $PATH: unknown

```



##### 111.Recap

- reference 
  - https://docs.docker.com/develop/develop-images/dockerfile_best-practices
- Reduce image footprint
- Use multi stage build
- Secure images wiht restrictions

#### Section 21 Supply Chain Security - Static Analysis
##### 112.Intro

- Static Analysis

  - Looks at source code ant text files

  - Check against rules

  - Enforce rules

  - Static Analysis Rules

    - always define resource requests and limits
    - Pods should never user the default ServiceAccount
      - Depend on use case and  company or project
      - Generally: don't store sensitive data plain in K8s/Docker file

  - Static Analysis in CI/CD

    ![](./images/Section21/Screenshot_1.png)

- Manual approach

  - Manual Check
    - not hard coding

- Tools for kubernetes and scenarios

##### 113. Kubesec

- Security risk analysis for Kubernetes resources
- Opernsource
- Opinionated ! Fixed set of rules(Security Best Practices)
- Run as:
  - Binary
  - Docker container
  - Kubectl plguin
  - Admission Controller(kubesec-webhook)
  - https://kubesec.io/

##### 114. Practice - Kubesec

- Using the kubesec public docker image

```sh
k run nginx --image nginx -oyaml --dry-run=client > pod.yaml
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < pod.yaml

```

https://github.com/controlplaneio/kubesec

##### OPA Conftest

- OPA=Open Policy Agent
- Unit test framework for Kubernetes configurations
- Uses Rego Language

![](./images/Section21/Screenshot_2.png)

##### 116. Practice -OPA conftest for K8s YAML

- OPA conftest K8s Deployment
  - Use conftest to check a k8s example
  - 

```sh
git clone https://github.com/killer-sh/cks-course-environment.git

cd cks-course-environment/course-content/supply-chain-security/static-analysis/conftest/kubernetes

./run.sh

```





```sh
# modified the blow and run ./run.sh again
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: test
    spec:
##add
	securityContext:
        runAsNonRoot: true
      containers:
##add
        - image: httpd
          name: httpd
          resources: {}
status: {}
```

##### 117. Practice - OPA Conftest for Dockerfile

- Use conftest to run a Dockerfile example

```sh
root@cks-master:~/cks-course-environment/course-content/supply-chain-security/static-analysis/conftest/kubernetes# cd ..

 ls
docker  kubernetes
 l
Dockerfile  policy/  run.sh*

```



```sh
#modified ubuntu => alpine
FROM alpine
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN go build app.go
CMD ["./app"]

cat policy/commands.rego
# from https://www.conftest.dev

package commands
#delete apt
denylist = [
  "apk",
  "pip",
  "curl",
  "wget",
]

deny[msg] {
  input[i].Cmd == "run"
  val := input[i].Value
  contains(val[_], denylist[_])

  msg = sprintf("unallowed commands found %s", [val])
}

```

##### 118.Recap

- Static Analysis
- Manual Approach
- Kubesec
- OPA Conftest

Docs: "Rego - Policy Language"

#### Section 22 Supply Chain Security - Image Vulnerability Scanning
##### 119.Intro

- Image Vulnerabilities

  - Web servers or other apps can contain vulnerabilities(Buffer overflows)

  - Targets

    - Remotely accessible application in container
    - Local application inside container

  - Results

    - Privilege escalation
    - Information leaks
    - DDOS
  
- Containers - Layers - Dependencies

  - Layer1(ubuntu=14)
  - Layer4(nginx=x.x)
  - Layer6(curl=x.x)

- Known Image Vulnerabilities

  - Databases
    - https://cve.mitre.org
    - https://nvd.nist.gov 	
  - Vulnerabilities can be discovered in our own image and dependencies
    - Check during build
    - Check at runtime
  - Check for Known Image Vulnerabilities
  
  ![](./images/Section22/Screenshot_1.png)
  
  
  
  - Known Image Vulnerabilities - Admission Controllers
  
  
  
  
  
  ![](./images/Section22/Screenshot_2.png)



##### 120. Clair and Trivy

- Clair
  - Open source project
  - static analysis of vulnerabilities in application containers
  - Ingests vulnerability metadata from a configured set of sources
  - Provides API
- Trivy
  - Open source project
  - "A Simple and comprehensive Vulnerability Scanner for Containers and other Artifcacts, Suitable for CI."
  - Simple,Easy and fast

##### 121. Practice - Use Trivy to scan images

- Use trivy to check some public images and our kube-apiserver image
  - It can scan the local image ?

```sh
#https://github.com/aquasecurity/trivy#docker
#show the results
docker run ghcr.io/aquasecurity/trivy:latest image nginx:latest

#check nginx image
docker run ghcr.io/aquasecurity/trivy:latest image nginx
#get the critical info
root@cks-master:~# docker run ghcr.io/aquasecurity/trivy:latest image nginx | grep CRITICAL
1.85 MiB / 24.20 MiB [---->__________________________________________________________] 7.66% ? p/s ?4.25 MiB / 24.20 MiB [---------->___________________________________________________] 17.57% ? p/s ?6.46 MiB / 24.20 MiB [---------------->_____________________________________________] 26.69% ? p/s ?9.09 MiB / 24.20 MiB [------------------>______________________________] 37.57% 12.06 MiB p/s ETA 1s11.95 MiB / 24.20 MiB [----------------------->________________________] 49.37% 12.06 MiB p/s ETA 1s14.95 MiB / 24.20 MiB [----------------------------->__________________] 61.77% 12.06 MiB p/s ETA 0s18.22 MiB / 24.20 MiB [------------------------------------>___________] 75.28% 12.26 MiB p/s ETA 0s21.88 MiB / 24.20 MiB [------------------------------------------->____] 90.41% 12.26 MiB p/s ETA 0s24.20 MiB / 24.20 MiB [---------------------------------------------------] 100.00% 15.66 MiB p/s 2sTotal: 179 (UNKNOWN: 0, LOW: 129, MEDIUM: 22, HIGH: 24, CRITICAL: 4)
| libc-bin         | CVE-2021-33574   | CRITICAL | 2.28-10                   |               | glibc: mq_notify does                                        |
| libc6            | CVE-2021-33574   | CRITICAL |                           |               | glibc: mq_notify does                                        |

```

```sh
#check the nginx 1.16-alpine
root@cks-master:~# docker run ghcr.io/aquasecurity/trivy:latest image nginx:1.16-alpine
```

###### Check the pod's image is safe or not

```sh
root@cks-master:~# k -n kube-system get pod kube-apiserver-cks-master -oyaml | grep image
    image: k8s.gcr.io/kube-apiserver:v1.21.0
    imagePullPolicy: IfNotPresent
    image: k8s.gcr.io/kube-apiserver:v1.21.0
    imageID: docker-pullable://k8s.gcr.io/kube-apiserver@sha256:828fefd9598ed865d45364d1be859c87aabfa445b03b350e3440d143bd21bca9

#There is not error in the k8s.gcr.io/kube-apiserver:v1.21.0 (debian 10.8)
root@cks-master:~# docker run ghcr.io/aquasecurity/trivy:latest image k8s.gcr.io/kube-apiserver:v1.21.0
2021-10-07T11:54:50.795Z        INFO    Need to update DB
2021-10-07T11:54:50.795Z        INFO    Downloading DB...
2.37 MiB / 24.20 MiB [------>________________________________________________________] 9.78% ? p/s ?5.37 MiB / 24.20 MiB [------------->________________________________________________] 22.20% ? p/s ?8.37 MiB / 24.20 MiB [--------------------->________________________________________] 34.59% ? p/s ?11.21 MiB / 24.20 MiB [---------------------->_________________________] 46.33% 14.73 MiB p/s ETA 0s12.23 MiB / 24.20 MiB [------------------------>_______________________] 50.56% 14.73 MiB p/s ETA 0s15.21 MiB / 24.20 MiB [------------------------------>_________________] 62.88% 14.73 MiB p/s ETA 0s18.08 MiB / 24.20 MiB [----------------------------------->____________] 74.71% 14.52 MiB p/s ETA 0s21.29 MiB / 24.20 MiB [------------------------------------------>_____] 87.99% 14.52 MiB p/s ETA 0s24.20 MiB / 24.20 MiB [---------------------------------------------------] 100.00% 15.39 MiB p/s 2s2021-10-07T11:54:56.335Z   INFO    Detected OS: debian
2021-10-07T11:54:56.335Z        INFO    Detecting Debian vulnerabilities...
2021-10-07T11:54:56.335Z        INFO    Number of language-specific files: 0

k8s.gcr.io/kube-apiserver:v1.21.0 (debian 10.8)
===============================================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)

```



##### 122.Recap

- Vulnerabilities
- Dependencies
- Databases
- Clair
- Trivy

#### Section 23 Supply Chain Security - Secure Supply Chain
##### 123. Intro

- Supply Chain

![](./images/Section23/Screenshot_1.png)

- K8s and Container Registries

![](./images/Section23/Screenshot_2.png)

- Validate and whitelist Images and Registries

##### 124. Practice - Image Digest

> List all images registries used in the whole cluster
>
> Use Image digest for kube-apiserver

```sh
root@cks-master:~# k get pod -A -oyaml | grep "image:" | grep -v "f:"
      image: bash
      image: ubuntu
      image: docker.io/library/bash:latest
      image: docker.io/library/ubuntu:latest
    - image: nginx
      image: docker.io/library/nginx:latest
    - image: nginx
      image: docker.io/library/nginx:latest
    - image: nginx
      image: docker.io/library/nginx:latest
      image: openpolicyagent/gatekeeper:469f747
      image: docker.io/openpolicyagent/gatekeeper:469f747
      image: openpolicyagent/gatekeeper:469f747
      image: docker.io/openpolicyagent/gatekeeper:469f747
      image: k8s.gcr.io/coredns/coredns:v1.8.0
      image: k8s.gcr.io/coredns/coredns:v1.8.0
      image: k8s.gcr.io/coredns/coredns:v1.8.0
      image: k8s.gcr.io/coredns/coredns:v1.8.0
      image: k8s.gcr.io/etcd:3.4.13-0
      image: k8s.gcr.io/etcd:3.4.13-0
      image: k8s.gcr.io/kube-apiserver:v1.21.0
      image: k8s.gcr.io/kube-apiserver:v1.21.0
      image: k8s.gcr.io/kube-controller-manager:v1.21.0
      image: k8s.gcr.io/kube-controller-manager:v1.21.0
      image: k8s.gcr.io/kube-proxy:v1.21.0
      image: k8s.gcr.io/kube-proxy:v1.21.0
      image: k8s.gcr.io/kube-proxy:v1.21.0
      image: k8s.gcr.io/kube-proxy:v1.21.0
      image: k8s.gcr.io/kube-scheduler:v1.21.0
      image: k8s.gcr.io/kube-scheduler:v1.21.0
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: docker.io/weaveworks/weave-npc:2.8.1
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: docker.io/weaveworks/weave-npc:2.8.1
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: docker.io/weaveworks/weave-npc:2.8.1
      image: docker.io/weaveworks/weave-kube:2.8.1
      image: weaveworks/weave-kube:2.8.1
      image: weaveworks/weave-npc:2.8.1
      image: weaveworks/weave-kube:2.8.1
```

```sh
#why?
root@cks-master:~# k -n kube-system get pod kube-apiserver-cks-master -oyaml | grep imageID
    imageID: docker-pullable://k8s.gcr.io/kube-apiserver@sha256:828fefd9598ed865d45364d1be859c87aabfa445b03b350e3440d143bd21bca9

vim /etc/kubernetes/manifests/kube-apiserver.yaml
---modified---
 image: k8s.gcr.io/kube-apiserver@sha256:828fefd9598ed865d45364d1be859c87aabfa445b03b350e3440d143bd21bca9
---modified---

root@cks-master:~# k -n kube-system get pod | grep kube-api
kube-apiserver-cks-master            1/1     Running   0          26s

root@cks-master:~# k -n kube-system edit pod kube-apiserver-cks-master
------ image has changed------
image: k8s.gcr.io/kube-apiserver@sha256:828fefd9598ed865d45364d1be859c87aabfa445b03b350e3440d143bd21bca9
------ image has changed------
```



##### 125. Practice - Whitelist Registries with OPA

> Whitelist some registries using OPA
>
> Only images from docker.io and k8s.gcr.io can be used

https://github.com/killer-sh/cks-course-environment/tree/master/course-content/supply-chain-security/secure-the-supply-chain/whitelist-registries/opa

> constraint.yaml

```sh
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sTrustedImages
metadata:
  name: pod-trusted-images
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
```

> template.yaml 

```sh
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: k8strustedimages
spec:
  crd:
    spec:
      names:
        kind: K8sTrustedImages
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8strustedimages
        violation[{"msg": msg}] {
          image := input.review.object.spec.containers[_].image
          not startswith(image, "docker.io/")
          not startswith(image, "k8s.gcr.io/")
          msg := "not trusted image!"
        }
```

```sh
root@cks-master:~# k -f template.yaml create
constrainttemplate.templates.gatekeeper.sh/k8strustedimages created
root@cks-master:~# k -f constraint.yaml create
k8strustedimages.constraints.gatekeeper.sh/pod-trusted-images created


root@cks-master:~# k get constrainttemplate
NAME               AGE
k8strustedimages   83s

#can't create images if not in the k8strustedimages
root@cks-master:~# k run nginx --image=nginx
Error from server ([denied by pod-trusted-images] not trusted image!): admission webhook "validation.gatekeeper.sh" denied the request: [denied by pod-trusted-images] not trusted image!

root@cks-master:~# k run nginx --image=docker.io/nginx
pod/nginx created

```



##### 126. ImagePolicyWebhook
![](./images/Section23/Screenshot_3.png)

![](./images/Section23/Screenshot_4.png)





##### 127. Practice - ImagePolicyWebhook

- ImagePolicyWebhook

  >  Investigate Image PolicyWebhook
  >
  > And use it up to the point where it calls an external service

```sh
#before
- --enable-admission-plugins=NodeRestriction,
#after
- --enable-admission-plugins=NodeRestriction, ImagePolicyWebhook

cd /var/log/pods

tail -f kube-system_kube-apiserver-cks-master_5a71f28edaad27799171de0e1f97b292/kube-apiserver/4.log kube-system_
==> kube-system_kube-apiserver-cks-master_5a71f28edaad27799171de0e1f97b292/kube-apiserver/4.log <==
{"log":"Flag --insecure-port has been deprecated, This flag has no effect now and will be removed in v1.24.\n","stream":"stderr","time":"2021-10-07T16:06:39.051990032Z"}
{"log":"I1007 16:06:39.052143       1 server.go:629] external host was not specified, using 10.146.0.2\n","stream":"stderr","time":"2021-10-07T16:06:39.052270647Z"}
{"log":"Error: enable-admission-plugins plugin \" ImagePolicyWebhook\" is unknown\n","stream":"stderr","time":"2021-10-07T16:06:39.052647779Z"}
tail: cannot open 'kube-system_' for reading: No such file or directory

```

```sh
# get example
git clone https://github.com/killer-sh/cks-course-environment.git

root@cks-master:~# git clone https://github.com/killer-sh/cks-course-environment.git
root@cks-master:~# ls
cks-course-environment
root@cks-master:~# cp -r cks-course-environment/course-content/supply-chain-security/secure-the-supply-chain/whitelist-registries/ImagePolicyWebhook/ /etc/kubernetes/admission


cd /etc/kubernetes/admission
root@cks-master:/etc/kubernetes/admission# ll
total 32
drwxr-xr-x 2 root root 4096 Oct  7 16:12 ./
drwxr-xr-x 5 root root 4096 Oct  7 16:12 ../
-rw-r--r-- 1 root root  298 Oct  7 16:12 admission_config.yaml
-rw-r--r-- 1 root root 1135 Oct  7 16:12 apiserver-client-cert.pem
-rw-r--r-- 1 root root 1703 Oct  7 16:12 apiserver-client-key.pem
-rw-r--r-- 1 root root 1132 Oct  7 16:12 external-cert.pem
-rw-r--r-- 1 root root 1703 Oct  7 16:12 external-key.pem
-rw-r--r-- 1 root root  815 Oct  7 16:12 kubeconf

```

```sh
#modify file
cd /etc/kubernetes/manifests/
root@cks-master:/etc/kubernetes/manifests# vim kube-apiserver.yaml

#add
- --admission-control-config-file=/etc/kubernetes/admission/admission_config.yaml

#modified
   - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
#add
  - hostPath:
      path: /etc/kubernetes/admission
      type: DirectoryOrCreate
    name: k8s-admission

#add
  - mountPath: /etc/kubernetes/admission
      name: k8s-admission
      readOnly: true

```








> to debug the apiserver we check logs in:
/var/log/pods/kube-system_kube-apiserver*


> example of an external service which can be used
https://github.com/flavio/kube-image-bouncer

##### 128.Recap

- How k8s works with registries
- Image Tag and Digests
- Whitelist registries with OPA
- ImagePolicyWebhook

#### Section 24 Runtime Security - Behavioral Analytics at host and container level
##### 129. Intro

- Kernel vs User Space

![](./images/Section24/Screenshot_1.png)

https://man7.org/linux/man-pages/man2/syscalls.2.html

![](./images/Section24/Screenshot_2.png)

##### 130. Practice - Strace

> Intercepts and logs system calls made by a process
>
> Log and display signals received by a process
>
> Diagnostic, Learning, Debugging

![](./images/Section24/Screenshot_3.png)

```sh
root@cks-master:/etc/kubernetes/manifests# strace ls
execve("/bin/ls", ["ls"], 0x7fff9cb5cc70 /* 21 vars */) = 0
brk(NULL)                               = 0x5556521d5000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
...
write(1, "kube-apiserver.yaml  kube-contro"..., 50kube-apiserver.yaml  kube-cont                                                        roller-manager.yaml
) = 50
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

```

```sh
# trace command 
strace $command
```

```sh
root@cks-master:/etc/kubernetes/manifests# strace -cw ls /
bin   dev  home        initrd.img.old  lib64       media  opt   root  sbin  srv  tmp  var      vmlinuz.old
boot  etc  initrd.img  lib             lost+found  mnt    proc  run   snap  sys  usr  vmlinuz
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 18.54    0.000504          17        30           mmap
 14.72    0.000400          17        24           openat
 11.55    0.000314          12        26           close
 11.11    0.000302          12        25           fstat
 10.71    0.000291          24        12           mprotect
  7.51    0.000204         204         1           execve
  7.10    0.000193          21         9           read
  4.67    0.000127          16         8         8 access
  3.24    0.000088          44         2           write
  2.06    0.000056          28         2           getdents
  1.58    0.000043          14         3           brk
  1.40    0.000038          19         2         2 statfs
  0.92    0.000025          25         1           munmap
  0.92    0.000025          13         2           ioctl
  0.88    0.000024          12         2           rt_sigaction
  0.55    0.000015          15         1           stat
  0.48    0.000013          13         1           futex
  0.44    0.000012          12         1           rt_sigprocmask
  0.40    0.000011          11         1           arch_prctl
  0.40    0.000011          11         1           set_tid_address
  0.40    0.000011          11         1           set_robust_list
  0.40    0.000011          11         1           prlimit64
------ ----------- ----------- --------- --------- ----------------
100.00    0.002718                   156        10 total

```

##### 131. Practice - Strace and / proc on ETCD

> /proc directory
>
> - Information and connection to processes and kernel
> - Study it to learn how processes work
> - Configuration and administrative tasks
> - Contains file that don't exist, yet you can access these

![](./images/Section24/Screenshot_4.png)

```sh
#check etcd's process
root@cks-master:/etc/kubernetes/manifests# ps aux | grep etcd
root      3496  1.5  1.5 10612724 63500 ?      Ssl  12:56   1:26 etcd --advertise-client-urls=https://10.146.0.2:2379 --cert-file=/etc/kubernetes/pki/etcd/server.crt --client-cert-auth=true --data-dir=/var/lib/etcd --initial-advertise-peer-urls=https://10.146.0.2:2380 --initial-cluster=cks-master=https://10.146.0.2:2380 --key-file=/etc/kubernetes/pki/etcd/server.key --listen-client-urls=https://127.0.0.1:2379,https://10.146.0.2:2379 --listen-metrics-urls=http://127.0.0.1:2381 --listen-peer-urls=https://10.146.0.2:2380 --name=cks-master --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt --peer-client-cert-auth=true --peer-key-file=/etc/kubernetes/pki/etcd/peer.key --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt --snapshot-count=10000 --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
root     15275  0.0  0.0  14860  1108 pts/0    S+   14:32   0:00 grep --color=auto etcd
root     21048  5.8  7.8 1102092 318004 ?      Ssl  13:29   3:39 kube-apiserver --advertise-address=10.146.0.2 --admission-control-config-file=/etc/kubernetes/admission/admission_config.yaml --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --insecure-port=0 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key

root@cks-master:/etc/kubernetes/manifests# strace -p 3496
strace: Process 3496 attached
futex(0x1ac6be8, FUTEX_WAIT_PRIVATE, 0, NULL

# follows forks
root@cks-master:/etc/kubernetes/manifests# strace -p 3496 -f

# follows forks
# counts and summaries
root@cks-master:/etc/kubernetes/manifests# strace -p 3496 -f -cw
strace: Process 3496 attached with 12 threads
^Cstrace: Process 3496 detached
strace: Process 3523 detached
strace: Process 3524 detached
strace: Process 3525 detached
strace: Process 3526 detached
strace: Process 3527 detached
strace: Process 3528 detached
strace: Process 3531 detached
strace: Process 3541 detached
strace: Process 3542 detached
strace: Process 3543 detached
strace: Process 14186 detached
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 84.82   44.390464       17429      2547       378 futex
 14.38    7.524283       34047       221           epoll_pwait
  0.40    0.208595       69532         3         2 restart_syscall
  0.30    0.158271         180       877           nanosleep
  0.04    0.022641         119       190           write
  0.04    0.019044        1190        16           fdatasync
  0.02    0.008728          58       150        75 read
  0.00    0.001037          36        29           sched_yield
  0.00    0.000651          31        21           pwrite64
  0.00    0.000509          64         8           lseek
------ ----------- ----------- --------- --------- ----------------
100.00   52.334223                  4062       455 total

```

```sh
root@cks-master:/etc/kubernetes/manifests# cd /proc/3496
root@cks-master:/proc/3496# ls
arch_status  auxv        cmdline          cpuset   exe     gid_map  loginuid   mem        mountstats  numa_maps  oom_score_adj  personality  sched      setgroups     stack  status   timers         wchan
attr         cgroup      comm             cwd      fd      io       map_files  mountinfo  net         oom_adj    pagemap        projid_map   schedstat  smaps         stat   syscall  timerslack_ns
autogroup    clear_refs  coredump_filter  environ  fdinfo  limits   maps       mounts     ns          oom_score  patch_state    root         sessionid  smaps_rollup  statm  task     uid_map


root@cks-master:/proc/3496# ls -lh exe
lrwxrwxrwx 1 root root 0 Oct  8 12:56 exe -> /usr/local/bin/etcd

root@cks-master:/proc/3496# cd fd
root@cks-master:/proc/3496/fd# l
0@  10@  12@  14@  16@  18@  2@   21@  23@  25@  27@  29@  30@  32@  34@  36@  38@  4@   41@  43@  45@  47@  49@  50@  52@  54@  56@  58@  6@   61@  63@  65@  67@  69@  70@  72@  74@  76@  78@  8@   81@  83@  85@  87@  89@  90@  92@  94@
1@  11@  13@  15@  17@  19@  20@  22@  24@  26@  28@  3@   31@  33@  35@  37@  39@  40@  42@  44@  46@  48@  5@   51@  53@  55@  57@  59@  60@  62@  64@  66@  68@  7@   71@  73@  75@  77@  79@  80@  82@  84@  86@  88@  9@   91@  93@
root@cks-master:/proc/3496/fd# ls -lh
total 0
lrwx------ 1 root root 64 Oct  8 12:56 0 -> /dev/null
l-wx------ 1 root root 64 Oct  8 12:56 1 -> 'pipe:[31074]'
l-wx------ 1 root root 64 Oct  8 12:56 10 -> /var/lib/etcd/member/wal/0.tmp
lrwx------ 1 root root 64 Oct  8 12:56 11 -> 'socket:[31988]'
lrwx------ 1 root root 64 Oct  8 12:56 12 -> 'socket:[32002]'
lrwx------ 1 root root 64 Oct  8 12:56 13 -> 'socket:[32003]'
lrwx------ 1 root root 64 Oct  8 12:56 14 -> 'socket:[32004]'
lrwx------ 1 root root 64 Oct  8 12:56 15 -> 'socket:[32006]'
lrwx------ 1 root root 64 Oct  8 12:56 16 -> 'socket:[92866]'
lrwx------ 1 root root 64 Oct  8 12:56 17 -> 'socket:[92868]'
lrwx------ 1 root root 64 Oct  8 12:56 18 -> 'socket:[92877]'
lrwx------ 1 root root 64 Oct  8 12:56 19 -> 'socket:[92873]'
l-wx------ 1 root root 64 Oct  8 12:56 2 -> 'pipe:[31075]'
lrwx------ 1 root root 64 Oct  8 12:56 20 -> 'socket:[92879]'
lrwx------ 1 root root 64 Oct  8 12:56 21 -> 'socket:[92881]'
lrwx------ 1 root root 64 Oct  8 12:56 22 -> 'socket:[92883]'
lrwx------ 1 root root 64 Oct  8 12:56 23 -> 'socket:[92885]'
lrwx------ 1 root root 64 Oct  8 12:56 24 -> 'socket:[92887]'
lrwx------ 1 root root 64 Oct  8 12:56 25 -> 'socket:[92890]'
lrwx------ 1 root root 64 Oct  8 12:56 26 -> 'socket:[93695]'
lrwx------ 1 root root 64 Oct  8 12:56 27 -> 'socket:[93697]'
lrwx------ 1 root root 64 Oct  8 12:56 28 -> 'socket:[93699]'
lrwx------ 1 root root 64 Oct  8 12:56 29 -> 'socket:[92894]'
lrwx------ 1 root root 64 Oct  8 12:56 3 -> 'socket:[31980]'
lrwx------ 1 root root 64 Oct  8 12:56 30 -> 'socket:[92896]'
lrwx------ 1 root root 64 Oct  8 12:56 31 -> 'socket:[93703]'
lrwx------ 1 root root 64 Oct  8 12:56 32 -> 'socket:[92900]'
lrwx------ 1 root root 64 Oct  8 12:56 33 -> 'socket:[92902]'
lrwx------ 1 root root 64 Oct  8 12:56 34 -> 'socket:[93706]'
lrwx------ 1 root root 64 Oct  8 12:56 35 -> 'socket:[93709]'
lrwx------ 1 root root 64 Oct  8 12:56 36 -> 'socket:[92905]'
lrwx------ 1 root root 64 Oct  8 12:56 37 -> 'socket:[93712]'
lrwx------ 1 root root 64 Oct  8 12:56 38 -> 'socket:[92910]'
lrwx------ 1 root root 64 Oct  8 12:56 39 -> 'socket:[92912]'
lrwx------ 1 root root 64 Oct  8 12:56 4 -> 'anon_inode:[eventpoll]'
lrwx------ 1 root root 64 Oct  8 12:56 40 -> 'socket:[92914]'
lrwx------ 1 root root 64 Oct  8 12:56 41 -> 'socket:[93716]'
lrwx------ 1 root root 64 Oct  8 12:56 42 -> 'socket:[92918]'
lrwx------ 1 root root 64 Oct  8 12:56 43 -> 'socket:[92921]'
lrwx------ 1 root root 64 Oct  8 12:56 44 -> 'socket:[92924]'
lrwx------ 1 root root 64 Oct  8 12:56 45 -> 'socket:[93719]'
lrwx------ 1 root root 64 Oct  8 12:56 46 -> 'socket:[93721]'
lrwx------ 1 root root 64 Oct  8 12:56 47 -> 'socket:[92929]'
lrwx------ 1 root root 64 Oct  8 12:56 48 -> 'socket:[93723]'
lrwx------ 1 root root 64 Oct  8 12:56 49 -> 'socket:[92932]'
lrwx------ 1 root root 64 Oct  8 12:56 5 -> 'socket:[31985]'
lrwx------ 1 root root 64 Oct  8 12:56 50 -> 'socket:[93727]'
lrwx------ 1 root root 64 Oct  8 12:56 51 -> 'socket:[92934]'
lrwx------ 1 root root 64 Oct  8 12:56 52 -> 'socket:[92936]'
lrwx------ 1 root root 64 Oct  8 12:56 53 -> 'socket:[92939]'
lrwx------ 1 root root 64 Oct  8 12:56 54 -> 'socket:[93731]'
lrwx------ 1 root root 64 Oct  8 12:56 55 -> 'socket:[93733]'
lrwx------ 1 root root 64 Oct  8 12:56 56 -> 'socket:[92946]'
lrwx------ 1 root root 64 Oct  8 12:56 57 -> 'socket:[92948]'
lrwx------ 1 root root 64 Oct  8 12:56 58 -> 'socket:[92950]'
lrwx------ 1 root root 64 Oct  8 12:56 59 -> 'socket:[92952]'
lrwx------ 1 root root 64 Oct  8 12:56 6 -> 'socket:[31986]'
lrwx------ 1 root root 64 Oct  8 12:56 60 -> 'socket:[92955]'
lrwx------ 1 root root 64 Oct  8 12:56 61 -> 'socket:[92957]'
lrwx------ 1 root root 64 Oct  8 12:56 62 -> 'socket:[93740]'
lrwx------ 1 root root 64 Oct  8 12:56 63 -> 'socket:[93743]'
lrwx------ 1 root root 64 Oct  8 12:56 64 -> 'socket:[93745]'
lrwx------ 1 root root 64 Oct  8 12:56 65 -> 'socket:[93748]'
lrwx------ 1 root root 64 Oct  8 12:56 66 -> 'socket:[93751]'
lrwx------ 1 root root 64 Oct  8 12:56 67 -> 'socket:[93753]'
lrwx------ 1 root root 64 Oct  8 12:56 68 -> 'socket:[93756]'
lrwx------ 1 root root 64 Oct  8 12:56 69 -> 'socket:[93758]'
lrwx------ 1 root root 64 Oct  8 12:56 7 -> /var/lib/etcd/member/snap/db
lrwx------ 1 root root 64 Oct  8 12:56 70 -> 'socket:[93760]'
lrwx------ 1 root root 64 Oct  8 12:56 71 -> 'socket:[93763]'
lrwx------ 1 root root 64 Oct  8 12:56 72 -> 'socket:[93765]'
lrwx------ 1 root root 64 Oct  8 12:56 73 -> 'socket:[93767]'
lrwx------ 1 root root 64 Oct  8 12:56 74 -> 'socket:[92967]'
lrwx------ 1 root root 64 Oct  8 12:56 75 -> 'socket:[92969]'
lrwx------ 1 root root 64 Oct  8 12:56 76 -> 'socket:[92971]'
lrwx------ 1 root root 64 Oct  8 12:56 77 -> 'socket:[93772]'
lrwx------ 1 root root 64 Oct  8 12:56 78 -> 'socket:[93774]'
lrwx------ 1 root root 64 Oct  8 12:56 79 -> 'socket:[93777]'
lrwx------ 1 root root 64 Oct  8 12:56 8 -> /var/lib/etcd/member/wal/0000000000000000-0000000000000000.wal
lrwx------ 1 root root 64 Oct  8 12:56 80 -> 'socket:[92975]'
lrwx------ 1 root root 64 Oct  8 12:56 81 -> 'socket:[92977]'
lrwx------ 1 root root 64 Oct  8 12:56 82 -> 'socket:[93781]'
lrwx------ 1 root root 64 Oct  8 12:56 83 -> 'socket:[92980]'
lrwx------ 1 root root 64 Oct  8 12:56 84 -> 'socket:[93783]'
lrwx------ 1 root root 64 Oct  8 12:56 85 -> 'socket:[93785]'
lrwx------ 1 root root 64 Oct  8 12:56 86 -> 'socket:[93787]'
lrwx------ 1 root root 64 Oct  8 12:56 87 -> 'socket:[93790]'
lrwx------ 1 root root 64 Oct  8 12:56 88 -> 'socket:[92986]'
lrwx------ 1 root root 64 Oct  8 12:56 89 -> 'socket:[92988]'
lr-x------ 1 root root 64 Oct  8 12:56 9 -> /var/lib/etcd/member/wal
lrwx------ 1 root root 64 Oct  8 12:56 90 -> 'socket:[93794]'
lrwx------ 1 root root 64 Oct  8 12:56 91 -> 'socket:[93796]'
lrwx------ 1 root root 64 Oct  8 12:56 92 -> 'socket:[92991]'
lrwx------ 1 root root 64 Oct  8 12:56 93 -> 'socket:[92993]'
lrwx------ 1 root root 64 Oct  8 12:56 94 -> 'socket:[92996]'

root@cks-master:/proc/3496/fd# tail -f 7


root@cks-master:/proc/3496/fd# k create secret generic credit-card --from-literal cc=1234 -oyaml --dry-run=client
apiVersion: v1
data:
  cc: MTIzNA==
kind: Secret
metadata:
  creationTimestamp: null
  name: credit-card
root@cks-master:/proc/3496/fd#

root@cks-master:/proc/3496/fd# k create secret generic credit-card --from-literal cc=1234
secret/credit-card created

root@cks-master:/proc/3496/fd# cat 7 | grep 1234
Binary file (standard input) matches

root@cks-master:/proc/3496/fd# cat 7 | strings | grep 1234
1234
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH

#show 
root@cks-master:/proc/3496/fd# cat 7 | strings | grep 1234 -A20 -B20
coordination.k8s.io/v1
Lease
kube-controller-manager
kube-system"
*$179216d9-f275-4598-9a9f-01fada59a7db2
kube-controller-manager
Update
coordination.k8s.io/v1"
FieldsV1:|
z{"f:spec":{"f:acquireTime":{},"f:holderIdentity":{},"f:leaseDurationSeconds":{},"f:leaseTransitions":{},"f:renewTime":{}}}
/cks-master_fd43b223-f8f4-46f9-8b2f-03c818d7babd
%/registry/secrets/default/credit-card
Secret
credit-card
default"
*$e794e1a9-a45a-4bc7-8ff3-ec56d580c9f52
kubectl-create
Update
FieldsV1:+
){"f:data":{".":{},"f:cc":{}},"f:type":{}}
1234
Opaque
+/registry/leases/kube-node-lease/cks-worker
coordination.k8s.io/v1
Lease
cks-worker
kube-node-lease"
*$5caa47e7-cb97-465b-be9f-3473e265aede2
Node
cks-worker"$3b44c135-40f9-463a-819d-e9cd5123bcd9*
kubelet
Update
coordination.k8s.io/v1"
FieldsV1:
{"f:metadata":{"f:ownerReferences":{".":{},"k:{\"uid\":\"3b44c135-40f9-463a-819d-e9cd5123bcd9\"}":{".":{},"f:apiVersion":{},"f:kind":{},"f:name":{},"f:uid":{}}}},"f:spec":{"f:holderIdentity":{},"f:leaseDurationSeconds":{},"f:renewTime":{}}}
cks-worker
+/registry/leases/kube-node-lease/cks-master
coordination.k8s.io/v1
Lease
cks-master
kube-node-lease"
--
cks-workerX
default-scheduler
node.kubernetes.io/not-ready
Exists
"       NoExecute(
node.kubernetes.io/unreachable
Exists
"       NoExecute(
PreemptLowerPriority
Running
Initialized
True
Ready
True
ContainersReady
True
PodScheduled
True
10.146.0.32     10.44.0.2:
test
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
BestEffortZ
        10.44.0.2
/registry/pods/default/tests
tests
default"
*$e7e5b4c6-eb88-49cf-bb34-6adff8caad1c2
testsz
kubectl-run
Update
FieldsV1:
{"f:metadata":{"f:labels":{".":{},"f:run":{}}},"f:spec":{"f:containers":{"k:{\"name\":\"tests\"}":{".":{},"f:image":{},"f:imagePullPolicy":{},"f:name":{},"f:resources":{},"f:terminationMessagePath":{},"f:terminationMessagePolicy":{}}},"f:dnsPolicy":{},"f:enableServiceLinks":{},"f:restartPolicy":{},"f:schedulerName":{},"f:securityContext":{},"f:terminationGracePeriodSeconds":{}}}
kubelet
Update
FieldsV1:
{"f:status":{"f:conditions":{"k:{\"type\":\"ContainersReady\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}},"k:{\"type\":\"Initialized\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}},"k:{\"type\":\"Ready\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}}},"f:containerStatuses":{},"f:hostIP":{},"f:phase":{},"f:podIP":{},"f:podIPs":{".":{},"k:{\"ip\":\"10.44.0.3\"}":{".":{},"f:ip":{}}},"f:startTime":{}}}
kube-api-access-rzpd4
token
kube-root-ca.crt
ca.crt
ca.crt
--
cks-workerX
default-scheduler
node.kubernetes.io/not-ready
Exists
"       NoExecute(
node.kubernetes.io/unreachable
Exists
"       NoExecute(
PreemptLowerPriority
Running
Initialized
True
Ready
True
ContainersReady
True
PodScheduled
True
10.146.0.32     10.44.0.2:
test
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
BestEffortZ
        10.44.0.2
/registry/pods/default/tests
tests
default"
*$e7e5b4c6-eb88-49cf-bb34-6adff8caad1c2
testsz
kubectl-run
Update
FieldsV1:
{"f:metadata":{"f:labels":{".":{},"f:run":{}}},"f:spec":{"f:containers":{"k:{\"name\":\"tests\"}":{".":{},"f:image":{},"f:imagePullPolicy":{},"f:name":{},"f:resources":{},"f:terminationMessagePath":{},"f:terminationMessagePolicy":{}}},"f:dnsPolicy":{},"f:enableServiceLinks":{},"f:restartPolicy":{},"f:schedulerName":{},"f:securityContext":{},"f:terminationGracePeriodSeconds":{}}}
kubelet
Update
FieldsV1:
{"f:status":{"f:conditions":{"k:{\"type\":\"ContainersReady\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}},"k:{\"type\":\"Initialized\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}},"k:{\"type\":\"Ready\"}":{".":{},"f:lastProbeTime":{},"f:lastTransitionTime":{},"f:status":{},"f:type":{}}},"f:containerStatuses":{},"f:hostIP":{},"f:phase":{},"f:podIP":{},"f:podIPs":{".":{},"k:{\"ip\":\"10.44.0.3\"}":{".":{},"f:ip":{}}},"f:startTime":{}}}
kube-api-access-rzpd4
token
kube-root-ca.crt
ca.crt
ca.crt
--
cks-workerX
default-scheduler
node.kubernetes.io/not-ready
Exists
"       NoExecute(
node.kubernetes.io/unreachable
Exists
"       NoExecute(
PreemptLowerPriority
Running
Initialized
True
Ready
True
ContainersReady
True
PodScheduled
True
10.146.0.32     10.44.0.2:
test
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
BestEffortZ
        10.44.0.2
//registry/events/default/tests.16ac11088ec94978
Event
tests.16ac11088ec94978
default"
*$1ba91c82-6575-4d79-8764-9c76ffb1504b2
kube-scheduler
Update
events.k8s.io/v1"
FieldsV1:
{"f:action":{},"f:eventTime":{},"f:note":{},"f:reason":{},"f:regarding":{"f:apiVersion":{},"f:kind":{},"f:name":{},"f:namespace":{},"f:resourceVersion":{},"f:uid":{}},"f:reportingController":{},"f:reportingInstance":{},"f:type":{}}
default
tests"$e7e5b4c6-eb88-49cf-bb34-6adff8caad1c*
3974:
        Scheduled"1Successfully assigned default/tests to cks-worker*
NormalR
Bindingr
default-schedulerz
default-scheduler-cks-master
--
cks-workerX
default-scheduler
node.kubernetes.io/not-ready
Exists
"       NoExecute(
node.kubernetes.io/unreachable
Exists
"       NoExecute(
PreemptLowerPriority
Running
Initialized
True
Ready
True
ContainersReady
True
PodScheduled
True
10.146.0.32     10.44.0.2:
test
docker.io/library/nginx:latest:_docker.io/library/nginx@sha256:06e4235e95299b1d6d595c5ef4c41a9b12641f6683136c18394b858967cd1506BMcontainerd://3ff96df404a9f5a9410774eb835d577ab9e867f50123409392341961a7ca0f2dH
BestEffortZ
        10.44.0.2
+/registry/leases/kube-node-lease/cks-worker
coordination.k8s.io/v1
Lease
cks-worker
kube-node-lease"
*$5caa47e7-cb97-465b-be9f-3473e265aede2
Node
cks-worker"$3b44c135-40f9-463a-819d-e9cd5123bcd9*
kubelet
Update
coordination.k8s.io/v1"
FieldsV1:
{"f:metadata":{"f:ownerReferences":{".":{},"k:{\"uid\":\"3b44c135-40f9-463a-819d-e9cd5123bcd9\"}":{".":{},"f:apiVersion":{},"f:kind":{},"f:name":{},"f:uid":{}}}},"f:spec":{"f:holderIdentity":{},"f:leaseDurationSeconds":{},"f:renewTime":{}}}
cks-worker
+/registry/leases/kube-node-lease/cks-master
coordination.k8s.io/v1
Lease
cks-master
```



##### 132. Practice - /proc and env variables

> /proc access env variables
>
> *Create Apache pod with a secret as environment variable*
>
> Read that secret from host filesystem
>
> Secrets as environment variables can be read from anyone who can access /proc on the host

```sh
 k run apache --image=httpd -oyaml --dry-run=client > pod.yaml
 vim pod.yaml
----
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: apache
  name: apache
spec:
  containers:
  - image: httpd
    name: apache
    resources: {}
    env:
    - name: SECRET
      value: "55667788"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
--- 
root@cks-master:~# k -f pod.yaml create
pod/apache created

root@cks-master:~# k exec apache -- env
PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=apache
HTTPD_PREFIX=/usr/local/apache2
HTTPD_VERSION=2.4.51
HTTPD_SHA256=20e01d81fecf077690a4439e3969a9b22a09a8d43c525356e863407741b838f4
HTTPD_PATCHES=
SECRET=55667788
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
HOME=/root

# check where apache is running
root@cks-master:~# k get pod -owide | grep apache
apache   1/1     Running   0          106s   10.44.0.2   cks-worker   <none>           <none>

#login the server 
#check the process
root@cks-worker:~# ps aux | grep httpd
root     14878  0.0  0.1   5952  4500 ?        Ss   00:24   0:00 httpd -DFOREGROUND
daemon   14908  0.0  0.0 1210620 3480 ?        Sl   00:24   0:00 httpd -DFOREGROUND
daemon   14909  0.0  0.0 1210620 3484 ?        Sl   00:24   0:00 httpd -DFOREGROUND
daemon   14910  0.0  0.0 1210620 3480 ?        Sl   00:24   0:00 httpd -DFOREGROUND
root     18435  0.0  0.0  14860  1036 pts/0    R+   00:38   0:00 grep --color=auto httpd

root@cks-worker:~# pstree -p
systemd(1)─┬─accounts-daemon(1324)─┬─{accounts-daemon}(1334)
           │                       └─{accounts-daemon}(1345)
           ├─agetty(1599)
           ├─agetty(1690)
           ├─atd(1144)
           ├─chronyd(1139)
           ├─containerd(1445)─┬─{containerd}(1471)
           │                  ├─{containerd}(1473)
           │                  ├─{containerd}(1474)
           │                  ├─{containerd}(1475)
           │                  ├─{containerd}(1476)
           │                  ├─{containerd}(1489)
           │                  ├─{containerd}(1494)
           │                  ├─{containerd}(1495)
           │                  ├─{containerd}(2634)
           │                  ├─{containerd}(2635)
           │                  ├─{containerd}(2636)
           │                  ├─{containerd}(3870)
           │                  └─{containerd}(14846)
           ├─containerd-shim(2578)─┬─launch.sh(3134)─┬─kube-utils(3527)─┬─{kube-utils}(3528)
           │                       │                 │                  ├─{kube-utils}(3529)
           │                       │                 │                  ├─{kube-utils}(3530)
           │                       │                 │                  ├─{kube-utils}(3531)
           │                       │                 │                  ├─{kube-utils}(3532)
           │                       │                 │                  ├─{kube-utils}(3533)
           │                       │                 │                  └─{kube-utils}(4571)
           │                       │                 └─weaver(3335)─┬─{weaver}(3337)
           │                       │                                ├─{weaver}(3338)
           │                       │                                ├─{weaver}(3339)
           │                       │                                ├─{weaver}(3340)
           │                       │                                ├─{weaver}(3344)
           │                       │                                ├─{weaver}(3345)
           │                       │                                ├─{weaver}(3470)
           │                       │                                ├─{weaver}(3472)
           │                       │                                ├─{weaver}(3473)
           │                       │                                ├─{weaver}(3477)
           │                       │                                ├─{weaver}(3478)
           │                       │                                ├─{weaver}(3487)
           │                       │                                └─{weaver}(4570)
           │                       ├─pause(2611)
           │                       ├─weave-npc(3203)─┬─ulogd(3258)
           │                       │                 ├─{weave-npc}(3251)
           │                       │                 ├─{weave-npc}(3252)
           │                       │                 ├─{weave-npc}(3253)
           │                       │                 ├─{weave-npc}(3257)
           │                       │                 ├─{weave-npc}(3263)
           │                       │                 ├─{weave-npc}(3323)
           │                       │                 ├─{weave-npc}(3324)
           │                       │                 └─{weave-npc}(3325)
           │                       ├─{containerd-shim}(2579)
           │                       ├─{containerd-shim}(2580)
           │                       ├─{containerd-shim}(2581)
           │                       ├─{containerd-shim}(2582)
           │                       ├─{containerd-shim}(2583)
           │                       ├─{containerd-shim}(2584)
           │                       ├─{containerd-shim}(2585)
           │                       ├─{containerd-shim}(2586)
           │                       ├─{containerd-shim}(2587)
           │                       ├─{containerd-shim}(2588)
           │                       ├─{containerd-shim}(2624)
           │                       ├─{containerd-shim}(2692)
           │                       ├─{containerd-shim}(2693)
           │                       └─{containerd-shim}(3035)
           ├─containerd-shim(2754)─┬─kube-proxy(2872)─┬─{kube-proxy}(2928)
           │                       │                  ├─{kube-proxy}(2929)
           │                       │                  ├─{kube-proxy}(2930)
           │                       │                  ├─{kube-proxy}(2931)
           │                       │                  ├─{kube-proxy}(2970)
           │                       │                  └─{kube-proxy}(2975)
           │                       ├─pause(2808)
           │                       ├─{containerd-shim}(2758)
           │                       ├─{containerd-shim}(2759)
           │                       ├─{containerd-shim}(2760)
           │                       ├─{containerd-shim}(2761)
           │                       ├─{containerd-shim}(2765)
           │                       ├─{containerd-shim}(2766)
           │                       ├─{containerd-shim}(2767)
           │                       ├─{containerd-shim}(2768)
           │                       ├─{containerd-shim}(2769)
           │                       ├─{containerd-shim}(2771)
           │                       ├─{containerd-shim}(2772)
           │                       ├─{containerd-shim}(2834)
           │                       └─{containerd-shim}(2835)
           ├─containerd-shim(14776)─┬─httpd(14878)─┬─httpd(14908)─┬─{httpd}(14967)
           │                        │              │              ├─{httpd}(14968)
           │                        │              │              ├─{httpd}(14969)
           │                        │              │              ├─{httpd}(14970)
           │                        │              │              ├─{httpd}(14971)
           │                        │              │              ├─{httpd}(14972)
           │                        │              │              ├─{httpd}(14973)
           │                        │              │              ├─{httpd}(14974)
           │                        │              │              ├─{httpd}(14975)
           │                        │              │              ├─{httpd}(14976)
           │                        │              │              ├─{httpd}(14977)
           │                        │              │              ├─{httpd}(14978)
           │                        │              │              ├─{httpd}(14979)
           │                        │              │              ├─{httpd}(14980)
           │                        │              │              ├─{httpd}(14981)
           │                        │              │              ├─{httpd}(14982)
           │                        │              │              ├─{httpd}(14983)
           │                        │              │              ├─{httpd}(14984)
           │                        │              │              ├─{httpd}(14985)
           │                        │              │              ├─{httpd}(14986)
           │                        │              │              ├─{httpd}(14987)
           │                        │              │              ├─{httpd}(14988)
           │                        │              │              ├─{httpd}(14989)
           │                        │              │              ├─{httpd}(14990)
           │                        │              │              ├─{httpd}(14991)
           │                        │              │              └─{httpd}(14992)
           │                        │              ├─httpd(14909)─┬─{httpd}(14936)
           │                        │              │              ├─{httpd}(14937)
           │                        │              │              ├─{httpd}(14938)
           │                        │              │              ├─{httpd}(14939)
           │                        │              │              ├─{httpd}(14940)
           │                        │              │              ├─{httpd}(14941)
           │                        │              │              ├─{httpd}(14942)
           │                        │              │              ├─{httpd}(14943)
           │                        │              │              ├─{httpd}(14944)
           │                        │              │              ├─{httpd}(14945)
           │                        │              │              ├─{httpd}(14946)
           │                        │              │              ├─{httpd}(14947)
           │                        │              │              ├─{httpd}(14953)
           │                        │              │              ├─{httpd}(14954)
           │                        │              │              ├─{httpd}(14955)
           │                        │              │              ├─{httpd}(14956)
           │                        │              │              ├─{httpd}(14957)
           │                        │              │              ├─{httpd}(14958)
           │                        │              │              ├─{httpd}(14959)
           │                        │              │              ├─{httpd}(14960)
           │                        │              │              ├─{httpd}(14961)
           │                        │              │              ├─{httpd}(14962)
           │                        │              │              ├─{httpd}(14963)
           │                        │              │              ├─{httpd}(14964)
           │                        │              │              ├─{httpd}(14965)
           │                        │              │              └─{httpd}(14966)
           │                        │              └─httpd(14910)─┬─{httpd}(14915)
           │                        │                             ├─{httpd}(14916)
           │                        │                             ├─{httpd}(14917)
           │                        │                             ├─{httpd}(14918)
           │                        │                             ├─{httpd}(14919)
           │                        │                             ├─{httpd}(14920)
           │                        │                             ├─{httpd}(14921)
           │                        │                             ├─{httpd}(14922)
           │                        │                             ├─{httpd}(14923)
           │                        │                             ├─{httpd}(14924)
           │                        │                             ├─{httpd}(14925)
           │                        │                             ├─{httpd}(14926)
           │                        │                             ├─{httpd}(14927)
           │                        │                             ├─{httpd}(14928)
           │                        │                             ├─{httpd}(14929)
           │                        │                             ├─{httpd}(14930)
           │                        │                             ├─{httpd}(14931)
           │                        │                             ├─{httpd}(14932)
           │                        │                             ├─{httpd}(14933)
           │                        │                             ├─{httpd}(14934)
           │                        │                             ├─{httpd}(14935)
           │                        │                             ├─{httpd}(14948)
           │                        │                             ├─{httpd}(14949)
           │                        │                             ├─{httpd}(14950)
           │                        │                             ├─{httpd}(14951)
           │                        │                             └─{httpd}(14952)
           │                        ├─pause(14809)
           │                        ├─{containerd-shim}(14777)
           │                        ├─{containerd-shim}(14778)
           │                        ├─{containerd-shim}(14779)
           │                        ├─{containerd-shim}(14780)
           │                        ├─{containerd-shim}(14781)
           │                        ├─{containerd-shim}(14782)
           │                        ├─{containerd-shim}(14783)
           │                        ├─{containerd-shim}(14784)
           │                        ├─{containerd-shim}(14785)
           │                        ├─{containerd-shim}(14786)
           │                        ├─{containerd-shim}(14820)
           │                        ├─{containerd-shim}(14821)
           │                        └─{containerd-shim}(16296)
           ├─cron(1878)
           ├─dbus-daemon(1330)
           ├─dockerd(1557)─┬─{dockerd}(1574)
           │               ├─{dockerd}(1575)
           │               ├─{dockerd}(1576)
           │               ├─{dockerd}(1577)
           │               ├─{dockerd}(1578)
           │               ├─{dockerd}(1616)
           │               ├─{dockerd}(1627)
           │               ├─{dockerd}(1655)
           │               └─{dockerd}(1656)
           ├─google_guest_ag(1584)─┬─{google_guest_ag}(1600)
           │                       ├─{google_guest_ag}(1601)
           │                       ├─{google_guest_ag}(1602)
           │                       ├─{google_guest_ag}(1603)
           │                       ├─{google_guest_ag}(1617)
           │                       ├─{google_guest_ag}(1618)
           │                       ├─{google_guest_ag}(1619)
           │                       ├─{google_guest_ag}(1621)
           │                       ├─{google_guest_ag}(1626)
           │                       └─{google_guest_ag}(1629)
           ├─google_osconfig(1326)─┬─{google_osconfig}(1346)
           │                       ├─{google_osconfig}(1347)
           │                       ├─{google_osconfig}(1348)
           │                       ├─{google_osconfig}(1349)
           │                       ├─{google_osconfig}(1355)
           │                       ├─{google_osconfig}(1360)
           │                       ├─{google_osconfig}(1361)
           │                       ├─{google_osconfig}(1362)
           │                       ├─{google_osconfig}(1364)
           │                       └─{google_osconfig}(1366)
           ├─kubelet(1325)─┬─{kubelet}(1350)
           │               ├─{kubelet}(1351)
           │               ├─{kubelet}(1352)
           │               ├─{kubelet}(1353)
           │               ├─{kubelet}(1363)
           │               ├─{kubelet}(1543)
           │               ├─{kubelet}(1544)
           │               ├─{kubelet}(1978)
           │               ├─{kubelet}(1979)
           │               ├─{kubelet}(1983)
           │               ├─{kubelet}(2012)
           │               ├─{kubelet}(2013)
           │               ├─{kubelet}(2014)
           │               └─{kubelet}(2567)
           ├─lvmetad(473)
           ├─lxcfs(1063)─┬─{lxcfs}(1066)
           │             └─{lxcfs}(1067)
           ├─networkd-dispat(1328)───{networkd-dispat}(1373)
           ├─polkitd(1504)─┬─{polkitd}(1520)
           │               └─{polkitd}(1522)
           ├─rsyslogd(1029)─┬─{rsyslogd}(1056)
           │                ├─{rsyslogd}(1058)
           │                └─{rsyslogd}(1059)
           ├─snapd(1288)─┬─{snapd}(1354)
           │             ├─{snapd}(1356)
           │             ├─{snapd}(1357)
           │             ├─{snapd}(1358)
           │             ├─{snapd}(1359)
           │             ├─{snapd}(1406)
           │             ├─{snapd}(1408)
           │             ├─{snapd}(1440)
           │             ├─{snapd}(1441)
           │             ├─{snapd}(2668)
           │             └─{snapd}(2669)
           ├─sshd(15656)───sshd(15733)───bash(15734)───sudo(17484)───bash(17485)───pstree(18895)
           ├─sshd(18314)
           ├─sshguard-journa(1444)─┬─journalctl(1446)
           │                       └─sshguard(1447)─┬─sshg-fw(1451)
           │                                        └─{sshguard}(1539)
           ├─systemd(15658)───(sd-pam)(15659)
           ├─systemd-journal(464)
           ├─systemd-logind(1863)
           ├─systemd-network(855)
           ├─systemd-resolve(882)
           ├─systemd-udevd(482)
           └─unattended-upgr(1367)───{unattended-upgr}(1393)
# find the password in the /proc
root@cks-worker:~# cd /proc/14878
root@cks-worker:/proc/14878# ls
arch_status  coredump_filter  io         mountstats     patch_state  smaps         timers
attr         cpuset           limits     net            personality  smaps_rollup  timerslack_ns
autogroup    cwd              loginuid   ns             projid_map   stack         uid_map
auxv         environ          map_files  numa_maps      root         stat          wchan
cgroup       exe              maps       oom_adj        sched        statm
clear_refs   fd               mem        oom_score      schedstat    status
cmdline      fdinfo           mountinfo  oom_score_adj  sessionid    syscall
comm         gid_map          mounts     pagemap        setgroups    task
root@cks-worker:/proc/14878# ls -lh exe
lrwxrwxrwx 1 root root 0 Oct  9 00:24 exe -> /usr/local/apache2/bin/httpd
root@cks-worker:/proc/14878# cd fd
root@cks-worker:/proc/14878/fd# l
0@  1@  2@  3@  4@  5@  6@  7@
root@cks-worker:/proc/14878/fd# ls -lha
total 0
dr-x------ 2 root root  0 Oct  9 00:24 .
dr-xr-xr-x 9 root root  0 Oct  9 00:24 ..
lrwx------ 1 root root 64 Oct  9 00:24 0 -> /dev/null
l-wx------ 1 root root 64 Oct  9 00:24 1 -> 'pipe:[62297]'
l-wx------ 1 root root 64 Oct  9 00:24 2 -> 'pipe:[62298]'
lrwx------ 1 root root 64 Oct  9 00:24 3 -> 'socket:[62391]'
lrwx------ 1 root root 64 Oct  9 00:24 4 -> 'socket:[62392]'
lr-x------ 1 root root 64 Oct  9 00:24 5 -> 'pipe:[62405]'
l-wx------ 1 root root 64 Oct  9 00:24 6 -> 'pipe:[62405]'
l-wx------ 1 root root 64 Oct  9 00:24 7 -> 'pipe:[62297]'
root@cks-worker:/proc/14878/fd# man ls
root@cks-worker:/proc/14878/fd# cd ..
root@cks-worker:/proc/14878# cat environ
HTTPD_VERSION=2.4.51KUBERNETES_PORT=tcp://10.96.0.1:443KUBERNETES_SERVICE_PORT=443HOSTNAME=apacheHOME=/rootHTTPD_PATCHES=KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/binKUBERNETES_PORT_443_TCP_PORT=443HTTPD_SHA256=20e01d81fecf077690a4439e3969a9b22a09a8d43c525356e863407741b838f4KUBERNETES_PORT_443_TCP_PROTO=tcpSECRET=55667788HTTPD_PREFIX=/usr/local/apache2KUBERNETES_SERVICE_PORT_HTTPS=443KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443KUBERNETES_SERVICE_HOST=10.96.0.1PWD=/usr/local/apache2root@cks-worker:/proc/14878#
```



##### 133.Practice - Falco and Installation

![](./images/Section24/Screenshot_5.png)

> Install falo in the worker node

```sh
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt-get -y install linux-headers-$(uname -r)
apt-get install -y falco

root@cks-worker:~# service falco status
● falco.service - LSB: Falco syscall activity monitoring agent
   Loaded: loaded (/etc/init.d/falco; generated)
   Active: inactive (dead)
     Docs: man:systemd-sysv-generator(8)
#start falco     
root@cks-worker:~# service falco start
root@cks-worker:~# service falco status
● falco.service - LSB: Falco syscall activity monitoring agent
   Loaded: loaded (/etc/init.d/falco; generated)
   Active: active (running) since Sat 2021-10-09 01:05:32 UTC; 1s ago
     Docs: man:systemd-sysv-generator(8)
  Process: 27126 ExecStart=/etc/init.d/falco start (code=exited, status=0/SUCCESS)
    Tasks: 7 (limit: 4666)
   CGroup: /system.slice/falco.service
           └─27159 /usr/bin/falco --daemon --pidfile=/var/run/falco.pid

Oct 09 01:05:32 cks-worker falco[27126]: Sat Oct  9 01:05:32 2021: Falco initialized with configuration
Oct 09 01:05:32 cks-worker falco[27126]: Sat Oct  9 01:05:32 2021: Loading rules from file /etc/falco/f
Oct 09 01:05:32 cks-worker falco[27142]: Falco initialized with configuration file /etc/falco/falco.yam
Oct 09 01:05:32 cks-worker falco[27142]: Loading rules from file /etc/falco/falco_rules.yaml:
Oct 09 01:05:32 cks-worker falco[27142]: Loading rules from file /etc/falco/falco_rules.local.yaml:
Oct 09 01:05:32 cks-worker falco[27126]: Sat Oct  9 01:05:32 2021: Loading rules from file /etc/falco/f
Oct 09 01:05:32 cks-worker falco[27142]: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Oct 09 01:05:32 cks-worker falco[27126]: Sat Oct  9 01:05:32 2021: Loading rules from file /etc/falco/k
Oct 09 01:05:32 cks-worker systemd[1]: Started LSB: Falco syscall activity monitoring agent.
Oct 09 01:05:32 cks-worker falco[27159]: Starting internal webserver, listening on port 8765
     
```

https://v1-17.docs.kubernetes.io/docs/tasks/debug-application-cluster/falco/

```sh
root@cks-worker:~# vim /etc/falco/falco.yaml

---
root@cks-worker:~# tail -f /var/log/syslog | grep falco
Oct  9 01:05:32 cks-worker kernel: [ 4660.830531] falco: initializing ring buffer for CPU 0
Oct  9 01:05:32 cks-worker kernel: [ 4660.842261] falco: CPU buffer initialized, size=8388608
Oct  9 01:05:32 cks-worker kernel: [ 4660.842263] falco: initializing ring buffer for CPU 1
Oct  9 01:05:32 cks-worker kernel: [ 4660.853898] falco: CPU buffer initialized, size=8388608
Oct  9 01:05:32 cks-worker kernel: [ 4660.853926] falco: starting capture
Oct  9 01:05:32 cks-worker falco: Starting internal webserver, listening on port 8765
Oct  9 01:07:10 cks-worker falco: 01:07:10.657746998: Error File below /etc opened for writing (user=root user_loginuid=1001 command=vim /etc/falco/falco.yaml parent=bash pcmdline=bash file=/etc/falco/.falco.yaml.swp program=vim gparent=sudo ggparent=bash gggparent=sshd container_id=host image=<NA>)
Oct  9 01:07:10 cks-worker falco: 01:07:10.657759909: Error File below /etc opened for writing (user=root user_loginuid=1001 command=vim /etc/falco/falco.yaml parent=bash pcmdline=bash file=/etc/falco/.falco.yaml.swx program=vim gparent=sudo ggparent=bash gggparent=sshd container_id=host image=<NA>)
Oct  9 01:07:10 cks-worker falco: 01:07:10.657803498: Error File below /etc opened for writing (user=root user_loginuid=1001 command=vim /etc/falco/falco.yaml parent=bash pcmdline=bash file=/etc/falco/.falco.yaml.swp program=vim gparent=sudo ggparent=bash gggparent=sshd container_id=host image=<NA>)

```

##### 134. Practice - Use Falco to find malious processes

> Use Falco to find malicious processes inside containers

```sh
#try to edit the sensitive file 
root@cks-master:~# k exec -it apache -- bash
root@apache:/usr/local/apache2# ls
bin  build  cgi-bin  conf  error  htdocs  icons  include  logs  modules
root@apache:/usr/local/apache2# echo user >> /etc/passwd
root@apache:/usr/local/apache2#

#falco will logs the 'edit' action
root@cks-worker:~# tail -f /var/log/syslog | grep falco
Oct  9 01:21:30 cks-worker falco: 01:21:30.022862110: Error File below /etc opened for writing (user=root user_loginuid=-1 command=bash parent=<NA> pcmdline=<NA> file=/etc/passwd program=bash gparent=<NA> ggparent=<NA> gggparent=<NA> container_id=host image=<NA>)

```

```sh
# change the pod to live probe
vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: apache
  name: apache
spec:
  containers:
  - image: httpd
    name: apache
    resources: {}
    env:
    - name: SECRET
      value: "55667788"
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 3
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "apache" force deleted


# why I can't show the log in the falco
root@cks-master:~# k -f pod.yaml create
pod/apache created

vim k8s_audit_rules.yaml

```





https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

##### 135. Practice - Investigate Falco Rules

```sh

root@cks-worker:~# cd /etc/falco/
root@cks-worker:/etc/falco# l
falco.yaml  falco_rules.local.yaml  falco_rules.yaml  k8s_audit_rules.yaml  rules.available/  rules.d/
#serache the key word
/was spawned

```



##### 136. Practice - Change Falco Rule





![](./images/Section24/Screenshot_6.png)

```sh
root@cks-worker:/etc/falco# service falco stop
root@cks-worker:/etc/falco# falco
Sat Oct  9 01:55:25 2021: Falco version 0.26.1 (driver version 2aa88dcf6243982697811df4c1b484bcbe9488a2)
Sat Oct  9 01:55:25 2021: Falco initialized with configuration file /etc/falco/falco.yaml
Sat Oct  9 01:55:25 2021: Loading rules from file /etc/falco/falco_rules.yaml:
Sat Oct  9 01:55:25 2021: Loading rules from file /etc/falco/falco_rules.local.yaml:
Sat Oct  9 01:55:25 2021: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Sat Oct  9 01:55:25 2021: Starting internal webserver, listening on port 8765


```



```sh
#copy the rule from falco_rules.yaml
vim /etc/falco/falco_rules.yaml

#Paste the rule to falco_rules.local.yaml
vim /etc/falco/falco_rules.local.yaml
---
- rule: Terminal shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal.
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    A shell was spawned in a container with an attached terminal (user=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: WARNING
  tags: [container, shell, mitre_execution]
---
#falco load the local rules
root@cks-worker:~# falco
Sat Oct  9 06:35:39 2021: Falco version 0.30.0 (driver version 3aa7a83bf7b9e6229a3824e3fd1f4452d1e95cb4)
Sat Oct  9 06:35:39 2021: Falco initialized with configuration file /etc/falco/falco.yaml
Sat Oct  9 06:35:39 2021: Loading rules from file /etc/falco/falco_rules.yaml:
Sat Oct  9 06:35:39 2021: Loading rules from file /etc/falco/falco_rules.local.yaml:
Sat Oct  9 06:35:39 2021: Loading rules from file /etc/falco/k8s_audit_rules.yaml:
Sat Oct  9 06:35:40 2021: Starting internal webserver, listening on port 8765
06:35:40.823125414: Notice Privileged container started (user=root user_loginuid=0 command=container:a31d2fd68539 weave (id=a31d2fd68539) image=docker.io/weaveworks/weave-kube:2.8.1)
06:35:40.823125414: Notice Privileged container started (user=root user_loginuid=0 command=container:85aea949b95d weave-npc (id=85aea949b95d) image=docker.io/weaveworks/weave-npc:2.8.1)

# login the container from cks-master node
root@cks-master:~# k exec -it apache -- sh
#

# It shows logs in the worker logs
root@cks-worker:~# falco
06:36:28.089477192: Warning A shell was spawned in a container with an attached terminal (user=root user_loginuid=-1 apache (id=661ff0e4c71f) shell=sh parent=runc cmdline=sh terminal=34816 container_id=661ff0e4c71f image=docker.io/library/httpd)
```

```sh
modified the output

---
  output: >
    %evt.time,%user.name,%container.name,%container.id
---     
#reload falco setting
root@cks-worker:~# falco

#logint to the container
root@cks-master:~# k exec -it apache -- sh
#
#show the modified setting
root@cks-worker:~# falco
06:45:28.072506333: Warning 06:45:28.072506333,root,apache,661ff0e4c71f
```

https://falco.org/docs/rules/supported-fields/

##### 137. Recap 



>Syscall talk by Liz Rice
>https://www.youtube.com/watch?v=8g-NUUmCeGI



> Intro: Falco - Loris Degioanni, Sysdig
>
> https://www.youtube.com/watch?v=zgRFN3o7nJE&ab_channel=CNCF%5BCloudNativeComputingFoundation%5D

- System Calls(syscalls)
- Pods / Containers / Processes
- strace /proc
- Falco

#### Section 25 Runtime Security - Immutability of containers at runtime
##### 138. Intro

- Immutability
  - Container won't be modified during its lifetime

![](./images/Section25/Screenshot_1.png)

![](./images/Section25/Screenshot_2.png)



##### 139. Ways to enforce immutability

![](./images/Section25/Screenshot_3.png)

![](./images/Section25/Screenshot_4.png)

![](./images/Section25/Screenshot_5.png)



- Enforce Read-Only Root Filesystem
  - Enforce Read-Only root filesystem using *SecurityContexts* and *PodSecurityPolicies*
- Move logic to InitContainer?

![](./images/Section25/Screenshot_6.png)

##### 140. Practice -StartupRobe changes container

> StartupProbe for Immutability
>
> Use StartupProbe to remove *touch* and *bash* from container

```sh
root@cks-master:~# k run immutable --image=httpd -oyaml --dry-run=client > pod.yaml
root@cks-master:~# k -f pod.yaml create
pod/immutable created
root@cks-master:~# k exec -it immutable -- bash
root@immutable:/usr/local/apache2# touch test
root@immutable:/usr/local/apache2# ls test
test
root@immutable:/usr/local/apache2# exit
exit

vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: immutable
  name: immutable
spec:
  containers:
  - image: httpd
    name: immutable
    resources: {}
    startupProbe:
      exec:
        command:
        - rm
        - /bin/touch
      initialDelaySeconds: 1
      periodSeconds: 5
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "immutable" force deleted
root@cks-master:~# k -f pod.yaml create
pod/immutable created
#the command touch has been removed
root@cks-master:~# k exec -it immutable -- bash
root@immutable:/usr/local/apache2# touch test
bash: touch: command not found

```



```sh
# delete the bash command
vim pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: immutable
  name: immutable
spec:
  containers:
  - image: httpd
    name: immutable
    resources: {}
    startupProbe:
      exec:
        command:
        - rm
        - /bin/bash
      initialDelaySeconds: 1
      periodSeconds: 5
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
----
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "immutable" force deleted
root@cks-master:~# k -f pod.yaml create
pod/immutable created
root@cks-master:~# k exec -it immutable -- bash
root@immutable:/usr/local/apache2# exit
exit
root@cks-master:~# k exec -it immutable -- bash
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "e9322348268c2eababaf752b727c99abe03192360160c4aae32859fe10a99f58": OCI runtime exec failed: exec failed: container_linux.go:380: starting container process caused: exec: "bash": executable file not found in $PATH: unknown

```

##### 141. Practice - SecurityContext renders container immutable

> Enforce RO-filesystem
>
> Create Pod SecurityContext to make filesystem Read-Only
>
> Ensure some directories are still writeable using emptyDir volume

```sh
root@cks-master:~# cat pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: immutable
  name: immutable
spec:
  containers:
  - image: httpd
    name: immutable
    resources: {}
    securityContext:
      readOnlyRootFilesystem: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml create
pod/immutable created


root@cks-master:~# k exec -it immutable -- bash
error: unable to upgrade connection: container not found ("immutable")

#can't create the pod because the following reason
root@cks-master:~# k logs immutable
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.44.0.3. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.44.0.3. Set the 'ServerName' directive globally to suppress this message
[Sat Oct 09 07:21:47.003527 2021] [core:error] [pid 1:tid 140292100805760] (30)Read-only file system: AH00099: could not create /usr/local/apache2/logs/httpd.pid.TlHmu5
[Sat Oct 09 07:21:47.003695 2021] [core:error] [pid 1:tid 140292100805760] AH00100: httpd: could not log pid to file /usr/local/apache2/logs/httpd.pid

root@cks-master:~# k get pod
NAME        READY   STATUS             RESTARTS   AGE
apache      1/1     Running            1          5h33m
immutable   0/1     CrashLoopBackOff   6          9m38s
#add empty dir
vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: immutable
  name: immutable
spec:
  containers:
  - image: httpd
    name: immutable
    resources: {}
    securityContext:
      readOnlyRootFilesystem: true
    volumeMounts:
    - mountPath: /usr/local/apache2/logs
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "immutable" force deleted
root@cks-master:~# k -f pod.yaml create
pod/immutable created

root@cks-master:~# k get pod
NAME        READY   STATUS    RESTARTS   AGE
apache      1/1     Running   1          5h36m
immutable   1/1     Running   0          20s

# can't create files
root@immutable:/usr/local/apache2# touch test
touch: cannot touch 'test': Read-only file system

```

> Container

```sh
docker run --read-only --tmpfs /run my-container
```

##### 142.Recap

- RBAC
  - With RBAC it should be ensured that only certain people can even edit pod specs

> Immutability
>
> Container Image Level
>
> Pod Level via Security Context
>
> RBAC

#### Section 26 Runtime Security - Auditing
##### 143.Intro

- Audit Logs - Introduction
  - ![](./images/Section26/Screenshot_1.png)
  - ![](./images/Section26/Screenshot_2.png)

![](./images/Section26/Screenshot_3.png)

![](./images/Section26/Screenshot_4.png)

![](./images/Section26/Screenshot_5.png)

![](./images/Section26/Screenshot_6.png)



![](./images/Section26/Screenshot_7.png)

![](./images/Section26/Screenshot_8.png)

![](./images/Section26/Screenshot_9.png)

##### 144. Practice - Enable Audit Logging in Apiserver

> Steup Audit Logs
>
> **Configure apiserver to store Audit Logs in JSON format

https://github.com/killer-sh/cks-course-environment/tree/master/course-content/runtime-security/auditing

```sh
root@cks-master:/etc/kubernetes/audit# vim policy.yaml
---
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
---
# added only
root@cks-master:/etc/kubernetes/audit# vim /etc/kubernetes/manifests/kube-apiserver.yaml
---
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/runtime-security/auditing/kube-apiserver_enable_auditing.yaml
---
#check the logs
root@cks-master:/etc/kubernetes/audit/logs# cd logs/
root@cks-master:/etc/kubernetes/audit/logs# tail -100f audit.log

```

##### 145. Practice - Create Secret and check Audit Logs

> Setup Audit Logs
>
> Create a secret and investigate the JSON audit log

```sh
# create secret
root@cks-master:/etc/kubernetes/audit/logs# k create secret generic very-secure --from-literal=user=admin
secret/very-secure created
#check the audit
root@cks-master:/etc/kubernetes/audit/logs# cat audit.log | grep very-secure
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"c01e3785-1209-4fb5-8358-0c0ea437af2c","stage":"ResponseComplete","requestURI":"/api/v1/namespaces/default/secrets?fieldManager=kubectl-create","verb":"create","user":{"username":"kubernetes-admin","groups":["system:masters","system:authenticated"]},"sourceIPs":["10.146.0.2"],"userAgent":"kubectl/v1.21.0 (linux/amd64) kubernetes/cb303e6","objectRef":{"resource":"secrets","namespace":"default","name":"very-secure","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":201},"requestReceivedTimestamp":"2021-10-10T08:41:23.779397Z","stageTimestamp":"2021-10-10T08:41:23.788688Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}


# add password to secret
root@cks-master:/etc/kubernetes/audit/logs# k edit secret very-secure
secret/very-secure edited

#check the audit.log
#it changed
root@cks-master:/etc/kubernetes/audit/logs# cat audit.log | grep very-secure
...
,"requestReceivedTimestamp":"2021-10-10T08:47:12.723215Z","stageTimestamp":"2021-10-10T08:47:12.723215Z"}
{"kind":"Event","apiVersion":"audit.k8s.io/v1","level":"Metadata","auditID":"b0877684-ec88-46c5-bb58-88ca1b7a73fe","stage":"ResponseComplete","requestURI":"/api/v1/namespaces/default/secrets/very-secure?fieldManager=kubectl-edit","verb":"patch","user":{"username":"kubernetes-admin","groups":["system:masters","system:authenticated"]},"sourceIPs":["10.146.0.2"],"userAgent":"kubectl/v1.21.0 (linux/amd64) kubernetes/cb303e6","objectRef":{"resource":"secrets","namespace":"default","name":"very-secure","apiVersion":"v1"},"responseStatus":{"metadata":{},"code":200},"requestReceivedTimestamp":"2021-10-10T08:47:12.723215Z","stageTimestamp":"2021-10-10T08:47:12.727916Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":""}}


```

##### 146. Practice - Create Secret and check Audit Logs

> Restrict amount of Audit Logs to collect
>
> **restrict logged data with an Audit Policy**
>
> - Nothing from stage RequestReceived
> - Nothing from "get","watch","list"
> - From Secrets only metadata level
> - Everything else RequestResponse level

1. Change policy file
2. Disable audit logging in apiserver,wait till restart
3. Enable audit logging in apiserver, wait will restart
   1. if apiserver doesn't start,then check:
      1. /var/log/pods/kube-system_kube-apiserver*
4. Test your changes

https://kubernetes.io/docs/tasks/debug-application-cluster/audit/

```sh
root@cks-master:/etc/kubernetes/audit# vim policy.yaml
---
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
- level: None
  verbs: ["get","watch","list"]

- level: Metadata
    resources:
    - group: "" # core API group
      resources: ["secrets"]

- level: RequestResponse
---
```

##### 147. Practice - Investigate API access history

> Use Audit Logs to investigate access history of a secret
>
> 1. Change policy file to include Request+Response from secrets
> 2. Create a new ServiceAccount(+ Secret),confirm Request + Response are available
> 3. Create a Pod that uses the Service Account

```sh
root@cks-master:/etc/kubernetes/audit# k create sa very-crazy-sa

vim /etc/kubernetes/audit/policy.yaml
---
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
- level: None
  verbs: ["get","watch","list"]

- level: RequestResponse
    resources:
    - group: "" # core API group
      resources: ["secrets"]

- level: RequestResponse
---
serviceaccount/very-crazy-sa created
root@cks-master:/etc/kubernetes/audit# k create sa very-crazy-sa
serviceaccount/very-crazy-sa created
root@cks-master:/etc/kubernetes/audit# cat logs/audit.log | grep very-crazy
...
:{"name":"very-crazy-sa","namespace":"default","uid":"acb33f06-508b-4f8c-8028-5724828421e8","resourceVersion":"44801","creationTimestamp":"2021-10-10T10:44:47Z"},"secrets":[{"name":"very-crazy-sa-token-gsrp2"}]},"requestReceivedTimestamp":"2021-10-10T10:44:47.554272Z","stageTimestamp":"2021-10-10T10:44:47.556611Z","annotations":{"authorization.k8s.io/decision":"allow","authorization.k8s.io/reason":"RBAC: allowed by ClusterRoleBinding \"system:kube-controller-manager\" of ClusterRole \"system:kube-controller-manager\" to User \"system:kube-controller-manager\""}}

# create the pod
root@cks-master:/etc/kubernetes/audit# k run accessor --image=nginx --dry-run=client -oyaml > pod.yaml
root@cks-master:/etc/kubernetes/audit# vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: accessor
  name: accessor
spec:
  serviceAccountName: very-crazy-sa
  containers:
  - image: nginx
    name: accessor
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:/etc/kubernetes/audit# k -f pod.yaml create
pod/accessor created

```

Auditing in Kubernetes 101 - Nikhita Raghunath, Loodse

https://www.youtube.com/watch?v=HXtLTxo30SY&ab_channel=CNCF%5BCloudNativeComputingFoundation%5D

##### 148.Recap

> What are Audit Logs
>
> How to enable them(Apiserver)
>
> How to filter these(Audit Policy)
>
> How to investigate logs

```sh
sudo -i
apt-get install apparmor-utils

```



#### Section 27 System Hardening - Kernel Hardening Tools
##### 150.Intro

![](./images/Section27/Screenshot_1.png)

![](./images/Section27/Screenshot_2.png)



![](./images/Section27/Screenshot_3.png)

##### 151. AppArmor

![](./images/Section27/Screenshot_4.png)

![](./images/Section27/Screenshot_5.png)

![](./images/Section27/Screenshot_6.png)

##### 152 Practice -AppArmor for curl

> AppArmor
>
> Setup simple AppArmor profile for curl



```sh
root@cks-worker:~# curl killer.sh -v
* Rebuilt URL to: killer.sh/
*   Trying 35.227.196.29...
* TCP_NODELAY set
* Connected to killer.sh (35.227.196.29) port 80 (#0)
> GET / HTTP/1.1
> Host: killer.sh
> User-Agent: curl/7.58.0
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Cache-Control: private
< Content-Type: text/html; charset=UTF-8
< Referrer-Policy: no-referrer
< Location: https://killer.sh/
< Content-Length: 215
< Date: Mon, 11 Oct 2021 13:37:19 GMT
<
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://killer.sh/">here</A>.
</BODY></HTML>
* Connection #0 to host killer.sh left intact


root@cks-worker:~# aa-status
apparmor module is loaded.
30 profiles are loaded.
24 profiles are in enforce mode.
   /sbin/dhclient
   /snap/snapd/12883/usr/lib/snapd/snap-confine
   /snap/snapd/12883/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /snap/snapd/13170/usr/lib/snapd/snap-confine
   /snap/snapd/13170/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/curl
   /usr/bin/lxc-start
   /usr/bin/man
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/sbin/chronyd
   /usr/sbin/tcpdump
   cri-containerd.apparmor.d
   docker-default
   lxc-container-default
   lxc-container-default-cgns
   lxc-container-default-with-mounting
   lxc-container-default-with-nesting
   man_filter
   man_groff
   snap-update-ns.google-cloud-sdk
6 profiles are in complain mode.
   snap.google-cloud-sdk.anthoscli
   snap.google-cloud-sdk.bq
   snap.google-cloud-sdk.docker-credential-gcloud
   snap.google-cloud-sdk.gcloud
   snap.google-cloud-sdk.gsutil
   snap.google-cloud-sdk.kubectl
12 processes have profiles defined.
12 processes are in enforce mode.
   /usr/sbin/chronyd (1061)
   cri-containerd.apparmor.d (5237)
   cri-containerd.apparmor.d (5284)
   cri-containerd.apparmor.d (5285)
   cri-containerd.apparmor.d (5491)
   cri-containerd.apparmor.d (5530)
   cri-containerd.apparmor.d (5531)
   cri-containerd.apparmor.d (5534)
   cri-containerd.apparmor.d (5831)
   cri-containerd.apparmor.d (5858)
   cri-containerd.apparmor.d (5859)
   cri-containerd.apparmor.d (5860)
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.

root@cks-worker:~# apt-get install apparmor-utils
Reading package lists... Done
Building dependency tree
Reading state information... Done
apparmor-utils is already the newest version (2.12-4ubuntu5.1).
0 upgraded, 0 newly installed, 0 to remove and 29 not upgraded.



root@cks-worker:~# aa-
aa-audit           aa-decode          aa-exec            aa-remove-unknown
aa-autodep         aa-disable         aa-genprof         aa-status
aa-cleanprof       aa-enabled         aa-logprof         aa-unconfined
aa-complain        aa-enforce         aa-mergeprof       aa-update-browser
```

```sh
# select the F key
root@cks-worker:~# aa-genprof curl

Before you begin, you may wish to check if a
profile already exists for the application you
wish to confine. See the following wiki page for
more information:
http://wiki.apparmor.net/index.php/Profiles

Profiling: /usr/bin/curl

Please start the application to be profiled in
another window and exercise its functionality now.

Once completed, select the "Scan" option below in
order to scan the system logs for AppArmor events.

For each AppArmor event, you will be given the
opportunity to choose whether the access should be
allowed or denied.

[(S)can system log for AppArmor events] / (F)inish

Profiling: /usr/bin/curl

Please start the application to be profiled in
another window and exercise its functionality now.

Once completed, select the "Scan" option below in
order to scan the system logs for AppArmor events.

For each AppArmor event, you will be given the
opportunity to choose whether the access should be
allowed or denied.

[(S)can system log for AppArmor events] / (F)inish

Profiling: /usr/bin/curl

Please start the application to be profiled in
another window and exercise its functionality now.

Once completed, select the "Scan" option below in
order to scan the system logs for AppArmor events.

For each AppArmor event, you will be given the
opportunity to choose whether the access should be
allowed or denied.

[(S)can system log for AppArmor events] / (F)inish

Reloaded AppArmor profiles in enforce mode.

Please consider contributing your new profile!
See the following wiki page for more information:
http://wiki.apparmor.net/index.php/Profiles

Finished generating profile for /usr/bin/curl.

root@cks-worker:~# curl killer.sh -v
* Rebuilt URL to: killer.sh/
*   Trying 35.227.196.29...
* TCP_NODELAY set
* Connected to killer.sh (35.227.196.29) port 80 (#0)
> GET / HTTP/1.1
> Host: killer.sh
> User-Agent: curl/7.58.0
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
< Cache-Control: private
< Content-Type: text/html; charset=UTF-8
< Referrer-Policy: no-referrer
< Location: https://killer.sh/
< Content-Length: 215
< Date: Mon, 11 Oct 2021 13:42:35 GMT
<
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://killer.sh/">here</A>.
</BODY></HTML>
* Connection #0 to host killer.sh left intact


#check the profile
root@cks-worker:~# aa-status
apparmor module is loaded.
30 profiles are loaded.
24 profiles are in enforce mode.
   /sbin/dhclient
   /snap/snapd/12883/usr/lib/snapd/snap-confine
   /snap/snapd/12883/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /snap/snapd/13170/usr/lib/snapd/snap-confine
   /snap/snapd/13170/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/curl
   /usr/bin/lxc-start
   /usr/bin/man
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/sbin/chronyd
   /usr/sbin/tcpdump
   cri-containerd.apparmor.d
   docker-default
   lxc-container-default
   lxc-container-default-cgns
   lxc-container-default-with-mounting
   lxc-container-default-with-nesting
   man_filter
   man_groff
   snap-update-ns.google-cloud-sdk
6 profiles are in complain mode.
   snap.google-cloud-sdk.anthoscli
   snap.google-cloud-sdk.bq
   snap.google-cloud-sdk.docker-credential-gcloud
   snap.google-cloud-sdk.gcloud
   snap.google-cloud-sdk.gsutil
   snap.google-cloud-sdk.kubectl
12 processes have profiles defined.
12 processes are in enforce mode.
   /usr/sbin/chronyd (1061)
   cri-containerd.apparmor.d (5237)
   cri-containerd.apparmor.d (5284)
   cri-containerd.apparmor.d (5285)
   cri-containerd.apparmor.d (5491)
   cri-containerd.apparmor.d (5530)
   cri-containerd.apparmor.d (5531)
   cri-containerd.apparmor.d (5534)
   cri-containerd.apparmor.d (5831)
   cri-containerd.apparmor.d (5858)
   cri-containerd.apparmor.d (5859)
   cri-containerd.apparmor.d (5860)
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.
```

```sh

root@cks-worker:~# cd /etc/apparmor.d
root@cks-worker:/etc/apparmor.d# l
abstractions/    lxc-containers     usr.lib.snapd.snap-confine.real
cache/           sbin.dhclient      usr.sbin.chronyd
disable/         tunables/          usr.sbin.rsyslogd
force-complain/  usr.bin.curl       usr.sbin.tcpdump
local/           usr.bin.lxc-start
lxc/             usr.bin.man
root@cks-worker:/etc/apparmor.d# vim usr.bin.curl

#change the usr.bin.curl

```



##### 153. Practice - AppArmor for Docker Nginx

> AppArmor & Docker 
>
> **Nginx Docker container users AppArmor profile**



apparmor profile
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/system-hardening/kernel-hardening-tools/apparmor/profile-docker-nginx

```sh
copy the above url to docker-nginx
root@cks-worker:/etc/apparmor.d# vim docker-nginx

```

k8s docs apparmor
https://kubernetes.io/docs/tutorials/clusters/apparmor/#example

```sh
root@cks-worker:/etc/apparmor.d# apparmor_parser /etc/apparmor.d/docker-nginx
root@cks-worker:/etc/apparmor.d# aa-status
apparmor module is loaded.
31 profiles are loaded.
25 profiles are in enforce mode.
   /sbin/dhclient
   /snap/snapd/12883/usr/lib/snapd/snap-confine
   /snap/snapd/12883/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /snap/snapd/13170/usr/lib/snapd/snap-confine
   /snap/snapd/13170/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/curl
   /usr/bin/lxc-start
   /usr/bin/man
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/sbin/chronyd
   /usr/sbin/tcpdump
   cri-containerd.apparmor.d
   docker-default
   docker-nginx
   lxc-container-default
   lxc-container-default-cgns
   lxc-container-default-with-mounting
   lxc-container-default-with-nesting
   man_filter
   man_groff
   snap-update-ns.google-cloud-sdk
6 profiles are in complain mode.
   snap.google-cloud-sdk.anthoscli
   snap.google-cloud-sdk.bq
   snap.google-cloud-sdk.docker-credential-gcloud
   snap.google-cloud-sdk.gcloud
   snap.google-cloud-sdk.gsutil
   snap.google-cloud-sdk.kubectl
12 processes have profiles defined.
12 processes are in enforce mode.
   /usr/sbin/chronyd (1102)
   cri-containerd.apparmor.d (4963)
   cri-containerd.apparmor.d (5009)
   cri-containerd.apparmor.d (5010)
   cri-containerd.apparmor.d (5107)
   cri-containerd.apparmor.d (5132)
   cri-containerd.apparmor.d (5133)
   cri-containerd.apparmor.d (5134)
   cri-containerd.apparmor.d (5271)
   cri-containerd.apparmor.d (5297)
   cri-containerd.apparmor.d (5298)
   cri-containerd.apparmor.d (5299)
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.

```

```sh
root@cks-worker:/etc/apparmor.d# docker run nginx
root@cks-worker:/etc/apparmor.d# docker run --security-opt apparmor=docker-default nginx
root@cks-worker:/etc/apparmor.d# docker run --security-opt apparmor=docker-nginx nginx
/docker-entrypoint.sh: 13: /docker-entrypoint.sh: cannot create /dev/null: Permission denied

#Because the docker-nginx profile,it can't create the file in docker-nginx
root@cks-worker:/etc/apparmor.d# docker run --security-opt apparmor=docker-nginx -d nginx
0b430f493661cfd4b79a73b500c16a0a86bd7e37614076169b74912c1154cff9

root@cks-worker:/etc/apparmor.d# docker exec -it 0b430f493661cfd4b79a73b500c16a0a86bd7e37614076169b74912c1154cff9 sh
# ls
bin   dev                  docker-entrypoint.sh  home  lib64  mnt  proc  run   srv  tmp  var
boot  docker-entrypoint.d  etc                   lib   media  opt  root  sbin  sys  usr
# touch /root/test
touch: cannot touch '/root/test': Permission denied
# touch /test
# sh
sh: 7: sh: Permission denied
```

```sh
root@cks-worker:/etc/apparmor.d# docker exec -it 57862b0c4a259368fa7b52154fedf1a25621d9b2a9f837c098a929d0c30bebf6 sh
# touch /root/test
# ls /root/test
/root/test
```



##### 154. Practice -AppArmor for Kubernetes Nginx

> - Container runtime needs to support AppArmor
> - AppArmor needs to be installed on every node
> - AppArmor profiles need to be available on every node
> - AppArmor profiles are **specified per container** 
>   - done using annotations

![](./images/Section27/Screenshot_7.png)

```sh

root@cks-master:~# k run secure --image=nginx -oyaml --dry-run=client > pod.yamlroot@cks-master:~# vim pod.yaml
root@cks-master:~# vim pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secure
  name: secure
  annotations:
    container.apparmor.security.beta.kubernetes.io/secure: localhost/hello
spec:
  containers:
  - image: nginx
    name: secure
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---

root@cks-master:~# k -f pod.yaml create
pod/secure created
---

#recrate pod
root@cks-master:~# k get pod secure
NAME     READY   STATUS    RESTARTS   AGE
secure   0/1     Blocked   0          31s
root@cks-master:~# k describe pod secure | grep Reason
Reason:       AppArmor
      Reason:       Blocked
  Type    Reason     Age   From               Message
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secure
  name: secure
  annotations:
    container.apparmor.security.beta.kubernetes.io/secure: localhost/docker-ngin
x
spec:
  containers:
  - image: nginx
    name: secure
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k get pod secure
NAME     READY   STATUS    RESTARTS   AGE
secure   1/1     Running   0          13s

root@cks-master:~# k exec -it secure -- bash
root@secure:/# sh
bash: /bin/sh: Permission denied
root@secure:/# touch test
root@secure:/# ls
bin   docker-entrypoint.d   home   media  proc  sbin  test  var
boot  docker-entrypoint.sh  lib    mnt    root  srv   tmp
dev   etc                   lib64  opt    run   sys   usr
root@secure:/# touch /root/test
touch: cannot touch '/root/test': Permission denied
root@secure:/# ls
bin   docker-entrypoint.d   home   media  proc  sbin  test  var
boot  docker-entrypoint.sh  lib    mnt    root  srv   tmp
dev   etc                   lib64  opt    run   sys   usr

```

##### 155. Seccomp

> "secure computing mode" 
>
> Security facility in the Linux Kernel
>
> Restricts execution of syscalls

![](./images/Section27/Screenshot_8.png)

##### 

![](./images/Section27/Screenshot_9.png)



![](./images/Section27/Screenshot_10.png)





![](./images/Section27/Screenshot_11.png)





##### 156 Practice - Seccomp for Docker Nginx

```sh
#copy the below
#https://github.com/killer-sh/cks-course-environment/blob/master/course-content/system-hardening/kernel-hardening-tools/seccomp/profile-docker-nginx.json
# remove "write"
# vim default.json

root@cks-worker:~# docker run --security-opt seccomp=default.json nginx
docker: Error response from daemon: OCI runtime start failed: cannot start an already running container: unknown.
ERRO[0000] error waiting for container: context canceled

```

##### 157.Practice seccomp for Kubernetes Nginx

> **Create a Nginx Pod in Kubernetes and assign a seccomp profile to it**

https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/#:~:text=--seccomp-profile-root%20string%C2%A0%C2%A0%C2%A0%C2%A0%C2%A0Default%3A%20/var/lib/kubelet/seccomp

```sh
root@cks-worker:~# mkdir /var/lib/kubelet/seccomp
root@cks-worker:~# mv default.json /var/lib/kubelet/seccomp/

root@cks-master:~# vim pod.yaml

---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secure
  name: secure
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: profiles/audit.json
  containers:
  - image: nginx
    name: secure
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
admission_127_ImagePolicyWebhook  pod.yaml  policy.yaml
root@cks-master:~# vim pod.yaml
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "secure" force deleted
root@cks-master:~# k -f pod.yaml create
pod/secure created
root@cks-master:~# k get pod
NAME     READY   STATUS                 RESTARTS   AGE
secure   0/1     CreateContainerError   0          82s

root@cks-master:~# k describe pod secure
Warning  Failed     14s (x7 over 93s)  kubelet            Error: failed to create containerd container: cannot load seccomp profile "/var/lib/kubelet/seccomp/profiles/audit.json": open /var/lib/kubelet/seccomp/profiles/audit.json: no such file or directory

vim pod.yaml 
---

root@cks-master:~# cat pod.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: secure
  name: secure
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: default.json
  containers:
  - image: nginx
    name: secure
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
---
root@cks-master:~# k get pod
NAME     READY   STATUS              RESTARTS   AGE
secure   0/1     RunContainerError   0          4s
root@cks-master:~# k describe pod secure
  Warning  Failed     5s (x3 over 26s)  kubelet            Error: failed to start containerd task "secure": OCI runtime start failed: cannot start an already running container: unknown

```

https://kubernetes.io/docs/tutorials/clusters/seccomp/#create-a-pod-with-a-seccomp-profile-for-syscall-auditing



```sh
# add write
root@cks-worker:~# vim  /var/lib/kubelet/seccomp/default.json
---
        "write",
---
# create pod again
root@cks-master:~# k -f pod.yaml delete --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "secure" force deleted
root@cks-master:~# k -f pod.yaml create
pod/secure created
root@cks-master:~# k get pod
NAME     READY   STATUS              RESTARTS   AGE
secure   0/1     ContainerCreating   0          3s
root@cks-master:~# k get pod
NAME     READY   STATUS    RESTARTS   AGE
secure   1/1     Running   0          6s

```



##### 158Recap

 syscalls
https://www.youtube.com/watch?v=8g-NUUmCeGI

 AppArmor, SELinux Introduction 
https://www.youtube.com/watch?v=JFjXvIwAeVI



> - Syscalls
> - AppArmor
> - Seccomp
> - Docker & K8s



#### Section 28 System Hardening - Reduce Attack Surface
##### 158.Intro

![](./images/Section28/Screenshot_1.png)



![](./images/Section28/Screenshot_2.png)

![](./images/Section28/Screenshot_3.png)

![](./images/Section28/Screenshot_4.png)

##### 159. Practice - Systemctl and Services

> Disable Service Snap
>
> **Disable Service Snapd via systemctl**

```sh
root@cks-master:~# systemctl stop snapd
Warning: Stopping snapd.service, but it can still be activated by:
  snapd.socket
root@cks-master:~# systemctl list-units --type=service --state=running | grep snapd

root@cks-master:~# systemctl list-units --type=service --state=running | grep snapd
snapd.service                 loaded active running Snap Daemon

```

##### 161. Practice - Install and investigate Services

```sh

root@cks-master:~# apt-get update
root@cks-master:~# apt-get install vsftpd samba

root@cks-master:~# systemctl status vsftpd
● vsftpd.service - vsftpd FTP server
   Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2021-10-14 02:46:52 UTC; 1min 8s ago
 Main PID: 26788 (vsftpd)
    Tasks: 1 (limit: 4666)
   CGroup: /system.slice/vsftpd.service
           └─26788 /usr/sbin/vsftpd /etc/vsftpd.conf

Oct 14 02:46:52 cks-master systemd[1]: Starting vsftpd FTP server...
Oct 14 02:46:52 cks-master systemd[1]: Started vsftpd FTP server.

root@cks-master:~# systemctl status smbd
● smbd.service - Samba SMB Daemon
   Loaded: loaded (/lib/systemd/system/smbd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2021-10-14 02:46:57 UTC; 1min 31s ago
     Docs: man:smbd(8)
           man:samba(7)
           man:smb.conf(5)
 Main PID: 27112 (smbd)
   Status: "smbd: ready to serve connections..."
    Tasks: 4 (limit: 4666)
   CGroup: /system.slice/smbd.service
           ├─27112 /usr/sbin/smbd --foreground --no-process-group
           ├─27131 /usr/sbin/smbd --foreground --no-process-group
           ├─27132 /usr/sbin/smbd --foreground --no-process-group
           └─27141 /usr/sbin/smbd --foreground --no-process-group

Oct 14 02:46:57 cks-master systemd[1]: Starting Samba SMB Daemon...
Oct 14 02:46:57 cks-master systemd[1]: Started Samba SMB Daemon.

root@cks-master:~# ps aux | grep vsftpd
root     26788  0.0  0.0  29152  2984 ?        Ss   02:46   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf
root     28887  0.0  0.0  14860  1016 pts/0    S+   02:49   0:00 grep --color=auto vsftpd
root@cks-master:~# ps aux | grep smbd
root     27112  0.0  0.5 357576 20860 ?        Ss   02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27131  0.0  0.1 345524  6080 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27132  0.0  0.1 345516  4736 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27141  0.0  0.1 357576  5664 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     29082  0.0  0.0  14860  1044 pts/0    S+   02:49   0:00 grep --color=auto smbd

```

```sh
root@cks-master:~# ps aux | grep vsftpd
root     26788  0.0  0.0  29152  2984 ?        Ss   02:46   0:00 /usr/sbin/vsftpd /etc/vsftpd.conf
root     28887  0.0  0.0  14860  1016 pts/0    S+   02:49   0:00 grep --color=auto vsftpd
root@cks-master:~# ps aux | grep smbd
root     27112  0.0  0.5 357576 20860 ?        Ss   02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27131  0.0  0.1 345524  6080 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27132  0.0  0.1 345516  4736 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     27141  0.0  0.1 357576  5664 ?        S    02:46   0:00 /usr/sbin/smbd --foreground --no-process-group
root     29082  0.0  0.0  14860  1044 pts/0    S+   02:49   0:00 grep --color=auto smbd
#find smbd and vsftpd
root@cks-master:~# netstat -plnt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:10257         0.0.0.0:*               LISTEN      3417/kube-controlle
tcp        0      0 127.0.0.1:10259         0.0.0.0:*               LISTEN      3638/kube-scheduler
tcp        0      0 127.0.0.1:32917         0.0.0.0:*               LISTEN      1030/kubelet
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      842/systemd-resolve
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1718/sshd
tcp        0      0 0.0.0.0:445             0.0.0.0:*               LISTEN      27112/smbd
tcp        0      0 127.0.0.1:6784          0.0.0.0:*               LISTEN      5303/weaver
tcp        0      0 127.0.0.1:45063         0.0.0.0:*               LISTEN      1156/containerd
tcp        0      0 127.0.0.1:10248         0.0.0.0:*               LISTEN      1030/kubelet
tcp        0      0 127.0.0.1:10249         0.0.0.0:*               LISTEN      4570/kube-proxy
tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN      27112/smbd
tcp        0      0 127.0.0.1:2379          0.0.0.0:*               LISTEN      3949/etcd
tcp        0      0 10.146.0.2:2379         0.0.0.0:*               LISTEN      3949/etcd
tcp        0      0 10.146.0.2:2380         0.0.0.0:*               LISTEN      3949/etcd
tcp        0      0 127.0.0.1:2381          0.0.0.0:*               LISTEN      3949/etcd
tcp6       0      0 :::10256                :::*                    LISTEN      4570/kube-proxy
tcp6       0      0 :::21                   :::*                    LISTEN      26788/vsftpd
tcp6       0      0 :::22                   :::*                    LISTEN      1718/sshd
tcp6       0      0 :::6781                 :::*                    LISTEN      5214/weave-npc
tcp6       0      0 :::445                  :::*                    LISTEN      27112/smbd
tcp6       0      0 :::6782                 :::*                    LISTEN      5303/weaver
tcp6       0      0 :::6783                 :::*                    LISTEN      5303/weaver
tcp6       0      0 :::10250                :::*                    LISTEN      1030/kubelet
tcp6       0      0 :::6443                 :::*                    LISTEN      4181/kube-apiserver
tcp6       0      0 :::139                  :::*                    LISTEN      27112/smbd

# add interfaces

root@cks-master:~# vim /etc/samba/smb.conf

---
interfaces = 127.0.0.0/8 eth0
bind interfaces only = yes
---
root@cks-master:~# netstat -plnt | grep smbd
tcp        0      0 127.0.0.1:445           0.0.0.0:*               LISTEN      32673/smbd
tcp        0      0 127.0.0.1:139           0.0.0.0:*               LISTEN      32673/smbd

```



##### 162. Practice - Disable application listening on port

Remove FTP server

> Find and disable the application that is listening on port 21

```sh
root@cks-master:~# netstat -plnt | grep 21
tcp6       0      0 :::21                   :::*                    LISTEN      1532/vsftpd
tcp6       0      0 :::6781                 :::*                    LISTEN      5021/weave-npc

root@cks-master:~# lsof -i :21
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
vsftpd  1532 root    3u  IPv6  22327      0t0  TCP *:ftp (LISTEN)

root@cks-master:~# systemctl list-units --type service | grep ftp
  vsftpd.service                                 loaded active running vsftpd FTP server                 
root@cks-master:~# systemctl status vsftpd
● vsftpd.service - vsftpd FTP server
   Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2021-10-14 04:06:08 UTC; 3min 6s ago
  Process: 1261 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCESS)
 Main PID: 1532 (vsftpd)
    Tasks: 1 (limit: 4666)
   CGroup: /system.slice/vsftpd.service
           └─1532 /usr/sbin/vsftpd /etc/vsftpd.conf

Oct 14 04:06:04 cks-master systemd[1]: Starting vsftpd FTP server...
Oct 14 04:06:08 cks-master systemd[1]: Started vsftpd FTP server.
root@cks-master:~# systemctl stop vsftpd
root@cks-master:~# netstat -plnt | grep 21
tcp6       0      0 :::6781                 :::*                    LISTEN      5021/weave-npc

```



##### 163. Practice -Investigate Linux Users

> Investigate Linux Users

```sh
root@cks-master:~# su ubuntu
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@cks-master:/root$ whoami
ubuntu

# find login users
root@cks-master:~# ps aux | grep bash
marsfor+  2741  0.0  0.1  23172  5176 pts/0    Ss   04:06   0:00 -bash
root      3660  0.0  0.3  30988 12904 pts/0    S    04:07   0:00 -bash
ubuntu    8399  0.0  0.1  23104  5012 pts/0    S    04:13   0:00 bash
root      8604  1.0  0.3  30988 12828 pts/0    S    04:13   0:00 -bash
root      8757  0.0  0.0  14860  1040 pts/0    S+   04:14   0:00 grep --color=auto bash
root@cks-master:~# exit
logout
ubuntu@cks-master:/root$ ps aux | grep bash
marsfor+  2741  0.0  0.1  23172  5176 pts/0    Ss   04:06   0:00 -bash
root      3660  0.0  0.3  30988 12904 pts/0    S    04:07   0:00 -bash
ubuntu    8399  0.0  0.1  23104  5012 pts/0    S    04:13   0:00 bash
ubuntu    9142  0.0  0.0  14860  1012 pts/0    R+   04:15   0:00 grep --color=auto bash

exit
root@cks-master:~# ps aux | grep bash
marsfor+  2741  0.0  0.1  23172  5176 pts/0    Ss   04:06   0:00 -bash
root      3660  0.0  0.3  30988 12904 pts/0    S    04:07   0:00 -bash
root      9359  0.0  0.0  14860  1056 pts/0    S+   04:15   0:00 grep --color=auto bash


```

##### 164.Recap

> - Attack Surface
> - Applications / Services
> - Network / Ports
> - Users / IAM

#### Section 29 CKS Exam Series

##### 

#### Section 30 CKS Simulator

##### 166 Intro

##### 168 Rating and feedback