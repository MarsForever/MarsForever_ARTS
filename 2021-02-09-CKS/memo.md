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

![](.\images\Section15\Screenshot_1.png)

![](.\images\Section15\Screenshot_2.png)

Introduction K8S Secretes

![](.\images\Section15\Screenshot_3.png)



##### 73. Create Simple Secret Scenario

###### Simple Secret Scenario

![](.\images\Section15\Screenshot_4.png)

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

![](.\images\Section15\Screenshot_5.png)

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

![](.\images\Section15\Screenshot_6.png)

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



![](.\images\Section15\Screenshot_7.png)

![](.\images\Section15\Screenshot_8.png)

###### Encrypt (all Secrets) in etcd

![](.\images\Section15\Screenshot_9.png)

```sh
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
```

![](.\images\Section15\Screenshot_10.png)


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

#### Section 16 Microservice Vunerabilites - Container Runtime Sandboxes
##### Intro
##### Recap
#### Section 17 Microservice Vunerabilites - OS Level Security Domains
##### Intro
##### Recap
#### Section 18 Microservice Vunerabilites - mTLS
##### Intro
##### Recap
#### Section 19 Open Policy Agent(OPA)
##### Intro
##### Recap
#### Section 20 Supply Chain Security - Image Footprint
##### Intro
##### Recap
#### Section 21 Supply Chain Security - Static Analysis
##### Intro
##### Recap
#### Section 22 Supply Chain Security - Image Vulnerability Scanning
##### Intro
##### Recap
#### Section 23 Supply Chain Security - Secure Supply Chain
##### Intro
##### Recap
#### Section 24 Runtime Security - Behavioral Analytics at host and container level
##### Intro
##### Recap
#### Section 25 Runtime Security - Immutability of containers at runtime
##### Intro
##### Recap
#### Section 26 Runtime Security - Auditing
##### Intro
##### Recap
#### Section 27 System Hardening - Kernel Hardening Tools
##### Intro
##### Recap
#### Section 28 System Hardening - Reduce Attack Surface
##### Intro
##### Recap
#### Section 29 CKS Exam Series

##### 

#### Section 30 CKS Simulator

##### 166 Intro

##### 168 Rating and feedback