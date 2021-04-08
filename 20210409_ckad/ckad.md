### Lighting Lab1

#### No.1

> Welcome to the *KodeKloud CKAD Lightning Lab - Part 1!*
>
> THis environment is only valid for *30 minutes*,You have *5 questions* to complete within this time.

> You can toggle beween the questions but make sure that that you click on *END EXAM* before the *30 minute* mark. To pass,correcty complete at least 4 out of 5 questions.

> Good Luck!!!

- Proceed to next question to begin the lab!

#### No.2

> We have deployed a new pod called *secure-pod* and a service called *sercure-service*. Incoming or Outgoing connections to this pod are not working. Troubleshoot why this is happening.

> Make sure that incoming connection from the pod  *webapp-color* are succesful.

> Important: Don't delete any current objects deployed.

- Important: Don't Alter Existing Objects!
- Connectivity working?

*Weight: 20*



#### No.3

> We have deployed a new pod called *secure-pod* and a service called *secure-service*. Incoming or Outgoing connections to this pod are not working.

> Troubleshoot why this is happening.

> Make sure that incoming connection from the pod *webapp-color* are successful.

> Important:Don't delete any current objects deployed.

- Important:Don't Alter Existing Objects!
- Connectivity working?

#### No.4

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

#### No.5

> Create a new deployment called *nginx-deploy*, with one single container called *nginx*,image *nginx:1.16* and *4* replicas. The deployment should use *RollingUpdate* strategy with *maxSurge=1*, and *maxUnavailable=2*. Next upgrade the deployment to version *1.17* using rolling update.

> Finally, once all pods are updated,undo the update and go back to the prviouse version

- Deplyment created correctly?
- Was the deployment created with nginx:1.16?
- Was it upgraded to 1.17?
- Deployent rolled back to 1.16?

*weight:20*

#### No.6

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

#### No.6

#### No.7

#### No.8

#### No.9

#### No.10

#### No.11

#### No.12

#### No.13

#### No.14



### Mock Exam 2



