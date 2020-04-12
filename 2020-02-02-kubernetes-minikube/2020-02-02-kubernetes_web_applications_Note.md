Tool:
VMware Workstation
https://my.vmware.com/en/web/vmware/info/slug/desktop_end_user_computing/vmware_workstation_pro/15_0

CentOS-7-x86_64-DVD-1810.iso
http://isoredirect.centos.org/centos/7/isos/x86_64/

Spec:
1. CPU 2core
2. memory 3GB
3. hardice 16GB
4. OS CentOS 7


#### minikube command

minikube start --vm-driver=none
minikube stop
minikube status
# Create docker and kubernetes Environment

####  minikube version 1.6 kubernetes 1.16.0
chmod +x minikube-1-6-0-installer.sh
minikube-1-6-0-installer.sh

#### minikube version 1.2 kubernetes 1.15.1
chmod +x minikube-1-2-0-installer.sh
minikube-1-2-0-installer.sh

./minikube-$version-installer.sh

# contorl addons 
minikube addons enable $AADON_NAME

minikube addons disable $ADDON_NAME

minikube 

# check addons 
minikube addons list

# Remote SSH on VSCode

# logout from container
exit
or
ctrl + p => ctrl + Q

#### Kubernetes basic operation

| Kubernetes | Docker     |
| ---------- | ---------- |
| command    | ENTRYPOINT |
| args       | CMD        |

#### create secrets
kubectl create secret generic $name $options
name: secret resource name
options: 
--from-literal=KEY=VALUE (indicate key value and registe)
--FROM-file=[KEY=]PATH (indicate path)

## access pod and execute command
#file pods.yml,pods-answer.yml
kubectl exec -it debug sh
#curl $nginxIP

pods.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug
  namespace: default
  labels:
    env: study
spec:
  containers:
    - name: debug
      image: centos:7
      command:
        - "sh"
        - "-c"
      args:
        - |
          while true
          do
            sleep ${DELAY}
          done
      env:
        - name: "DELAY"
          value: "5"

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: default
  labels:
    env: study
spec:
  containers:
  - name: nginx
    image: nginx:1.17.2-alpine
```

pods-answer.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: debug
  namespace: default
spec:
  containers:
    - name: debug
      image: centos:7
      command:
        - "sh"
        - "-c"
      args:
        - |
          while true
          do
            sleep ${DELAY}
          done
      env:
        - name: "DELAY"
          value: "86400"

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.17.2-alpine
```
## send file between pod and host

host => Pod 
kubectl cp <src> <pod-name>:<dest>
Pod => host
kubectl cp <pod-name>:<src> <dest>

### Example
kubectl cp ./sample.txt debug:/var/tmp/sample1.txt
kubectl exec -it debug sh

## get log from pod
kubectl logs [TYPE/NAME] [--tail=n]
### Example
kubectl logs pod/nginx

## build Web application practice
Web(nginx) => AP(Node.js) => DB (MongoDB) => Local Storage 
Web(nginx): Service=>Pod(Deployment)  
=> ConfigMap  
AP(Node.js): Service => Pod(Deployment)  
=>Secret<=StatefulSet(DB (MOngoDB))  
DB(MongoDB):Headless Service =>Pod(PVC)(StatefulSet)  
Local Storage:PV  

### Procedures
DB => AP => Web => LoadBalancer


### 1.Create Debug image
#### Construce flow
1. copy file what will be install
2. install module
    mongodb shell ,tool
    ip,jq,curl
    delete file not needed
3. ROOT
mongodb-org-4.0.repo
Dockerfile
debug-pod.yml

https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/
```re
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc
```
Dockerfile
```Dockerfile
FROM centos:7

COPY . /tmp/debug

RUN  \
# Install MongoDB shell, tools.
mv /tmp/debug/mongodb-org-4.0.repo /etc/yum.repos.d; \
yum install -y mongodb-org-shell-4.0.5 mongodb-org-tools-4.0.5; \
# Install ip , ifconfig command.
yum install -y iproute net-tools; \
# Install jq
curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
chmod +x /usr/local/bin/jq; \
# Delete cache files.
yum clean all;
```

debug-pod.yml
```yml
apiVersion: v1
kind: Pod
metadata:
  name: debug
  namespace: default
spec:
  containers:
    - name: debug
      image: debug
      imagePullPolicy: Never
      command:
        - "sh"
        - "-c"
      args:
        - |
          while true
          do
            sleep 5
          done
```
docker build -t debug .
docker image ls
docker run -it debug sh
#### check command
mongo
ip
ifconfig
jq
exit
#### delete all pod
docker container prune

#### Create pod
kubectl apply -f debug-pod.yml
kubectl exec -it debug sh
mongo
ip
ifconfig
jq
exit
kubectl get pod

### 2.Create DB Server image
#### Workflow
```html
1. base image:alpineLinux
2. constructure flow
   2.1 copy shell which startUp will be executed
   2.2 add user
   2.3 install MongDB
   2.4 create directory which will be used to save
   2.5 change properties
   2.6 set mount point
   2.7 publish port 27017
3. command
   ENTRYPOINT startup shell
   CMD         mongd    
4. ROOT
   .dockerignore
   docker-entrypoint.sh
   Dockerfile
```

.dockerignore
```.dockerignore
**/.git
**/.DS_Store
**/node_modules
```
docker-entrypoint.sh
```sh
#! /bin/sh
INIT_FLAG_FILE=/data/db/init-completed
INIT_LOG_FILE=/data/db/init-mongod.log

start_mongod_as_daemon() {
echo 
echo "> start mongod ..."
echo 
mongod \
  --fork \
  --logpath ${INIT_LOG_FILE} \
  --quiet \
  --bind_ip 127.0.0.1 \
  --smallfiles;
}

create_user() {
echo
echo "> create user ..."
echo
if [ ! "$MONGO_INITDB_ROOT_USERNAME" ] || [ ! "$MONGO_INITDB_ROOT_PASSWORD" ]; then
  return
fi
mongo "${MONGO_INITDB_DATABASE}" <<-EOS
  db.createUser({
    user: "${MONGO_INITDB_ROOT_USERNAME}",
    pwd: "${MONGO_INITDB_ROOT_PASSWORD}",
    roles: [{ role: "root", db: "${MONGO_INITDB_DATABASE:-admin}"}]
  })
EOS
}

create_initialize_flag() {
echo
echo "> create initialize flag file ..."
echo
cat <<-EOF > "${INIT_FLAG_FILE}"
[$(date +%Y-%m-%dT%H:%M:%S.%3N)] Initialize scripts if finigshed.
EOF
}

stop_mongod() {
echo
echo "> stop mongod ..."
echo
mongod --shutdown
}

if [ ! -e ${INIT_LOG_FILE} ]; then
  echo 
  echo "--- Initialize MongoDB ---"
  echo 
  start_mongod_as_daemon
  create_user
  create_initialize_flag
  stop_mongod
fi

exec "$@"
```

Dockerfile
```Dockerfile
FROM alpine:3.9

COPY docker-entrypoint.sh /usr/local/bin

RUN \
adduser -g mongodb -DH -u 1000 mongodb; \
apk --no-cache add mongodb=4.0.5-r0; \
chmod +x /usr/local/bin/docker-entrypoint.sh; \
mkdir -p /data/db; \
chown -R mongodb:mongodb /data/db;

VOLUME /data/db

EXPOSE 27017

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "mongod" ]
```
```shell
# Operation
docker build -t weblog-db:v1.0.0 .  
docker run -d weblog-db:v1.0.0  
docker container ls  
docker exec -it romantic_panini(image:weblog-db:v1.0.0) sh  
mongo  
show dbs  
exit;exit  
docker stop romantic_panini  
docker system prune  
```

### 3.Build DB Server(Storage)
#### Workflow
```html
1. Create pv,pvc  
2. Check created resource  
   ROOT
   weblog-db-storage.yml
```



```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/storage"
    type: Directory

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

### 4.Build DB Server(Pod)

#### Workflow
```html
1. create pv,pvc,pod
2. check created file
3. login to created pod
4. access to mongo db
   ROOT
   weblog-db-pod.yml(pv and pvc is similar to weblog-db-storage.yml )
```

```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/storage"
    type: Directory

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

---
apiVersion: v1
kind: Pod
metadata:
  name: mongodb
  namespace: default
  labels:
    app: weblog
    type: database
spec:
  containers:
  - name: mongodb
    image: weblog-db:v1.0.0
    imagePullPolicy: Never
    command:
    - "mongod"
    - "--bind_ip_all"
    volumeMounts:
    - mountPath: /data/db
      name: storage
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: storage-claim
```

```shell
#operation
mkdir -p /data/db
mkdir -p /data/storage

Check if there is files,delete them
ls /data/storage

kubectl apply -f weblog-db-pod.yml
kubectl get pod
Check again
ls /data/storage

kubectl exec -it mongodb sh
mongo
show dbs
exit
exit
```

#### clean resource
kubectl delete -f weblog-db-pod.yml

### 5.Build DB Server(Pod + Secret)
#### Workflow
```html
1. create keyfile(random string)
2. create secret source
3. get yaml file of secret resouce 
4. merge weblog-db-pod.yml
5. delete secret resource
```

#### Check flow
1. create pv,pod,secret 
2. login pod
3. access mongodb
4. authenticatation
5. show db list


#### use openssl generate random number
openssl rand -base64 <$number>
#### delete change line
tr -d '\r\n'
#### Resize 
cut -c 1-<$number>

#### 1. create keyfile(random string)
openssl rand -base64 1024 | tr -d '\r\n' | cut -c 1-1024 > keyfile
#### 2. create secret source
kubectl create secret generic mongo-secret \
--from-literal=root_username=admin \
--from-literal=root_password=Passw0rd \
--from-file=./keyfile

#### 3. get yaml file of secret resouce 
kubectl get secret/mongo-secret -o yaml
```yml
apiVersion: v1
data:
  keyfile: akYwZjNGY0tZZWI2Y3laQTE4RjQ4eVRDRVQzM3dVdFp2SmkvMlM2S0luOUR1dzlPd2prZk9sdEt0a1dUZVRDRzdQMW1Qc2ZNVy9wclFPUlA0UFZ0bjdmQVptdm1DbkQxamp2MDFRMS9neHNUUHp1MVVIZzBFUFQwUGxRNmRGUUVlWjc2ZTd1d2ZrQ2VyVFNPUzlVTXArbUN5M1U5MTNYTnpBeXJvUS9FSnBBN0ozRXpqMitraVFHdjRUdGJsZkViTEpVWFlkRUFkUC9URjRIN3FRd0J3RWNJRHpFSlYxQ0Z4TncrOGVwWlNHUGVDN2t4b1pUQlJJZ2JpVThrcVRwdjFRWGFVTnQyUUZyR0Q4eEYzaHpsR1VwZlFEYWJub0FzOWdxQ3pnSW1xeTVJcC96Um9ITGZVaUFIQ1lJdS9rZS9TMC9mWGRPSjV4SGtaNmRoQ3l3eERDcXlVUXpva0NNRCtPbUduaDlvNGx5YjlHWXNkWVhDQmNpMHZoMFBUTS9zZEUvT00zcHNvVmh3aElJSHVWbFJ4aGd4cHBBWFYxS2NFREVxZmh0NHNGTGdWSGlycEhFU3MxT1JXQUVjU0JPRU1BSlZJdjhGMVp2S0hhcVUvV2NzOEwzQW1iWFBmNmhET0pHaExORjl1S0NMdE9VaWlWSU0wcjJ0aFFxamJTVmVOSUZ0bGp3Y3daZTJTM21vNzRXeUtIUGNVV0N6ZW5UUHd2YkhwL0Nqb2c0NTZvZGJRT3MralFDbEdJTm5ST3VxOW5scFFobmtQRmpMKzdzbnozZEozRS84Y0kzRUZ5MEZmakZFVnh4TXN3TEFKRXhBaEtnS1FGMk1KK2s3MEo4RlNhMVI2Z0l1bkNGOFBRY2NHa1F1OHZja004WUExNDBJSWdEL3l6cTR6RmVMS1Z6bzVLNXJnUFVySW9zTHcyN3NyS3ZTTVdydEZsSG1qRDB1WWZDTHVhaGxoTGFHQm5uOWd4Vzg5cEIyZmRlQlFVWUJZUFRQOTJkSEt3M042QjZrbkxmVkhzbmNVclF1ZktHRjFxVUlqekplZWw5T3JyRzA2bCtoS2hhYnVuWkcvZXhMRElUYllaQkQyWkY3ZzBqNzYwYkM2SVpIN05aSXJPdHdhSWVHb0FtYkxWTVJ2MzRWMjNidk1rc3V1L0wzc1RzUTlDL3V0aUl3STJTQ0xIN0cvak9HcUwySWJEWU82T0VQMExvN1lPRzdxZkdoM0cvMXBUcFVwZ0thNkwrRmNPcUhQUkl5Z3NuTU1iQnVMMmZSMWtUdHN1MjZxV1V4dVgzY21pcStKeEZWUGFZR1kzY1BzUGNWbmJKTHJCdFdTNkNvNzY2OEo0Q2xxQ2RpQUVRNQo=
  root_password: UGFzc3cwcmQ=
  root_username: YWRtaW4=
kind: Secret
metadata:
  creationTimestamp: "2020-01-29T14:48:11Z"
  name: mongo-secret
  namespace: default
  resourceVersion: "22489"
  selfLink: /api/v1/namespaces/default/secrets/mongo-secret
  uid: 8f65fcbd-2ebe-49c4-9f59-3a7020b5e4aa
type: Opaque
```
#### 4. merge weblog-db-pod.yml
refer to weblog-db-pod.yml
#### 5. delete secret resource
```shell
ls /data/storage
rf -rf /data/storage/*
ls /data/storage

kubectl get pod

kubectl exec -it mongodb sh
mongo
```

##### can't show
```mongodb
show dbs
use admin
db.auth("admin","Passw0rd")
show dbs

ROOT
keyfile
weblog-db-pod.yml
```


```keyfile
DFCytNO0mwawyBs25EOwptvC1TicPzI39KkojjhfE7HeR/VvryeNwqdOvOwiZ9jP/pIWIeYUYiktZXfXhOOlyMBEwUCGr+umbmEeududNy4hQCsVe0YOSlX07Xqa//o+mz4Z8pEchN0wUahqpHD5ieFyoMNIVaEcFPF43+3vZovw7M4xaY+xhhnW5etgm/c2g9GaGlJ4aXPXJbHQTylscnivBrmWiIY+JAPc+oFGJL5I3OCiSR1d66gG99ysof76Rtx0MvYgWdX9rSe16odaI3IWtmhI2CLbWpS994nYcWTCbtor3fMC1cs8nNRWy1un+JbbPooMqiRObxRncHap2X+pOKtjYPg+YKX1Htf+XyaH7DrFdZMnsVbAtAgV6Cf67IZym65p8LjjFkhZTbn5ZMgjQinwerkB+QC5hmaQQhAu6z5te+kPrsQg4PQ/JCRL7vweZEzddwlCo8NYGUJXaSG0Lg2k7wDx9oHLTuA/Telit2VrfgRbU6Y6f6FEOczjKnHKgHT09RJa56wdihgHreyWbVCC7BfdFJ2zRj1fG5YEgpkA3pgMsuvUDi6Ai6tNVe3O3jAqCmXghpFbryi9XYgtDsQkpGPRUZyLvNBj5k8qBoiYkiHPWvyIbyB9SX0pcyP10R8zR0TB8pXUZb3Xh1p4VDMTtg5u8Wwf56pIrWe3KYj20P2wWyQ3glDo5GMJxUdoubTxOun2+V0J6Oc0dKlmweqEjAbakJiDdyvty2OggnbgRSNYZInNKVR9nbnPUE/kCSMbNeE5hVVFC0zx6FKHkdxiZFEv8bP/LR4hY49OEZa9vuPRBn2LqflucO7wm5OnD8mN3PY8LlpN6SWCUTGJ2qfwm36vjRKpHxnFH6IcyDVwmbPulCMEnfnL5rKJ/4bZGiE1SQobQGYD/Gbq1UFWok0FMfTFV1wetQfVv32SISJ6PUJM2iThBJWDPNVTmKf28Dlq2NaLFMd1ugKxAWP2fN9YOgw6ZuiiRB/6UbIM7Ms2FWfytGp2oYcy94XP
```
weblog-db-pod+secret.yml
```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/storage"
    type: Directory

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi

---
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: v1
kind: Pod
metadata:
  name: mongodb
  namespace: default
  labels:
    app: weblog
    type: database
spec:
  containers:
  - name: mongodb
    image: weblog-db:v1.0.0
    imagePullPolicy: Never
    args:
    - "mongod"
    - "--auth"
    - "--bind_ip_all"
    env:
    - name: "MONGO_INITDB_ROOT_USERNAME"
      valueFrom:
        secretKeyRef:
          name: mongo-secret
          key: root_username
    - name: "MONGO_INITDB_ROOT_PASSWORD"
      valueFrom:
        secretKeyRef:
          name: mongo-secret
          key: root_password
    - name: "MONGO_INITDB_DATABASE"
      value: "admin"
    volumeMounts:
    - mountPath: /data/db
      name: storage
    - mountPath: /home/mongodb
      name: secret
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: storage-claim
  - name: secret
    secret:
      secretName: mongo-secret
      items:
      - key: keyfile
        path: keyfile
        mode: 0700
```
### 6.Build DB Server(StatefulSet)

ROOT
  weblog-db-statfulset.yml
```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-0
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0000"
    type: Directory

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-1
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0001"
    type: Directory

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-2
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0002"
    type: Directory

---
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongo
  namespace: default
  labels:
    app: weblog
    type: database
spec:
  selector:
    matchLabels:
      app: weblog
      type: database
  serviceName: db-svc
  replicas: 3
  template:
    metadata:
      name: mongodb
      namespace: default
      labels:
        app: weblog
        type: database
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: mongodb
        image: weblog-db:v1.0.0
        imagePullPolicy: Never
        args:
        - "mongod"
        - "--auth"
        - "--clusterAuthMode=keyFile"
        - "--keyFile=/home/mongodb/keyfile"
        - "--replSet=rs0"
        - "--bind_ip_all"
        env:
        - name: "MONGO_INITDB_ROOT_USERNAME"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: root_username
        - name: "MONGO_INITDB_ROOT_PASSWORD"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: root_password
        - name: "MONGO_INITDB_DATABASE"
          value: "admin"
        volumeMounts:
        - mountPath: /data/db
          name: storage
        - mountPath: /home/mongodb
          name: secret
      volumes:
      - name: secret
        secret:
          secretName: mongo-secret
          items:
          - key: keyfile
            path: keyfile
            mode: 0700
  volumeClaimTemplates:
  - metadata:
      name: storage
    spec:
      storageClassName: slow
      accessModes:
      - ReadWriteMany
      resources:
        requests:
          storage: 1Gi

```
#### Workflow

```shell
1. create pv,secret,statefulset
   mkdir -p /data/pv0000
   mkdir -p /data/pv0001
   mkdir -p /data/pv0002

kubectl apply -f  weblog-db-statfulset.yml

2. login created pod
   kubectl get pod
   kubectl exec -it mongo-0 sh

3. access mongodb
4. authicate username/password
   show dbs
   use admin
   db.auth("admin","Passw0rd")
   exit
```

kubectl get pv,pvc
kubectl delete persistentvolumeclaim/storage-mongo-0 persistentvolumeclaim/storage-mongo-1 persistentvolumeclaim/storage-mongo-2
kubectl delete persistentvolume/storage-volume-0 persistentvolume/storage-volume-1  persistentvolume/storage-volume-2
kubectl get pv,pvc,pod

### 7.Build DB Server(HeadlessService) 
#### NOTE don't delete db server in this lecture
ROOT
 weblog-db-fullset.yml
```yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-0
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0000"
    type: Directory

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-1
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0001"
    type: Directory

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: storage-volume-2
  namespace: default
  labels:
    app: weblog
    type: storage
spec:
  storageClassName: slow
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/data/pv0002"
    type: Directory

---
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: v1
kind: Service
metadata:
  name: db-svc
  namespace: default
  labels:
    app: weblog
    type: database
spec:
  ports:
  - port: 27017
    targetPort: 27017
  clusterIP: None
  selector:
    app: weblog
    type: database

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongo
  namespace: default
  labels:
    app: weblog
    type: database
spec:
  selector:
    matchLabels:
      app: weblog
      type: database
  serviceName: db-svc
  replicas: 3
  template:
    metadata:
      name: mongodb
      namespace: default
      labels:
        app: weblog
        type: database
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: mongodb
        image: weblog-db:v1.0.0
        imagePullPolicy: Never
        args:
        - "mongod"
        - "--auth"
        - "--clusterAuthMode=keyFile"
        - "--keyFile=/home/mongodb/keyfile"
        - "--replSet=rs0"
        - "--bind_ip_all"
        env:
        - name: "MONGO_INITDB_ROOT_USERNAME"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: root_username
        - name: "MONGO_INITDB_ROOT_PASSWORD"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: root_password
        - name: "MONGO_INITDB_DATABASE"
          value: "admin"
        volumeMounts:
        - mountPath: /data/db
          name: storage
        - mountPath: /home/mongodb
          name: secret
      volumes:
      - name: secret
        secret:
          secretName: mongo-secret
          items:
          - key: keyfile
            path: keyfile
            mode: 0700
  volumeClaimTemplates:
  - metadata:
      name: storage
    spec:
      storageClassName: slow
      accessModes:
      - ReadWriteMany
      resources:
        requests:
          storage: 1Gi
```


#### Workflow
1. Create pv,secret statefulset,service
##### Check if there is file ,and delete files
```shell
ls {/data/pv0000,/data/pv0001,/data/pv0002}
rm -rf {/data/pv0000/*,/data/pv0001/*,/data/pv0002/*}
ls /data/pv0000 /data/pv0001 /data/pv0002

kubectl apply -f weblog-db-fullset.yml

2. login pod
   kubectl exec -it mongo-0 sh
   ping mongo-1.db-svc

3. initialize MongoDB
   mongo
   use admin
   db.auth("admin", "Passw0rd")
```

```sh
rs.initiate({
..._id:"rs0",
...members: [
...{_id: 0, host:"mongo-0.db-svc:27017"},
...{_id: 1, host:"mongo-1.db-svc:27017"},
...{_id: 2, host:"mongo-1.db-svc:27017"},
...]
...})
```
##### show ok
{ "ok" : 1 }
##### check status
rs.status()
##### show primary
rs0:PRIMARY

show dbs
4. check it is repicase
### 8.Build DB Server(Initial)
ROOT
 adduser.js
 insert.js
 init.sh

adduser.js
```js
// use weblog
db.createUser({
  user: "user",
  pwd: "welcome",
  roles: [{
    role: "readWrite", db: "weblog"
  }]
})
```
insert.js
```js
//
// posts table
//
db.posts.createIndex({ url: 1 }, { unique: true, background: true });
db.posts.insertMany([{
  url: "/2017/05/hello-nodejs.html",
  published: new Date(2017, 4, 2),
  updated: new Date(2017, 4, 2),
  title: "ようこそ Node.js の世界へ",
  content: "Node.js は おもしろい！",
  keywords: ["Node.js"],
  authors: ["Yuta Sato"]
}, {
  url: "/2017/06/nodejs-basic.html",
  published: new Date(2017, 5, 12),
  updated: new Date(2017, 5, 12),
  title: "Node.js の 基本",
  content: "ちょっと難しくなってきた！？",
  keywords: ["Node.js"],
  authors: ["Yuta Sato"]
}, {
  url: "/2017/07/advanced-nodejs.html",
  published: new Date(2017, 7, 8),
  updated: new Date(2017, 7, 8),
  title: "Node.js 応用",
  content: "Node.js で Excel ファイルが触れるなんて！！",
  keywords: ["Node.js"],
  authors: ["Yuta Sato"]
}]);

//
// users table
//
db.users.createIndex({ email: 1 }, { unique: true, background: true });
db.users.insertMany([{
  email: "yuta.sato@sample.com",
  name: "Yuta Sato",
  password: "77d1fb804f4e1e6059377122046c95de5e567cb9fd374639cb96e7f5cc07dba1", //"qwerty", // "77d1fb804f4e1e6059377122046c95de5e567cb9fd374639cb96e7f5cc07dba1"
  role: "owner"
}]);

//
// privileges table
//
db.privileges.createIndex({ role: 1 }, { unique: true, background: true });
db.privileges.insertMany([
  { role: "default", permissions: ["read"] },
  { role: "owner", permissions: ["readWrite"] }
]);

```
init.sh
```sh
# Create user 
mongo mongodb://mongo-0.db-svc:27017/weblog -u admin -p Passw0rd --authenticationDatabase admin ./adduser.js

# Create collection & insert initial data
mongo mongodb://mongo-0.db-svc:27017/weblog -u admin -p Passw0rd --authenticationDatabase admin ./insert.js
```
drop.js
```js
db.posts.drop();
db.users.drop();
db.privileges.drop();
```

#### Workflow
```shell
1. launch debug pod
2. copy initial script to pod
   mkdir script
   mv *.js ./script
   mv *.sh ./script
   kubectl cp . debug:/root/init-db
3. login debug pod
   kubectl exec -it debug sh
   cd /data/init-db
   #show script 
   ls
4. access mongdb and check primary,logout
   mongo mongo-0.db-svc
   use admin
   db.auth("admin","Passw0rd")
```

#### Check there is primary and secondary
```shell
rs.status()
exit

5. modify initial script (if need)
   #check "mongo-0.db-svc"
6. execute initial script
   sh init.sh

7. access any MongoDB and check data
   mongo mongo-0.db-svc
   use admin
   db.auth("admin","Passw0rd")
```

##### will show weblog dbs
```mongodb
show dbs
use weblog
show collections
```

##### will show datas
```mongodb
posts
privileges
users

db.posts.find().pretty()
```

### 9.Create AP Server image 
ROOT(All file in same folder)

```html
  Node.js application
    app.js
    package.json
    yarn.lock
    api
    config
    lib
    log
    public
    routes
    views
 .dockerignore
 docker-entrypoint.sh
```

Dockerfile

```.dockeringore
**/.vscode
**/.git
**/.DS_Store
**/node_modules
*.log
```

docker-entrypoint.sh
```sh
#! /bin/sh

if [ -n "${MONGODB_HOSTS}" ]; then
  node ./lib/database/wait.js
else
  echo "WARN: MONGODB_HOSTS is not defines."
fi

exec "$@"
```
 Dockerfile
``` Dockerfile
FROM node:10-alpine

COPY . /home/node/webapp

RUN cd /home/node/webapp; \
    mv docker-entrypoint.sh /usr/local/bin; \
    chmod +x /usr/local/bin/docker-entrypoint.sh; \
    yarn install;

EXPOSE 3000

WORKDIR /home/node/webapp
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "npm", "start" ]
```
##### check 
db server is launched and initiliazed

#### Senario

```html
0. create image
   docker build -t weblog-app:v1.0.0 .
1. check MongoDB
   kubectl exec -it mongo-0 sh
   use admin
   db.auth("admin","Passw0rd")
```

##### can check which pod is primary or secondary
```shell
rs.status()

2.create service,endpoints for MongoDB(kubectl apply)
kubectl apply -f weblog-db-service.yml
```

weblog-db-service.yml
```yml
apiVersion: v1
kind: Service
metadata:
  name: mongodb
  namespace: default
  labels:
    env: study
spec:
  ports:
  - port: 27017
    targetPort: 27017
    nodePort: 32717
  type: NodePort

---
apiVersion: v1
kind: Endpoints
metadata:
  name: mongodb
  namespace: default
  labels:
    env: study
subsets:
- addresses:
  - ip: 172.17.0.11
  ports:
  - port: 27017

```
```shell
3. execute image(docker run)
   docker run \
     -e MONGODB_USERNAME="user" \
     -e MONGODB_PASSWORD="welcome" \
     -e MONGODB_HOSTS="192.168.207.129:32717" \
     -e MONGODB_DATABASE="weblog" \
     -d \
     -p 8080:3000 \
     weblog-app:v1.0.0
4. access to Node.js application container(curl)
   open below url with browser
   192.168.207.129:8080
5. delete service endopoints that access MongoDB(kubectl delete)
   docker container ls
   docker stop (image:weblog-app:v1.0.0)
   docker container prune
   #the blow erros is double delete,is ok
   #Error from server (NotFound): error when deleting "weblog-db-service.yml": endpoints "mongodb" not found
   kubectl delete -f weblog-db-service.yml
   kubectl get svc,ep
```

### 10.Build AP Server(Pod + Secret)
ROOT
 weblog-app-pod.yml


weblog-app-pod.yml
```yml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  weblog_username: dXNlcg==     # user
  weblog_password: d2VsY29tZQ== # welcome
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: v1
kind: Pod
metadata:
  name: nodeapp
  namespace: default
  labels:
    app: weblog
    type: application
spec:
  containers:
  - name: node
    image: weblog-app:v1.0.0
    imagePullPolicy: Never
    ports:
    - containerPort: 3000
    env:
    - name: "MONGODB_USERNAME"
      valueFrom:
        secretKeyRef:
          name: mongo-secret
          key: weblog_username
    - name: "MONGODB_PASSWORD"
      valueFrom:
        secretKeyRef:
          name: mongo-secret
          key: weblog_password
    - name: "MONGODB_HOSTS"
      value: "mongo-0.db-svc:27017,mongo-1.db-svc:27017,mongo-2.db-svc:27017,"
    - name: "MONGODB_DATABASE"
      value: "weblog"
    - name: "MONGODB_REPLICASET"
      value: "rs0"
```
echo -n "<String>" | base64
#### Senario

```html
1. Create Secret(Reuse which created in db server),Pod(kubectl apply)
   kubectl apply -f weblog-app-pod.yml
2. Access debug Pod(kubectl exec)
   kubectl exec -it debug sh
3. Certificate it can access AP Server Pod(curl)
   kubectl get pod -o wide (check nodeapp's ip)
   curl $IP:3000
4. Delete nodeapp node
   kubectl delete pod nodeapp
```

### 11.Build AP Server(Deployment)
ROOT
 weblog-app-deployment.yml
```yml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  weblog_username: dXNlcg==     # user
  weblog_password: d2VsY29tZQ== # welcome
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp
  namespace: default
  labels:
    app: weblog
    type: application
spec:
  replicas: 3
  selector:
    matchLabels:
      app: weblog
      type: application
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  revisionHistoryLimit: 14
  template:
    metadata:
      name: nodeapp
      namespace: default
      labels:
        app: weblog
        type: application
    spec:
      containers:
      - name: node
        image: weblog-app:v1.0.0
        imagePullPolicy: Never
        ports:
        - containerPort: 3000
        env:
        - name: "MONGODB_USERNAME"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: weblog_username
        - name: "MONGODB_PASSWORD"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: weblog_password
        - name: "MONGODB_HOSTS"
          value: "mongo-0.db-svc:27017,mongo-1.db-svc:27017,mongo-2.db-svc:27017,"
        - name: "MONGODB_DATABASE"
          value: "weblog"
        - name: "MONGODB_REPLICASET"
          value: "rs0"
```
#### Senario
```shell
1. Create Secret,Deployment(kubectl apply)
   kubectl apply -f weblog-app-deployment.yml
2. Access debug pod(kubectl exec)

##### Check ip 

kubectl get pod -o wide | grep nodeapp
kubectl exec -it debug sh

3. Access ap server and check pod's connection(curl)
   curl $ip0:3000
   curl $ip1:3000
   curl $ip2:3000
   exit
4. Delete Deployment
   kubectl delete deploy nodeapp
   kubectl get deploy nodeapp
```

### 12.Build AP Server(Service)
ROOT
  weblog-app-fullset.yml
```yml
apiVersion: v1
kind: Secret
metadata:
  name: mongo-secret
  namespace: default
  labels:
    app: weblog
    type: database
type: Opaque
data:
  root_username: YWRtaW4=
  root_password: UGFzc3cwcmQ=
  weblog_username: dXNlcg==     # user
  weblog_password: d2VsY29tZQ== # welcome
  keyfile: REZDeXROTzBtd2F3eUJzMjVFT3dwdHZDMVRpY1B6STM5S2tvampoZkU3SGVSL1Z2cnllTndxZE92T3dpWjlqUC9wSVdJZVlVWWlrdFpYZlhoT09seU1CRXdVQ0dyK3VtYm1FZXVkdWROeTRoUUNzVmUwWU9TbFgwN1hxYS8vbyttejRaOHBFY2hOMHdVYWhxcEhENWllRnlvTU5JVmFFY0ZQRjQzKzN2Wm92dzdNNHhhWSt4aGhuVzVldGdtL2MyZzlHYUdsSjRhWFBYSmJIUVR5bHNjbml2QnJtV2lJWStKQVBjK29GR0pMNUkzT0NpU1IxZDY2Z0c5OXlzb2Y3NlJ0eDBNdllnV2RYOXJTZTE2b2RhSTNJV3RtaEkyQ0xiV3BTOTk0blljV1RDYnRvcjNmTUMxY3M4bk5SV3kxdW4rSmJiUG9vTXFpUk9ieFJuY0hhcDJYK3BPS3RqWVBnK1lLWDFIdGYrWHlhSDdEckZkWk1uc1ZiQXRBZ1Y2Q2Y2N0laeW02NXA4TGpqRmtoWlRibjVaTWdqUWlud2Vya0IrUUM1aG1hUVFoQXU2ejV0ZStrUHJzUWc0UFEvSkNSTDd2d2VaRXpkZHdsQ284TllHVUpYYVNHMExnMms3d0R4OW9ITFR1QS9UZWxpdDJWcmZnUmJVNlk2ZjZGRU9jempLbkhLZ0hUMDlSSmE1NndkaWhnSHJleVdiVkNDN0JmZEZKMnpSajFmRzVZRWdwa0EzcGdNc3V2VURpNkFpNnROVmUzTzNqQXFDbVhnaHBGYnJ5aTlYWWd0RHNRa3BHUFJVWnlMdk5CajVrOHFCb2lZa2lIUFd2eUlieUI5U1gwcGN5UDEwUjh6UjBUQjhwWFVaYjNYaDFwNFZETVR0ZzV1OFd3ZjU2cElyV2UzS1lqMjBQMndXeVEzZ2xEbzVHTUp4VWRvdWJUeE91bjIrVjBKNk9jMGRLbG13ZXFFakFiYWtKaURkeXZ0eTJPZ2duYmdSU05ZWkluTktWUjluYm5QVUUva0NTTWJOZUU1aFZWRkMweng2RktIa2R4aVpGRXY4YlAvTFI0aFk0OU9FWmE5dnVQUkJuMkxxZmx1Y083d201T25EOG1OM1BZOExscE42U1dDVVRHSjJxZndtMzZ2alJLcEh4bkZINkljeURWd21iUHVsQ01FbmZuTDVyS0ovNGJaR2lFMVNRb2JRR1lEL0dicTFVRldvazBGTWZURlYxd2V0UWZWdjMyU0lTSjZQVUpNMmlUaEJKV0RQTlZUbUtmMjhEbHEyTmFMRk1kMXVnS3hBV1AyZk45WU9ndzZadWlpUkIvNlViSU03TXMyRldmeXRHcDJvWWN5OTRYUAo=

---
apiVersion: v1
kind: Service
metadata:
  name: app-svc
  namespace: default
  labels:
    app: weblog
    type: application
spec:
  ports:
  - port: 3000
    targetPort: 3000
  selector:
    app: weblog
    type: application

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeapp
  namespace: default
  labels:
    app: weblog
    type: application
spec:
  replicas: 3
  selector:
    matchLabels:
      app: weblog
      type: application
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  revisionHistoryLimit: 14
  template:
    metadata:
      name: nodeapp
      namespace: default
      labels:
        app: weblog
        type: application
    spec:
      containers:
      - name: node
        image: weblog-app:v1.0.0
        imagePullPolicy: Never
        ports:
        - containerPort: 3000
        env:
        - name: "MONGODB_USERNAME"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: weblog_username
        - name: "MONGODB_PASSWORD"
          valueFrom:
            secretKeyRef:
              name: mongo-secret
              key: weblog_password
        - name: "MONGODB_HOSTS"
          value: "mongo-0.db-svc:27017,mongo-1.db-svc:27017,mongo-2.db-svc:27017,"
        - name: "MONGODB_DATABASE"
          value: "weblog"
        - name: "MONGODB_REPLICASET"
          value: "rs0"

```
#### Senario
```shell
1. Create Secret,Deployment,Service
   kubectl apply -f weblog-app-fullset.yml
2. Access Debug Pod
   kubectl exec -it debug sh
3. Access service
```

#####  kubectl get svc (get service name)
curl http://app-svc:3000

```shell
4. Check Ap Server log(Check every nodeapp pod,so you can find which pod you accessed)
kubectl logs $(nodeapp)
```

##### you can get log just like below log
```log
[2020-01-30T14:23:59.235] [INFO] access - ::ffff:172.17.0.8 - - "GET / HTTP/1.1" 200 1404 "" "curl/7.29.0"
```
### 13.Create Web Server image
ROOT
  nginx.conf
```conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;

    keepalive_timeout  65;

    server_tokens   off;

    proxy_cache_path /var/cache/nginx keys_zone=STATIC:10m max_size=1g inactive=10d;
    proxy_temp_path  /var/cache/nginx/tmp;

    server {
        listen        80;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        location / {
            proxy_pass http://${APPLICATION_HOST}/;
        }

        location /public/ {
            proxy_pass http://${APPLICATION_HOST}/public/;
            proxy_ignore_headers Cache-Control Expires;
            proxy_buffering on;
            proxy_cache STATIC;
            proxy_cache_valid any 10d;
            add_header X-Nginx-Cache $upstream_cache_status;
        }
    }

    # include /etc/nginx/conf.d/*.conf;
}

```
  docker-entrypoint.sh
```sh
#! /bin/sh

envsubst '$$APPLICATION_HOST' \
  < /home/nginx/nginx.conf \
  > /etc/nginx/nginx.conf

exec "$@"
```
  Dockerfile
```Dockerfile
FROM nginx:1.17.2-alpine

COPY . /home/nginx

RUN cd /home/nginx; \
    mv docker-entrypoint.sh /usr/local/bin; \
    chmod +x /usr/local/bin/docker-entrypoint.sh;

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
```
weblog-app-service.yml
```yml
apiVersion: v1
kind: Service
metadata:
  name: nodeapp
  namespace: default
  labels:
    env: study
spec:
  type: NodePort
  selector:
    app: weblog
    type: application
  ports:
  - port: 3000
    targetPort: 3000
    nodePort: 30000
```
envsubst "$$Env Variate" < "Input" > "Output"

#### Design
|          |                            |
|----------|----------------------------|
|base image| Nginx v1.17 on Alpine Linux|
|  Procedures  |1. copy nginx.conf and boot shell |
|              |2. move boot shell and change permissions |
|command       |ENTRYPOINT boot shell                     |
|              |CMD  nginx -g daemon off;|
#### Senario
```shell
1. Create image
   docker build -t weblog-web:v1.0.0 .
2. Create service which accesses AP Server
   kubectl apply -f weblog-app-service.yml
3. Launch Web Conainer
```

```sh
docker run \
> -e APPLICATION_HOST=192.168.207.129:30000 \
> -p 8080:80 \
> -d \
> weblog-web:v1.0.0
```
```shell
8080:nginx
80:docker container 

3. Access from external brower

##### Check 

docker container ls
http://$HOSTIP:8080/

4. Stop container
   docker stop $containerID
   docker container prune

5. Delete Service
   kubectl delete -f  weblog-app-service.yml
```



### 14.Build Web Server(Pod)
ROOT
  weblog-web-pod.yml
```yml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: default
  labels:
    app: weblog
    type: frontend
spec:
  containers:
  - name: nginx
    image: weblog-web:v1.0.0
    imagePullPolicy: Never
    ports:
    - containerPort: 80
    env:
    - name: "APPLICATION_HOST"
      value: "app-svc:3000"
```

#### Senario

```html
1. Create Pod
   kubectl apply -f weblog-web-pod.yml

2. Check web pod's ip
   kubectl get pod -o wide(get pod nginx's ip )

3. Access debug pod
   kubectl exec -it debug sh

4. Access Web Server
   curl $IP

5. Check accessed Web Server's log(check every nodeapp pod)
   kubectl log pod/$nodeapp
```

### 15.Build Web Server(Pod + ConfigMap)
ROOT \
  weblog-web-pod+configmap.yml

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: default
  labels:
    app: weblog
    type: frontend
data:
  nginx.conf: |
    user  nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;


    events {
        worker_connections  1024;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;

        keepalive_timeout  65;

        server_tokens   off;

        proxy_cache_path /var/cache/nginx keys_zone=STATIC:10m max_size=1g inactive=10d;
        proxy_temp_path  /var/cache/nginx/tmp;

        server {
            listen        80;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            location / {
                proxy_pass http://${APPLICATION_HOST}/;
            }

            location /public/ {
                proxy_pass http://${APPLICATION_HOST}/public/;
                proxy_ignore_headers Cache-Control Expires;
                proxy_buffering on;
                proxy_cache STATIC;
                proxy_cache_valid any 10d;
                add_header X-Nginx-Cache $upstream_cache_status;
            }
        }

        # include /etc/nginx/conf.d/*.conf;
        # ConfigMap
    }

---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  namespace: default
  labels:
    app: weblog
    type: frontend
spec:
  containers:
  - name: nginx
    image: weblog-web:v1.0.0
    imagePullPolicy: Never
    ports:
    - containerPort: 80
    env:
    - name: "APPLICATION_HOST"
      value: "app-svc:3000"
    volumeMounts:
    - name: config-volume
      mountPath: /home/nginx
  volumes:
  - name: config-volume
    configMap:
      name: nginx-config

```
#### Senario

```html
1. Create ConfigMap,Pod
   kubectl apply -f weblog-web-pod+configmap.yml

2. Access Web Server's Pod, and check it used ConfigMap
   kubectl exec -it nginx sh
   cat /etc/nginx/nginx.conf

3. Check Web Server's Pod ip
   kubectl get pod -o wide

4. Access debug pod
   kubectl exec -it debug sh

5. Check can access Web Server's pod
   cat $IP

6. Delete Pod,ConfigMap
```

### 16.Build Web Server(Deployment)
ROOT  \
  weblog-web-deployment.yml

```yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: default
  labels:
    app: weblog
    type: frontend
data:
  nginx.conf: |
    user  nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;


    events {
        worker_connections  1024;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;

        keepalive_timeout  65;

        server_tokens   off;

        proxy_cache_path /var/cache/nginx keys_zone=STATIC:10m max_size=1g inactive=10d;
        proxy_temp_path  /var/cache/nginx/tmp;

        server {
            listen        80;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            location / {
                proxy_pass http://${APPLICATION_HOST}/;
            }

            location /public/ {
                proxy_pass http://${APPLICATION_HOST}/public/;
                proxy_ignore_headers Cache-Control Expires;
                proxy_buffering on;
                proxy_cache STATIC;
                proxy_cache_valid any 10d;
                add_header X-Nginx-Cache $upstream_cache_status;
            }
        }

        # include /etc/nginx/conf.d/*.conf;
        # ConfigMap
    }

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
  labels:
    app: weblog
    type: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: weblog
      type: frontend
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  revisionHistoryLimit: 14
  template:
    metadata:
      name: nginx
      namespace: default
      labels:
        app: weblog
        type: frontend
    spec:
      containers:
      - name: nginx
        image: weblog-web:v1.0.0
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        env:
        - name: "APPLICATION_HOST"
          value: "app-svc:3000"
        volumeMounts:
        - name: config-volume
          mountPath: /home/nginx
      volumes:
      - name: config-volume
        configMap:
          name: nginx-config

```
#### Senario

```html
1. Create ConfigMap,Deployment
   kubectl apply -f weblog-web-deployment.yml

2. Check Web Server's Pod ip (check pod $nginx ip )
   kubectl get pod -o wide

3. Access debug pod
   kubectl exec -it debug sh

4. Check Web Server's either pod
   curl $NginxPod IP

5. Delete ConfigMap,Deployment
   kubectl delete -f weblog-web-deployment.yml
```

### 17.Build Web Server(Service)
ROOT  \
  weblog-web-fullset.yml

```yml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: default
  labels:
    app: weblog
    type: frontend
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: weblog
    type: frontend

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: default
  labels:
    app: weblog
    type: frontend
data:
  nginx.conf: |
    user  nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;


    events {
        worker_connections  1024;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;

        keepalive_timeout  65;

        server_tokens   off;

        proxy_cache_path /var/cache/nginx keys_zone=STATIC:10m max_size=1g inactive=10d;
        proxy_temp_path  /var/cache/nginx/tmp;

        server {
            listen        80;

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            location / {
                proxy_pass http://${APPLICATION_HOST}/;
            }

            location /public/ {
                proxy_pass http://${APPLICATION_HOST}/public/;
                proxy_ignore_headers Cache-Control Expires;
                proxy_buffering on;
                proxy_cache STATIC;
                proxy_cache_valid any 10d;
                add_header X-Nginx-Cache $upstream_cache_status;
            }
        }

        # include /etc/nginx/conf.d/*.conf;
        # ConfigMap
    }

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: default
  labels:
    app: weblog
    type: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: weblog
      type: frontend
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  revisionHistoryLimit: 14
  template:
    metadata:
      name: nginx
      namespace: default
      labels:
        app: weblog
        type: frontend
    spec:
      containers:
      - name: nginx
        image: weblog-web:v1.0.0
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        env:
        - name: "APPLICATION_HOST"
          value: "app-svc:3000"
        volumeMounts:
        - name: config-volume
          mountPath: /home/nginx
      volumes:
      - name: config-volume
        configMap:
          name: nginx-config

```
#### Senario

```html
1. Create Config,Deployment
   kubectl apply -f weblog-web-fullset.yml
   kubectl get pod,svc

2. Access debug pod
   kubectl exec -it debug sh

3. Check can access web server's service
   curl http://web-svc
```

### 18.Publish Web Server(Ingress)
ROOT
  weblog-ingress.yml
```yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: entrypoint
  namespace: default
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  labels:
    app: weblog
    type: entrypoint
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
          serviceName: web-svc
          servicePort: 80
```
#### Senario

```html
1. Create Ingress
   kubectl apply -f weblog-ingress.yml
   kubectl get ing

2. Access minikube(From brower)
   $IP
```

### Those stuff from MOOC



