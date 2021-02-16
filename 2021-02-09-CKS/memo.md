Kubernetes Security Best Practices - Ian Lewis, Google
https://www.youtube.com/watch?v=wqsUfvRyYpw





### Section 2-5 Cluster Specification 



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


#### run the printed kubeadm-join-command from the master on the worker


2-9 firewall rules for NodePorts
gcloud compute firewall-rules create nodeports --allow tcp:30000-40000

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

![Linux Kernel Namespace PID](images/Section4-15_Linux Kernel Namespace.png)



Linux Kernel Namespace Mount

![Linux Kernel Namespace Mount](images/Section4-15_Linux Kernel Namespace Mount.png)

Linux Kernel Namespace Network

![Linux Kernel Namespace Mount](images/Section4-15_Linux Kernel Namespace Network.png)

Linux Kernel Namespace User

![Linux Kernel Namespace User](images/Section4-15_Linux Kernel Namespace User.png)

##### Linux Kernel Isolation

![Linux Kernel Isolation](images\Section4-15_Linux Kernel Isolation.png)











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

![NetworkPolicies](images\Section5 Cluster Setup NetworkPolicies\Screenshot_1.png)

##### Multiple NetworkPolicies 

![Multiple NetworkPolicies](images\Section5 Cluster Setup NetworkPolicies\Screenshot_2.png)

##### Multiple NetworkPolicies  examples

![Multiple NetworkPolicies examples](images\Section5 Cluster Setup NetworkPolicies\Screenshot_3.png)

#### 21 Practice Default Deny

##### Default Deny

![Default Deny](images\Section5 Cluster Setup NetworkPolicies\Screenshot_4.png)

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

![Frontend to Backend traffic](images\Section5 Cluster Setup NetworkPolicies\Screenshot_5.png)

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

![Allow DNS resolution](images\Section5 Cluster Setup NetworkPolicies\Screenshot_6.png)

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

![Network Policy](images\Section5 Cluster Setup NetworkPolicies\Screenshot_7.png)

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

![24 Recap](images\Section5 Cluster Setup NetworkPolicies\Screenshot_8.png)



















[Kubernetes CKS Challenge Series](https://github.com/killer-sh/cks-challenge-series)

[Kubernetes CKS Course Environment](https://github.com/killer-sh/cks-course-environment)

 