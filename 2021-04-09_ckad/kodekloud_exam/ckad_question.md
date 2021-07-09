### Lighting Lab1
#### Description

> Welcome to the *KodeKloud CKAD Lightning Lab - Part 1!*
>
> THis environment is only valid for *30 minutes*,You have *5 questions* to complete within this time.

> You can toggle beween the questions but make sure that that you click on *END EXAM* before the *30 minute* mark. To pass,correcty complete at least 4 out of 5 questions.

> Good Luck!!!

- Proceed to next question to begin the lab!

#### No.1

> Create a Persistent Volume called `log-volume`. It should make use of a `storage class` name `manual`. It should use `RWX` as the access mode and have a size of `1Gi`. The volume should use the hostPath `/opt/volume/nginx`

> Next, create a PVC called `log-claim` requesting a minimum of `200Mi` of storage. This PVC should bind to `log-volume`.

> Mount this in a pod called `logger` at the location `/var/www/nginx`. This pod should use the image `nginx:alpine`.

*Weight: 20* 

#### No.2

> We have deployed a new pod called *secure-pod* and a service called *sercure-service*. Incoming or Outgoing connections to this pod are not working. Troubleshoot why this is happening.

> Make sure that incoming connection from the pod  *webapp-color* are succesful.

> Important: Don't delete any current objects deployed.

- Important: Don't Alter Existing Objects!
- Connectivity working?

*Weight: 20*



#### No.3

> Create a pod called *time-check* in the *dvl1987* namespace.This pod should run a container called *timer-check* that users the *busybox* image.

1. Create a config map called *time-config* with the data *TIME_FREQ* = 10 in the same spacespace.

2. THe *time-check* container should run the command:

   ```shell 
while true; do date; sleep
   $TIME_FREQ;done and write the result to the location
   /opt/time/time-check, log.
   ```
   
3. The path */opt/time* on the pod should mount a volume that lasts the lifetime of this pod.

- Pod 'time-check' configured correctly?

*Weight: 20*

#### No.4

> Create a new deployment called *nginx-deploy*, with one single container called *nginx*,image *nginx:1.16* and *4* replicas. The deployment should use *RollingUpdate* strategy with *maxSurge=1*, and *maxUnavailable=2*. Next upgrade the deployment to version *1.17* using rolling update.

> Finally, once all pods are updated,undo the update and go back to the prviouse version

- Deplyment created correctly?
- Was the deployment created with nginx:1.16?
- Was it upgraded to 1.17?
- Deployent rolled back to 1.16?

*weight:20*

#### No.5

> Create a *redis* deployment with the following parameters: Name of the deployment should be *redis* using the *redis:alpine* image.It should have *1* replica. Thecontainer should request for *2* CPU.It should use the label *app=redis*.
>
> It should mount exactly 2 volumes:
>
> Make sure that the pod is scheduled on *master* node.

> a. An Empty directory volume called *data* at path *redis-master-data*.
>
> b. A configmap volume called *redis-config* at path */redis-master*.
>
> c. The container should expose the port *6379*.

> The configmap has already been created.

*weight:20*



### Lighting Lab2 

#### No.1

> Welcome to the *KodeKloud CKAD Lightning Lab - Part 2!*
>
> This environment is only valid for *30 minutes*.You have *5 questions* to complete within this time.
>
> You cant toggle between the questions but make sure that that you click on *END EXAM* before the *30 minute* mark. TO pass, you must secure *80%*.

> Good Luck!!!

- Proceed to next question to begin the lab!



#### No.2

> We have deployed a few pods in this cluster in various namespaces.Inspect them and identify the pod which is not in a *Ready*   state.Troubleshoot and fix the issue.

> Next, add a check restart the container on the same pod if the command *ls /var/www/html/file_check* fails. This check should start after a delay of *10 seconds* and run *every 60 seconds*.

> You may delete and recreate the object.Ignore the warnings from the probe.

- Task completed correctly?

*Weight: 20*

#### No.3

> Create a cronjob called *dice* that runs every *one minute*.Use the Pod template located at */root/throw-a-dice*.
>
> The image *throw-dice* randomly returns a value between 1 and 6.The result of 6 is considered success and all others are *failure*.
>
> The job should be *non-parallel* and complete the task *once*.Use *backoffLimit* of *25*.
>
> If the task is not completed within *20 seconds* the job should fail and pods should be terminated.

> You don't have to wait for the job completion.As long as the cronjob has been created as per the requirements.

*Weight: 20*

- Cronjob created correctly?

#### No.4

> Create a pod called *my-busybox* in the *dev2406* namespace using the *busybox* image. Thecontainer should be called *secret* and should sleep for *3600* seconds.

> The container should mount a *read-only* secret volume called *secret-volume* at the path */etc/secret-volume*.The secret being mounted has already been created for you and is called *dotfile-secret*.

> Make sure that the pod is scheduled on *master* and no other node in the cluster.

*Weight: 20*

- Pod created correctly?

#### No.5

> Create a single ingress resource called *ingress-vh-routing*.The resource should route HTTP traffic to multiple hostnames as specified below.

1. The service *video-service* should be accessible on *http://watch.ecom-store.com:30093/video*
2. The service *apparels-serivce* should be accessible on *http://apparels.ecom-store.com:30093/wear*

> Here *30093* is the port used by the *Ingress Controller*

- Ingress resource configured correctly?

*Weight:20*

#### No.6

> A pod called *dev-pod-dind-878516* has been deployed in the default namespace. Inspect the logs for the container called *log-x* and redirect the warnings to */opt/dind-878516_logs.txt* on the *master* node

*Weight:20*

- Redirect warning to file

### Mock Exam 1

#### No.1

> Deploy a pod named *nginx-448839* using the *nginx:alpine* image.

> Once done,click on the *Next Question* button in the top right corner of this panel.
>
> You may navigate back and forth freely between all questions.Once done with all qustions, click on *End Exam*.Your work will be validated at the end and score shown.

> Good Luck!

- Name: nginx-448839
- Image: nginx:alpine

*Weight: 3*

#### No.2

> Create a namespace named *apx-z993845*

*Weight: 4*

- Namespace:apx-z993845

#### No.3

> Create a new Deployment named *httpd-fronted* with 3 replicas using image *httpd:2.4-alpine*

*Wiehgt : 6*

- Name: httpd-fronted
- Replicas: 3
- Image: httpd:2.4-alpine

#### No.4

> Deploy a *messaging* pod using the *redis:alpine* image with the labels set to *tier_msg*.

- Pod Name: messaging
- Image: redis:alpine
- Lable: tier_msg



#### No.5

> A replicaset rs-d33393 is created. However the pods are not coming up. Identify and fix the issue.
>
> Once fixed, ensure the ReplicaSet has 4 *Ready* relicas.

*Weight: 7*

* Rreplicas: 4

#### No.6

> Create a service *messaging-service* to expose the *redis* deployment in. the *marketing* namespace within the cluster on the port *6379*.

> Use imperative commands

*Weight: 11*

- Service: messaging-service
- Port:6379
- Use the right type of Service
- Use the right labels

#### No.7

> Update the environment variable on the pod *webapp-color* to use a *green* background

*Weight: 8*

- Pod Name:webapp-color
- Label Name:webapp-color
- Env: APP_COLOR=green

#### No.8

> Create a new ConfigMap named *cm-3392845*.Use the spec given on the right.

*Weight: 12*

- ConfigName: cm-3392845
- Data: DB_NAME=SQL3322
- Data: DB_HOST=sql322.mycompany.com
- Data: DB_PORT = 3306

#### No.9

> Create new Secret named *db-secret-xxdf* with the data given (on the right).

*Weight: 13*

- Secret Name: db-secret-xxdf
- Secret 1: DB_Host=sql01
- Secret 2: DB_User = root
- Secret 3: DB_Password = Password123

#### No.10

> Update pod *app-sec-kff3345* to run as Root user and with the *SYS_TIME* capability.

*Weight: 5*

- Pod Name: app-sec-kff3345
- Image Name:ubuntu
- SecurityContext: Capability SYS_TIME

#### No.11

> Export the logs of the *e-com-1123* pod to the File */opt/output/e-com-1123.logs*

> It is in a different namespace. Identify the namespace first.

*Weight: 8*

- Task Completed

#### No.12

> Create a *Persistent Volume* with the given specification.

*Weight: 7*

- Volume Name: pv-analytics
- Storage: 100Mi
- Access modes: ReadWriteMany
- Host Path: /pv/data-analytics

#### No.13

> Create a *redis* deployment using the image *redis:alpine* with 1 *replica* and label *app=redis*. Expose it via ClusterIP service called *redis* on port 6379.
>
> Create a new *Ingress Type* NetworkPolicy called *redis-access* which allows only the pods with label *access=redis* to access the dployment.

*Weight: 6*

- Image:redis:alpine
- Deployment created correctly?
- Service created correctly?
- Network Policy allows the correct pod?
- Network Policy applied on the correct pods?

#### No.14

> Create a Pod called *sega* with two containers:
>
> ​	1.Container 1: Name *tails* with image *busybox* and command: *sleep 3600*.
>
> ​    2.Container 2: Name *sonic* with image *nginx* and Environment variable: *NGINX_PORT* with the value *8080*.

*Weight: 5*

- Container Sonic has the correct ENV name
- Container Sonic has the correct ENV value
- Container tails created correctly?

### Mock Exam 2

### No.01

> Create a deployment called *my-webapp* with image: *nginx*, label *tier:frontend* and *2* replicas. Expose the deployment as a NodePort service with name *front-end-service*, port:*80* and NodePort:*30083*

*Weight: 8*

- Deployment my-webapp created?
- image:nginx
- Replicas= 2?
- service front-end -service created ?
- service Type created correctly?
- Correct node Port used?

### No.02

> Add a taint to the node *node01* of the cluster. Use the specification below:
>
> key: *app_type*,value: *alpha* and effect:  *NoSchedule*
>
> Create a pod called *alpha*, image: *redis* with toleration to node01

*Weight: 12*

- node01 with the correct taint?
- Pod alpha has the correct toleration?

### No.03

> Apply a label *app_type=beta* to node node02. Create a new deployment called *beta-apps* with image: *nginx* and replica:3.
>
> Set Node Affinity to the deployment to place the PODs on node02 only.

> NodeAffinity:requiredDuringSchedulingIgnoredDuringExecution

*Weight: 15*

- node02 has the correct labels?
- Deployment beta-apps:NodeAffinity set to requiredDuringSchedulingIgnoredDuringExecution?
- Deployment beta-apps has correct key for NodeAffinity?
- Deployment beta-apps has correct Value for NodeAffinity?
- Deployment beta-apps has pods running only on node02?
- Deployment beta-apps has 3 pods running?

### No.04

> Create a new Ingress Resource for the service: *my-video-service* to be made available at the URL: *http://ckad-mock-exam-solution.com:30093/video*.

> Create an ingress resource with *host: ckad-mock-exam-solution.com* *path:/video*
>
> Once set up, curl test of the URL from the nodes should be successful / *HTTP 200*

*Weight: 12*

- Ingress resource configured correct and accessible via http://ckad-mock-exam-solution.com:30093/video

### No. 05

> We have deployed a new pod called *pod-with-rprobe*. This Pod has an initial delay before it is Ready. Update the newly created pod *pod-with-rprobe* with a *readinessProbe* using the given spec

- httpGet path: /ready
- httpGet port:8080

*Weight: 12*



### No.06

> Create a job called *whalesay* with image *docker/whalesay* and command *"cowsay I am going to ace CKAD!"*.
>
> completions: *10*
>
> backoffLimit: *6*
>
> restartPolicy: *Never*



> This simple job runs the popular cowsya game that was modified by docker...

*Weight: 15*

- Job "whalesay" uses correct image?

- Job "whalesay" configured with completions = 10 ?

- Job "whalesay" with backoffLimit = 6

- Job runs the command "cowsay I am going to use ace CKAD!?"

- Job "whalesay" completed successfully?

  

### No.07

> Create a pod called *multi-pod* with two containers.
>
> Container 1: name: jupiter,image:nginx
>
> Container 2: europa, image: busybox
>
> command: sleep 4800

> Environment Variables: Container 1: type: planet
>
> Container 2 : type:moon

- Pod Name: multi-pod
- Container 1: jupiter
- Container 2: europa
- Container europa commands set correctly?
- Container 1 Environment Value Set
- Container 2 Environment Value Set



### No.08

> Create a PersistentVolume called *custom-volume* with size: 50 MiB reclaim policy:retain,Access Modes: ReadWriteMany and hostPath: /opt/data

*Weight: 14*

- PV custom-volume created?
- custom-volume uses the correct access mode?
- PV custom-volume has the correct storage capacity?
- PV custom-volume has the correct host path?