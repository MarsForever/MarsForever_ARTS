#### No.1

A pod called `redis-backend` has been created in the `prod-x12cs` namespace. It has been exposed as a service of type `ClusterIP`. Using a network policy called `allow-redis-access`, lock down access to this pod only to the following:

1. Any pod in the same namespace with the label `backend=prod-x12cs`.
2. All pods in the `prod-yx13cs` namespace.
      All other incoming connections should be blocked.

Use the `existing labels` when creating the network policy.

- Network Policy applied on the correct pods?
- Incoming traffic allowed from pods in prod-yx13cs namespace?
- Incoming traffic allowed from pods with label backend=prod-x12cs ?

#### No.2

A few pods have been deployed in the `apps-xyz` namespace. There is a pod called `redis-backend` which serves as the backend for the apps `app1` and `app2`. The pod called `app3` on the other hand, does not need access to this `redis-backend` pod. Create a network policy called `allow-app1-app2` that will only allow incoming traffic from `app1` and `app2` to the `redis-pod`.



> Make sure that all the available `labels` are used correctly to target the correct pods. Do not make any other changes to these objects.

- Network Policy created on correct pods?
- app1 ingress allowed?
- app2 ingress allowed?
- app3 ingress not allowed?

#### No.3

A pod has been created in the `gamma` namespace using a service account called `cluster-view`. This service account has been granted additional permissions as compared to the default service account and can `view` resources cluster-wide on this Kubernetes cluster. While these permissions are important for the application in this pod to work, the secret token is still mounted on this pod.

> Secure the pod in such a way that the secret token is no longer mounted on this pod. You may delete and recreate the pod.

- Pod created with `cluster-view` service account?
- secret token not mounted in the pod?

#### No.4

A pod in the `sahara` namespace has generated alerts that a shell was opened inside the container.

Change the format of the output so that it looks like below:
`ALERT` `timestamp of the event without nanoseconds`,`User ID`,`the container id`,`the container image repository`
Make sure to update the rule in such a way that the changes will persists across Falco updates.

> You can refer the `falco` documentation [Here](https://falco.org/docs/rules/supported-fields/) 



- Rules updated according to the new format?
- Falco Running?

#### No.5

`martin` is a developer who needs access to work on the `dev-a`, `dev-b` and `dev-z` namespace. He should have the ability to carry out any operation on any `pod` in `dev-a` and `dev-b` namespaces. However, on the `dev-z` namespace, he should only have the permission to `get` and `list` the pods.

> The current set-up is too permissive and violates the above condition. Use the above requirement and secure martin's access in the cluster. You may re-create objects, however, make sure to use the same name as the ones in effect currently.

- martin has unrestricted access to all pods in dev-a ?
- martin has unrestricted access to all pods in dev-b ?
- martin can only list and get pods in dev-z ?

#### No.6

On the controlplane node, an unknown process is bound to the port 8088. Identify the process and prevent it from running again by stopping and disabling any associated services. Finally, remove the package that was responsible for starting this process.

- port 8088 free ?
- associated service stopped and disabled?
- associated package removed?



#### No.7

A pod has been created in the `omega` namespace using the pod definition file located at `/root/CKS/omega-app.yaml`. However, there is something wrong with it and the pod is not in a running state.

We have used a custom seccomp profile located at `/var/lib/kubelet/seccomp/custom-profile.json` to ensure that this pod can only make use of limited syscalls to the Linux Kernel of the host operating system. However, it appears the profile does not allow the `read` and `write` syscalls. Fix this by adding it to the profile and use it to start the pod.



- pod running?
- pod uses the correct seccomp profile?
- seccomp profile allows 'read' and 'write' syscalls?



#### No.8

A pod definition file has been created at /root/CKS/simple-pod.yaml . Using the kubesec tool, generate a report for this pod definition file and fix the major issues so that the subsequent scan report no longer fails.

Once done, generate the report again and save it to the file /root/CKS/kubesec-report.txt

- pod definition file fixed?
- report generated at /root/CKS/kubesec-report.txt ?



#### No.9

Create a new pod called `secure-nginx-pod` in the `seth` namespace. Use one of the images from the below which has no `CRITICAL` vulnerabilities.

 nginx
 nginx:1.19
 nginx:1.17
 nginx:1-alpine
 gcr.io/google-containers/nginx
 bitnami/nginx:latest

- pod created?