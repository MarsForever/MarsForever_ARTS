CPU 2core
memory 3GB
hardice 16GB
OS CentOS 7
password: matsu007

ip -f inet a
192.168.207.129/24

#minikube command
minikube start --vm-driver=none
minikube stop
minikube status
# Create docker and kubernetes Environment
minikube-installer.sh

```sh
#! /bin/sh

# Install "Docker"
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y \
  docker-ce-19.03.1 \
  docker-ce-cli-19.03.1 \
  containerd.io

systemctl enable docker
systemctl start docker

# Install "kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.1/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin

# Install "minikube"
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.2.0/minikube-linux-amd64
chmod +x minikube
install minikube /usr/local/bin
rm -f minikube

# stop firewall
systemctl disable firewalld
systemctl stop firewalld

# Add addons
minikube start --vm-driver=none
minikube addons enable heapster
minikube addons enable ingress
```
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

# Kubernetes basic operation

| Kubernetes | Docker     |
| ---------- | ---------- |
| command    | ENTRYPOINT |
| args       | CMD        |

##create secrets
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
docker build -t weblog-db:v1.0.0 .
docker run -d weblog-db:v1.0.0
docker container ls
docker exec -it romantic_panini(image:weblog-db:v1.0.0) sh
mongo
show dbs
exit;exit
docker stop romantic_panini
docker system prune
### 3.Build DB Server(Storage)
#### Workflow
1. Create pv,pvc
2. Check created resource
ROOT
weblog-db-storage.yml

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
1. create pv,pvc,pod
2. check created file
3. login to created pod
4. access to mongo db
ROOT
weblog-db-pod.yml(pv and pvc is similar to weblog-db-storage.yml )
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
#### clean resource
kubectl delete -f weblog-db-pod.yml

### 5.Build DB Server(Pod + Secret)
#### Workflow
1. create keyfile(random string)
2. create secret source
3. get yaml file of secret resouce 
4. merge weblog-db-pod.yml
5. delete secret resource
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
ls /data/storage
rf -rf /data/storage/*
ls /data/storage

kubectl get pod

kubectl exec -it mongodb sh
mongo
##### can't show
show dbs
use admin
db.auth("admin","Passw0rd")
show dbs

ROOT
keyfile
weblog-db-pod.yml


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
rs.initiate({
...id:"rs0",
...members: [
...{_id: 0, host:"mongo-0.db-svc:27017"},
...{_id: 1, host:"mongo-1.db-svc:27017"},
...{_id: 2, host:"mongo-1.db-svc:27017"},
...]
...}]
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
#### Check there is primary and secondary
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
##### will show weblog dbs
show dbs
use weblog
show collections
##### will show datas
posts
privileges
users

db.posts.find().pretty()
### 9.Create AP Server image 
ROOT(All file in same folder)
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
0. create image
docker build -t weblog-app:v1.0.0 .
1. check MongoDB
kubectl exec -it mongo-0 sh
use admin
db.auth("admin","Passw0rd")
##### can check which pod is primary or secondary
rs.status()

2. create service,endpoints for MongoDB(kubectl apply)
kubectl apply -f weblog-db-service.yml

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
### 10.Build AP Server(Pod + Secret)

### 11.Build AP Server(Deployment)

### 12.Build AP Server(Service)

### 13.Create Web Server image

### 14.Build Web Server(Pod)

### 15.Build Web Server(Pod + ConfigMap)

### 16.Build Web Server(Deployment)

### 17.Build Web Server(Service)

### 18.Publish Web Server(Ingress)
