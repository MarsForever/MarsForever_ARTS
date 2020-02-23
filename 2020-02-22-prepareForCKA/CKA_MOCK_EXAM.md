

## CKA with Practice Tests

### Mock Exam - 1

```yaml
No.1
Deploy a pod named nginx-pod using the nginx:alpine image.
```

```
Answer:
kubectl run nginx-pod --image=nginx:alpine --restart=Never
```

```yaml
No.2
Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.
```

```yaml
Answer:
kubectl run messaging --generator=run-pod/v1 --restart=Never --image=redis:alpine -l tier=msg


```

```yaml
No.3
Create a namespace named apx-x9984574
```

kubectl create ns  apx-x9984574

```yaml
No.4
Get the list of nodes in JSON format and store it in a file at /opt/outputs/nodes-z3444kd9.json
```

誤：

kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' > /opt/outputs/nodes-z3444kd9.json

正解：

 `kubectl get nodes -o json > /opt/outputs/nodes-z3444kd9.json`

```yaml
No.5
Create a service messaging-service to expose the messaging application within the cluster on port 6379.
Use imperative commands
```

Create a service `messaging-service` to expose the `messaging` application within the cluster on port `6379`.

```yaml
No.6
Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas
```

kubectl create deploy hr-web-app --image=kodekloud/webapp-color

kubectl scale deploy hr-web-app --replicas=2

```yaml
No.7
Create a static pod named static-busybox that uses the busybox image and the command sleep 1000
Use imperative commands
```

誤：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: static-busybox
spec:
  containers:

   - name: static-busybox
     image: busybox
     command: ["sleep"]
     args: ["1000"]
```

https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/#static-pod-creation

https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/

正解：

kubectl run --restart=Never --image=busybox static-busybox --dry-run -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml



```yaml
No.8
Create a POD in the finance namespace named temp-bus with the image redis:alpine.
```

kubectl run temp-bus -n finance --image=redis:alpine --restart=Never



```yaml
No.9
A new application orange is deployed. There is something wrong with it. Identify and fix the issue.

```

command sleep

```yaml
No.10
Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster
The web application listens on port 8080
```

誤

kubectl expose deploy hr-web-app --name=hr-web-app-service --port=33082

```
正解
kubectl expose deployment hr-web-app --type=NodePort --port=8080 --name=hr-web-app-service --dry-run -o yaml > hr-web-app-service.yaml
```

```yaml
No.11

```

kubectl get node -o=jsonpath='{.items[*].status.nodeInfo.osImage}' > /opt/outputs/nodes_os_x43kj56.txt



```yaml
No.12
Create a Persistent Volume with the given specification.
```



```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-analytics
spec:  
  capacity:    
  storage: 100Mi  
  accessModes:    
    - ReadWriteMany  
  hostPath:    # directory location on host    
  path: /pv/data-analytics
```



https://kubernetes.io/docs/concepts/storage/persistent-volumes/#types-of-persistent-volumes

https://kubernetes.io/docs/concepts/storage/volumes/



### Mock Exam - 2

```yaml
No.1
Take a backup of the etcd cluster and save it to /tmp/etcd-backup.db
```

```sh
Answer:
ETCDCTL_API=3 etcdctl version

cd /etc/kubernetes/manifests/

#### find cacert,cert,key file
cat etcd.yaml
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernets/pki/etcd/server.key member list

#save
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernets/pki/etcd/server.key snapshot save /tmp/etcd-backup.db
#verify the status
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernets/pki/etcd/server.key snapshot status /tmp/etcd-backup.db -w table

https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster
```

```yaml
No.2
Create a Pod called redis-storage with image: redis:alpine with a Volume of type emptyDir that lasts for the life of the Pod. Specs on the right.
Pod named 'redis-storage' created
Pod 'redis-storage' uses Volume type of emptyDir
Pod 'redis-storage' uses volumeMount with mountPath = /data/redis
```

```yaml
Answer:
kubectl run redis-storage --image=redis:alpine --restart=Never -o yaml --dry-run > redis-storage.yaml
kubectl apply -f redis-torage.yaml

https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/#configure-a-volume-for-a-pod


apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: redis-storage
  name: redis-storage
spec:
  containers:
  - image: redis:alpine
    name: redis-storage    
    volumeMounts:    
    - mountPath: /data/redis
      name: cache-volume  
    volumes:  
    - name: cache-volume
    emptyDir: {}

https://kubernetes.io/docs/concepts/storage/volumes/
```



```html
No.3
Create a new pod called super-user-pod with image busybox:1.28. Allow the pod to be able to set system_time

The container should sleep for 4800 seconds

Pod: super-user-pod
Container Image: busybox:1.28
SYS_TIME capabilities for the conatiner?
```

```sh
Answer:
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  name: super-user-pod
spec:
  containers:
  - image: busybox:1.28
    name: super-user-pod
    command: ["sleep","4800"]
    securityContext:
      capabilities:
        add: ["SYS_TIME"]

https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
```



```html
No.4
A pod definition file is created at /root/use-pv.yaml. Make use of this manifest file and mount the persistent volume called pv-1. Ensure the pod is running and the PV is bound.


mountPath: /data persistentVolumeClaim Name: my-pvc

persistentVolume Claim configured correctly
pod using the correct mountPath
pod using the persistent volume claim?
```

```sh
Answer:
kubectl apply -f pvc.yaml
https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims
#pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
 
#check status is "Bound"
kubectl get pv

#add volumes to use-pv.yaml
https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes

```



```yaml
No.5
Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Record the version. Next upgrade the deployment to version 1.17 using rolling update. Make sure that the version upgrade is recorded in the resource annotation.

Deployment : nginx-deploy. Image: nginx:1.16
Image: nginx:1.16
Task: Upgrade the version of the deployment to 1:17
Task: Record the changes for the image upgrade
```

```sh
Answer:
kubectl run nginx-deploy --image=nginx:1.16 --replicas=1 --record
kubectl rollout history deploy nginx-deploy
kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.17 --record
#verify
kubectl rollout history deploy nginx-deploy
kubectl describe deploy nginx-deploy | grep -i image
kubectl describe pod nginx-deploy-5bd9796fd6-z92f9 | grep image

```

```yaml
No.6
Create a new user called john. Grant him access to the cluster. John should have permission to create, list, get, update and delete pods in the development namespace . The private key exists in the location: /root/john.key and csr at /root/john.csr
CSR: john-developer Status:Approved
Role Name: developer, namespace: development, Resource: Pods
Access: User 'john' has appropriate permissions
```

```sh
#verify 
kubectl api-versions | grep certif

cat john.csr | base64 | tr -d "\n"
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQU5NWkhIajI5S09XK0Jwb2ZJQUlLNFdSM3gvUnJpWEY4WlBqMWtDM1FrdDM3S3BQCnFhYlB2ZDZud29yUlMyNTRYR20wWnIyanp0bkIzeXRzV1Fzd1N3aCszajBKcCt4T01IaGNQTllNRDhEcE9JQ1oKQ1BsaDVlWkp0OW1mejM0dEpaWmVWbENJT21HRmV4aVlEdjBocjBVL3crZVN2dk1XcVFad0hYcDFCUWFBcHV2ZAo1cVBudGluS3M4Sk44YzVHU1ZmT1RqdHpDLzVCditzdlZ1MTUwOThQU3dHWHFseVJWNk1hQ0ZmblRvMS9ubEp5CkRtOXZ1bE9yQjBJSUQ3UWo2cnJocjhVM1c4bmttMDI2QTZjbXlIOVhXa0l4MTlWNmt1YXBndWd3b2VFbVpaVUUKSzU5YnVCU1ZWQUs1akQzV3JkZkJqTUVYN0hoR0dvTndmL2JXdUhFQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQ3JxRTZmVDk3ZGc4VlluaHpwcmhxMGg5SUdVSk9MTmc2YXZ3OUEwWlB2M3lrUGZscm9SaGtXClFVNG1ZNWpuUndpOW1LTlZ0azYwekVPWGc2SjhyTUZ4N21OWFNaYkRWVk5MSkdqT1UrcVZyakVTOHVRZDVhWWgKaTZFWXJIcG5sdHFpRzRKZjdHdjViYzRHTGNrUWRKSEhTWGJrc0RCOG9ETWp4bXc5c0g2SldhNFhJR1oxbU9NWgpCYjUvVjByTXBCaHowRjhFczgwT01kS1B6aXd2VnBhbDVaVHlkT21CS2owVm5OY05sTHdibGltSmdYL1UvOHRaCmZNR296Q3VIUlNQSlUzREQ5TlFDVUNuWDQ4TitlNWsvNlhjMSsyK2V0NW1kY0lyTmdRY2dveVNIVkhDL3Q1YzYKWVhBU2xqYjl1blhjb1dSMVhyNi9LdUU2bUNTekZackYKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==

vim john.yaml
```
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: john-developer
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZEQ0NBVHdDQVFBd0R6RU5NQXNHQTFVRUF3d0VhbTlvYmpDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRApnZ0VQQURDQ0FRb0NnZ0VCQU5ac0JjOG9sZXg3eit2c1Nmd1dtNXljMytzTTJRbmZycWZQQXNqSG9BWHVhSXlSCmJBYlhFa1FkZG4veTh6M1dRN3NLcFgrL3JLd3AxaisvbkcwV2wxdnVKZGVrc3pqYXVGelI0d2xBQzhRV1F6V2gKUk1RNTRCanZxSTJNZUNqVjR3cThqdUxWWWlCTE9rc0tpWlIzVHJ5WXR0QndEb2U0NWtsUW92Ym8vTjQ4QXl6RgpHam51WXgrQklyN3JQc3V3OXZ6WDhKMG1XYXBWYUMyak81aTF4SXRDWC83V0s4N0dhQTBQQlB2TWRCOWl1WjVmCnUzWW9YRnY4OUh5ZEQzZXFCY3IwU3RxN1hia1pVZ2xJbU1UQnFreXRRdDhUVlZ0V2VBa2ZVNnpyWVJYbHc5bXIKWHpTVW8ybkt6eVBaVjBRUDNGVkRDOHRMcWtxb3A5M1duak5vNmkwQ0F3RUFBYUFBTUEwR0NTcUdTSWIzRFFFQgpDd1VBQTRJQkFRQVJobWhBSE5oUVdjUHBWYmlPdkd0TU8rc3lyRWl6YXR3d2pKd25UaVo3S3BNZGpqOGc4S1Q2CmRFUDJhbk5aT1lpdnJKRWIwdFFyZkRiWHF2bFQvMlluR09JNXZDNit1bjdXZTdVYzFCZDJBTVgvbi9WWm5CUDQKMjkvd0txR2dtcDAxZlo0MUVReFlCSUs0NDNwc1gyamx5anFZODNsNEwvb3pDNEFOWFAvUFlCWWR6TWtZajlKMApiSnpnR1BKSDdDNzBrZVcwTGxxQjVzSDBLdldQSHpMTlA0VlE2ckRqdXNOdm5wa3hOWVcwZ3h1OGVhTDlIWG5ECm5Kbkk4bms5NWhoL0xRZldDVmFIL3NPVmJ4Z25mVVRmUGovdW1naXdFVVJrN2s0UitNVDlPcGFIaXcxM2RsbEQKV0VwUXkxLzQ5QWQ0ZzhYZzhPb2NQRTdzOStqUDFCTFcKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
  usages:
  - digital signature
  - key encipherment
  - server auth
```
https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/#create-a-certificate-signing-request-object-to-send-to-the-kubernetes-api



kubectl get csr
# change condition(Approved,Issued)
kubectl certificate approve john-developer
# check condition
kubectl get csr

#Create role developer
kubectl create role developer --resource=pods --verb=create,list,get,update,delete --namespace=development
#Verify
kubectl describe role developer -n development

#Create rolebinding
kubectl create rolebinding developer-role-binding --role=developer --user=john  --namespace=development

#Verify
kubectl describe rolebinding.rbac.authorization.k8s.io developer-role-binding -n development
kubectl auth can-i update pods --namespace=development --as=john
kubectl auth can-i create pods --namespace=development --as=john
kubectl auth can-i list pods --namespace=development --as=john
kubectl auth can-i get pods --namespace=development --as=john
kubectl auth can-i delete pods --namespace=development --as=john

https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/

```


```yaml
No.7
Create an nginx pod called nginx-resolver using image nginx, expose it internally with a service called nginx-resolver-service. Test that you are able to look up the service and pod names from within the cluster. Use the image: busybox:1.28 for dns lookup. Record results in /root/nginx.svc and /root/nginx.pod


Pod: nginx-resolver created
Service DNS Resolution recorded correctly
Pod DNS resolution recorded correctly
```

```sh
Anser:
#Create pod
kubectl run nginx-resolver --image=nginx --generator=run-pod/v1
#Create service 
kubectl expose pod nginx-resolver --name=nginx-resolver-service  --port=80 --target-port=80 --type=ClusterIP
#verify svc
kubectl describe svc nginx-resolver-service
kubectl get pod nginx-resolver -o wide


kubectl create -f https://k8s.io/examples/admin/dns/busybox.yaml
kubectl exec -it busybox -- nslookup nginx-resolver-service > /root/nginx.svc

kubectl get pod nginx-resolver -o wide
kubectl exec -it busybox -- nslookup $ip(xxx-xxx-xxx-xxx).default.pod > /root/nginx.pod

```



```yaml
No.8
Create a static pod on node01 called nginx-critical with image nginx. Create this pod on node01 and make sure that it is recreated/restarted automatically in case of a failure.


Use /etc/kubernetes/manifests as the Static Pod path for example.

Kubelet Configured for Static Pods
Pod nginx-critical-node01 is Up and running
```

```sh
Answer:
#Login to node01
ssh node01
#Check configure --config's path
systemctl status kubelet
#Get the static pod's path
cd /var/lib/kubelet/
cat config.yaml | grep static

#Get the path is /etc/kubernetes/manifests
cd /etc/kubernetes/
#Create directory manifests
mkdir manifests
#Back to master
logout

kubectl run --generator=run-pod/v1 nginx-critical --image=nginx --dry-run -o yaml > 8.yaml
scp 8.yaml root@node01:/root/
#Login to node01
ssh node01
docker ps | grep -i nginx

#create static in /etc/kubernetes/manifests
mv 8.yaml /etc/kubernetes/manifests
docker ps | grep -i nginx

# back to master
logout
kubectl get pod | grep -i nginx-critical

### Mock Exam - 3

```htlm
No.1
Create a new service account with the name pvviewer. Grant this Service account access to list all PersistentVolumes in the cluster by creating an appropriate cluster role called pvviewer-role and ClusterRoleBinding called pvviewer-role-binding.
Next, create a pod called pvviewer with the image: redis and serviceAccount: pvviewer in the default namespace

ServiceAccount: pvviewer
ClusterRole: pvviewer-role
ClusterRoleBinding: pvviewer-role-binding
Pod: pvviewer
Pod configured to use ServiceAccount pvviewer ?
```

```sh

Answer:
#Create sa
kubectl create sa pvviewer
#Create clusterrole
kubectl create clusterrole  pvviewer-role --resource=persistentvolumes  --verb=list
#Create cluster role binding
kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer

#https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-token-volume-projection
```

```html
No.2
List the InternalIP of all nodes of the cluster. Save the result to a file /root/node_ips


Answer should be in the format: InternalIP of master<space>InternalIP of node1<space>InternalIP of node2<space>InternalIP of node3 (in a single line)
```

```sh
Answer:
# Get ExternalIPs of all nodes
#https://kubernetes.io/docs/reference/kubectl/cheatsheet/

#Check get internalip
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'

#copy the stuff to node_ips file
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/node_ips

#Verify the node_ips file
cat /root/node_ips
```



```html
No.3
Create a pod called multi-pod with two containers.
Container 1, name: alpha, image: nginx
Container 2: beta, image: busybox, command sleep 4800.

Environment Variables:
container 1:
name: alpha

Container 2:
name: beta


Pod Name: multi-pod
Container 1: alpha
Container 2: beta
Container beta commands set correctly?
Container 1 Environment Value Set
Container 2 Environment Value Set
```



```sh
Answer:
kubectl run --generator=run-pod/v1 alpha --image=nginx --dry-run -o yaml > multi-pod.yaml

#Edit the yaml file
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  containers:
  - image: nginx
    imagePullPolicy: IfNotPresent
    name: alpha
    env:
    - name: name
      value: alpha
  - image: busybox
    name: beta
    env:
    - name: name
      value: beta
    command: ["sleep","4800"]
    
#Verify
kubectl describe pod multi-pod
```

```html
No.4
Create a Pod called non-root-pod , image: redis:alpine
runAsUser: 1000
fsGroup: 2000
```

```sh
Answer:
kubectl run non-root-pod --generator=run-pod/v1 --image=redis:alpine --dry-run -o yaml > non-root-pod.yaml
#https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: non-root-pod
  name: non-root-pod
spec:
  containers:
  - image: redis:alpine
    imagePullPolicy: IfNotPresent
    name: non-root-pod
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
```

```html
No.5
We have deployed a new pod called np-test-1 and a service called np-test-service. Incoming connections to this service are not working. Troubleshoot and fix it.
Create NetworkPolicy, by the name ingress-to-nptest that allows incoming connections to the service over port 80
```

```sh
Answer:
kubectl run --generator=run-pod/v1 np-test-1 --image=busybox:1.28 --rm -it -- sh
nc -z -v -w 2 np-test-service 80

#Check network policy
kubectl describe netpol defautl-deny

#Create network policy
#https://kubernetes.io/docs/concepts/services-networking/network-policies/#the-networkpolicy-resource


#Check network version
kubectl api-versions | grep -i network

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: np-test-1
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - port: 80
      protocol: TCP

#Check again
kubectl run --generator=run-pod/v1 test-np --image=busybox:1.28 --rm -it -- sh
nc -z -v -w 2 np-test-service 80
```

```html
No.6
Taint the worker node node01 to be Unschedulable. Once done, create a pod called dev-redis, image redis:alpine to ensure workloads are not scheduled to this worker node. Finally, create a new pod called prod-redis and image redis:alpine with toleration to be scheduled on node01.


Key = env_type
Value = production
Effect = NoSchedule
pod 'dev-redis' (no tolerations) is not scheduled on node01?
Create a pod 'prod-redis' to run on node01
```

```sh
Answer:
#Get nodes
kubectl get nodes

kubectl taint node node01 env_type=production:NoSchedule
kubectl describe nodes node01 | grep -i taint

kubectl run dev-redis --generator=run-pod/v1 --image=redis:alpine

apiVersion: v1
kind: Pod
metadata:
  name: prod-redis
  namespace: default
spec:
  containers:
  - image: redis:alpine
    imagePullPolicy: IfNotPresent
    name: prod-redis
  tolerations:
  - effect: NoSchedule
    key: env_type
    operator: Equal
    value: production
```

```html
No.7
Create a pod called hr-pod in hr namespace belonging to the production environment and frontend tier .
image: redis:alpine

hr-pod labeled with environment production?
hr-pod labeled with frontend tier?
```

```sh
Answer:
kubectl get ns
#If there is no namespace named hr,create it
kubectl create ns hr
#Create pod named hr-pod
kubectl run hr-pod --generator=run-pod/v1 --labels=environment=production,tier=frontend --image=redis:alpine --namespace=hr
#Verify
kubectl -n hr get pods --show-labels


```

```html
No.8
A kubeconfig file called super.kubeconfig has been created in /root. There is something wrong with the configuration. Troubleshoot and fix it.

Fix /root/super.kubeconfig
```

```sh
Answer:
cd .kube/
ls -ltr
#Check server ip and port
cat config | grep server
#Check file super.kubeconfig 
kubectl cluster-info --kubeconfig=/root/super.kubeconfig
#Change port 
sed -i 's/2379/6443/g' super.kubeconfig
#Check file again
kubectl cluster-info --kubeconfig=/root/super.kubeconfig


```

```html
No.9
We have created a new deployment called nginx-deploy. scale the deployment to 3 replicas. Has the replica's increased? Troubleshoot the issue and fix it.

deployment has 3 replicas
```

```sh
Answer:
#Check deployment nginx-deploy
kubectl get deployment
#scale nginx-deploy to 3 replicas
kubectl scale deploy nginx-deploy --replicas=3
#Check deployment nginx-deploy
kubectl describe deployments. nginx-deploy
#Check pod
kubectl get pods
kubectl get pods -n kube-system

#Edit static pod kube-controller-manager,modified label component's value
grep contro1ler kube-controller-manager.yaml | wc -l
sed -i 's/contro1ler/conroller/g' kube-controller-manager.yaml
grep controller kube-contro1ler-manager.yaml | wc -l
grep controller kube-controller-manager.yaml | wc -l




```
