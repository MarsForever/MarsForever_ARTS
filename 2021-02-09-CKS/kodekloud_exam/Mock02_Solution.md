#### No.1

A pod called `redis-backend` has been created in the `prod-x12cs` namespace. It has been exposed as a service of type `ClusterIP`. Using a network policy called `allow-redis-access`, lock down access to this pod only to the following:

1. Any pod in the same namespace with the label `backend=prod-x12cs`.
2. All pods in the `prod-yx13cs` namespace.
      All other incoming connections should be blocked.

Use the `existing labels` when creating the network policy.

- Network Policy applied on the correct pods?
- Incoming traffic allowed from pods in prod-yx13cs namespace?
- Incoming traffic allowed from pods with label backend=prod-x12cs ?

#### Solution

Create a network policy using the YAML below:

```sh
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-redis-access
  namespace: prod-x12cs
spec:
  podSelector:
    matchLabels:
      run: redis-backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          access: redis
    - podSelector:
        matchLabels:
          backend: prod-x12cs
    ports:
    - protocol: TCP
      port: 6379
```



#### No.2

A few pods have been deployed in the `apps-xyz` namespace. There is a pod called `redis-backend` which serves as the backend for the apps `app1` and `app2`. The pod called `app3` on the other hand, does not need access to this `redis-backend` pod. Create a network policy called `allow-app1-app2` that will only allow incoming traffic from `app1` and `app2` to the `redis-pod`.



> Make sure that all the available `labels` are used correctly to target the correct pods. Do not make any other changes to these objects.

- Network Policy created on correct pods?
- app1 ingress allowed?
- app2 ingress allowed?
- app3 ingress not allowed?

#### Solution

Create a new network policy using the sample YAML file below:

```sh
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-app1-app2
  namespace: apps-xyz
spec:
  podSelector:
    matchLabels:
      tier: backend
      role: db
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: app1
          tier: frontend
    - podSelector:
        matchLabels:
          name: app2
          tier: frontend
```





#### No.3

A pod has been created in the `gamma` namespace using a service account called `cluster-view`. This service account has been granted additional permissions as compared to the default service account and can `view` resources cluster-wide on this Kubernetes cluster. While these permissions are important for the application in this pod to work, the secret token is still mounted on this pod.

> Secure the pod in such a way that the secret token is no longer mounted on this pod. You may delete and recreate the pod.

- Pod created with `cluster-view` service account?
- secret token not mounted in the pod?

#### Solution

Update the Pod to use the field `automountServiceAccountToken: false`

Using this option makes sure that the service account token secret is not mounted in the pod at the location `/var/run/secrets/kubernetes.io/serviceaccount`

Sample YAML shown below:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: apps-cluster-dash
  name: apps-cluster-dash
  namespace: gamma
spec:
  containers:
  - image: nginx
    name: apps-cluster-dash
  serviceAccountName: cluster-view
  automountServiceAccountToken: false
```

#### No.4

A pod in the `sahara` namespace has generated alerts that a shell was opened inside the container.

Change the format of the output so that it looks like below:
`ALERT` `timestamp of the event without nanoseconds`,`User ID`,`the container id`,`the container image repository`
Make sure to update the rule in such a way that the changes will persists across Falco updates.

> You can refer the `falco` documentation [Here](https://falco.org/docs/rules/supported-fields/) 

- Rules updated according to the new format?
- Falco Running?

#### Solution

Add the below rule to `/etc/falco/falco_rules.local.yaml` and restart falco to override the current rule.

```yaml
- rule: Terminal shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal.
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    %evt.time.s,%user.uid,%container.id,%container.image.repository
  priority: ALERT
  tags: [container, shell, mitre_execution]
```

Use the falco documentation the use the correct sysdig filters in the output.

For example, the evt.time.s filter prints the timestamp for the event without nano seconds. This is clearly described in the falco documentation here - https://falco.org/docs/rules/supported-fields/#evt-field-class

#### No.5

`martin` is a developer who needs access to work on the `dev-a`, `dev-b` and `dev-z` namespace. He should have the ability to carry out any operation on any `pod` in `dev-a` and `dev-b` namespaces. However, on the `dev-z` namespace, he should only have the permission to `get` and `list` the pods.

> The current set-up is too permissive and violates the above condition. Use the above requirement and secure martin's access in the cluster. You may re-create objects, however, make sure to use the same name as the ones in effect currently.

- martin has unrestricted access to all pods in dev-a ?
- martin has unrestricted access to all pods in dev-b ?
- martin can only list and get pods in dev-z ?

#### Solution

The role called `dev-user-access` has been created for all three namespaces: `dev-a`, `dev-b` and `dev-z`. However, the role in the 'dev-z' namespace grants martin access to all operation on all pods. To fix this, delete and re-create the role using the following YAML:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: dev-user-access
    namespace: dev-z
rules:
    -
        apiGroups:
            - ""
        resources:
            - pods
        verbs:
            - get
            - list
```

#### No.6

On the controlplane node, an unknown process is bound to the port 8088. Identify the process and prevent it from running again by stopping and disabling any associated services. Finally, remove the package that was responsible for starting this process.

- port 8088 free ?
- associated service stopped and disabled?
- associated package removed?

#### Solution

Check the process which is bound to port 8088 on this node using netstat:

```sh
controlplane $ netstat -natulp | grep 8088
```

This shows that the the process openlitespeed is the one which is using this port. Check if any service is running with the same name:

```sh
controlplane $ systemctl list-units  -t service --state active | grep -i openlitespeed
lshttpd.service                    loaded active running OpenLiteSpeed HTTP Server
```

This shows that a service called openlitespeed is managed by lshttpd.service which is currently active.

Next, stop the service and disable it:

```sh
controlplane $ systemctl stop lshttpd
controlplane $ systemctl disable lshttpd
```

Finally, check for the package by the same name:

```sh
controlplane $ apt list --installed | grep openlitespeed
```

Uninstall the package:

```sh
controlplane $ apt remove openlitespeed -y
```

#### No.7

A pod has been created in the `omega` namespace using the pod definition file located at `/root/CKS/omega-app.yaml`. However, there is something wrong with it and the pod is not in a running state.

We have used a custom seccomp profile located at `/var/lib/kubelet/seccomp/custom-profile.json` to ensure that this pod can only make use of limited syscalls to the Linux Kernel of the host operating system. However, it appears the profile does not allow the `read` and `write` syscalls. Fix this by adding it to the profile and use it to start the pod.



- pod running?
- pod uses the correct seccomp profile?
- seccomp profile allows 'read' and 'write' syscalls?

#### Solution

The path to the seccomp profile is incorrectly specified for the omega-app pod. As per the question, the profile is created at `/var/lib/kubelet/seccomp/custom-profiles.json`

```sh
controlplane $ kubectl -n omega describe omega-app
.
.
.
Events:
  Type     Reason  Age              From             Message
  ----     ------  ----             ----             -------
  Normal   Pulled  5s (x3 over 7s)  kubelet, node01  Container image "hashicorp/http-echo:0.2.3" already present on machine
  Warning  Failed  5s (x3 over 7s)  kubelet, node01  Error: failed to generate security options for container "test-container": failed to generate seccomp security options for container: cannot load seccomp profile "/var/lib/kubelet/seccomp/profiles/custom-profile.json": open /var/lib/kubelet/seccomp/profiles/custom-profile.json: no such file or directory
```

Fix the seccomp profile path in the POD Definition file:

```yaml
securityContext:
      seccompProfile:
        localhostProfile: custom-profile.json
        type: Localhost
```

Next, update the custom-profile.json to allow 'read' and 'write' syscalls. Once done, you should see an output similar to below:

```sh
controlplane $ cat /var/lib/kubelet/seccomp/custom-profile.json | jq -r '.syscalls[].names[]' | grep -w write
write

controlplane $ cat /var/lib/kubelet/seccomp/custom-profile.json | jq -r '.syscalls[].names[]' | grep -w read 
read
```

Finally, re-create the pod

```sh
controlplane $ kubectl replace -f /root/CKS/omega-app.yaml
```

The POD should now run successfully.

**NOTE:** It may still run even if the above two syscalls are not added. However, adding the syscalls is required to successfully complete this question.

#### No.8

A pod definition file has been created at /root/CKS/simple-pod.yaml . Using the kubesec tool, generate a report for this pod definition file and fix the major issues so that the subsequent scan report no longer fails.

Once done, generate the report again and save it to the file /root/CKS/kubesec-report.txt

- pod definition file fixed?
- report generated at /root/CKS/kubesec-report.txt ?

#### Solution

Remove the SYS_ADMIN capability from the container for the `simple-webapp-1` pod in the POD definition file and re-run the scan.

```sh
controlplane $ kubesec scan /root/CKS/simple-pod.yaml > /root/CKS/kubesec-report.txt
```

The fixed report should PASS with a message like this:

```yaml
[
  {
    "object": "Pod/simple-webapp-1.default",
    "valid": true,
    "fileName": "API",
    "message": "Passed with a score of 3 points",
    "score": 3,
  },
.
.
.
```

#### No.9

Create a new pod called `secure-nginx-pod` in the `seth` namespace. Use one of the images from the below which has no `CRITICAL` vulnerabilities.

 nginx
 nginx:1.19
 nginx:1.17
 nginx:1-alpine
 gcr.io/google-containers/nginx
 bitnami/nginx:latest

- pod created?

#### Solution

Run trivy image scan on all of the images and check which one does not have `HIGH` or `CRITICAL` vulnerabilities.

```sh
controlplane $ trivy image nginx:1-alpine
2021-09-04T17:59:37.700Z        INFO    Detecting Alpine vulnerabilities...
2021-09-04T17:59:37.702Z        INFO    Trivy skips scanning programming language libraries because no supported file was detected

nginx:1-alpine (alpine 3.14.2)
==============================
Total: 0 (UNKNOWN: 0, LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0)
```

Next, use this image to create the pod

```sh
controlplane $ kubectl -n seth run secure-nginx-pod --image nginx:1-alpine
```