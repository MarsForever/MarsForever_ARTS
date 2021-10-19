### Mock Exam 1

### Question

#### No.01 

A pod has been created in the `omni` namespace. However, there are a couple of issues with it.

1. The pod has been created with more permissions than it needs.
2. It allows read access in the directory `/usr/share/nginx/html/internal` causing the `Internal Site` to be accessed (Check the link called `Prohibited Site` above the terminal).
   Use the below recommendations to fix this.

1. Use the AppArmor profile created at `/etc/apparmor.d/frontend` to restrict the internal site.

2. There are several service accounts created in the `omni` namespace. Apply the principle of least privilege and use the service account with the minimum privileges (excluding `default`).

3. Once the pod is recreated with the correct service account, delete the other unused service accounts in `omni` namespace (excluding the `default` service account).

   You can recreate the pod but do not create a new service account and do not use the default service account.



```
Weight: 13
```

- correct service account used?
- obsolete service accounts deleted?
- internal-site restricted?
- pod running?



#### Solution

On the controlplane node, load the AppArmor profile: apparmor_parser -q /etc/apparmor.d/frontend The profile name used by this file is restricted-frontend (open the /etc/apparmor.d/frontend file to check).

To verify that the profile was successfully loaded, use the aa-status command:

```sh
root@controlplane:~# aa-status | grep restricted-frontend
   restricted-frontend
root@controlplane:~#
```

The pod should only use the service account called frontend-default as it has the least privileges of all the service accounts in the omni namespace (excluding default) The other service accounts, fe and frontend have additional permissions (check the roles and rolebindings associated with these accounts)

Use the below YAML File to re-create the frontend-site pod:
```sh
apiVersion: v1
kind: Pod
metadata:
  annotations:
    container.apparmor.security.beta.kubernetes.io/nginx: localhost/restricted-frontend #Apply profile 'restricted-fronend' on 'nginx' container 
  labels:
    run: nginx
  name: frontend-site
  namespace: omni
spec:
  serviceAccount: frontend-default #Use the service account with least privileges
  containers:

  - image: nginx:alpine
    name: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: test-volume
    volumes:
  - name: test-volume
    hostPath:
       path: /data/pages
       type: Directory
```

Next, Delete the unused service accounts in the 'omni' namespace.

```sh
controlplane$ kubectl -n omni delete sa frontend
controlplane$ kubectl -n omni delete sa fe
```
- correct service account used?
- obsolete service accounts deleted?
- internal-site restricted?
- pod running?

#### No.02

A pod has been created in the `orion` namespace. It uses secrets as environment variables. Extract the decoded secret for the `CONNECTOR_PASSWORD` and place it under `/root/CKS/secrets/CONNECTOR_PASSWORD`.

You are not done, instead of using secrets as an environment variable, mount the secret as a read-only volume at path `/mnt/connector/password` that can be then used by the application inside.

```
Weight: 13
```

- pod secured?
- secret mounted as read-only?
- existing secret extracted to file?



#### Solution

To extract the secret, `run: kubectl -n orion get secrets a-safe-secret -o jsonpath='{.data.CONNECTOR_PASSWORD}' | base64 --decode >/root/CKS/secrets/CONNECTOR_PASSWORD`
One way that is more secure to distribute secrets is to mount it as a read-only volume.

Use the following YAML file to recreate the POD with secret mounted as a volume:
```sh
apiVersion: v1
kind: Pod
metadata:
    labels:
        name: app-xyz
    name: app-xyz
    namespace: orion
spec:
    containers:
        -
            image: nginx
            name: app-xyz
            ports:
            - containerPort: 3306
            volumeMounts: 
            - name: secret-volume
              mountPath: /mnt/connector/password
              readOnly: true
    volumes:
    - name: secret-volume
      secret:
        secretName: a-safe-secret
```
#### No.03

A number of pods have been created in the `delta` namespace. Using the `trivy` tool, which has been installed on the controlplane, identify all the pods that have `HIGH` or `CRITICAL` level vulnerabilities and delete the corresponding pods.

Note: Do not modify the objects in anyway other than deleting the ones that have high or critical vulnerabilities.

```
Weight: 12
```

- vulnerable pods deleted?
- non-vulnerable pods running?

#### Solution

First, get all the images of pods running in the delta namespace:

```sh
$ kubectl -n delta get pods -o json | jq -r '.items[].spec.containers[].image'
```


Next, scan each image using trivy image command. For example:

```sh
$ trivy image --severity CRITICAL kodekloud/webapp-delayed-start
```

If the image has CRITICAL vulnerabilities, delete the associated pod.

For example, if kodekloud/webapp-delayed-start, httpd and nginx:1.16 have these vulnerabilities:

```sh
$ kubectl -n delta delete pod simple-webapp-1
$ kubectl -n delta delete pod simple-webapp-3
$ kubectl -n delta delete pod simple-webapp-4
```

Ignore pods which use images of lower severity such as HIGH, MEDIUM, LOW e.t.c

#### No.04

Create a new pod called `audit-nginx` in the default namespace using the `nginx` image. Secure the syscalls that this pod can use by using the `audit.json` seccomp profile in the `pod's` security context. The pod should run on node01.

The `audit.json` is provided at `/root/CKS` directory. Make sure to move it under the `profiles` directory inside the default seccomp directory before creating the pod

```
Weight: 12
```

- audit-nginx uses the right image?
- pod running?
- pod uses the correct seccomp profile?

#### Solution

Copy the audit.json seccomp profile to /var/lib/kubelet/seccomp/profiles on the controlplane node:

```sh
controlplane$ mv /root/CKS/audit.json /var/lib/kubelet/seccomp/profiles
```


Next, recreate the pod using the below YAML File

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: audit-nginx
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: profiles/audit.json
  containers:

  - image: nginx
    name: nginx
```



#### No.05

The CIS Benchmark report for the `kube-apiserver` is available at the tab called `CIS Report 1`.

Inspect this report and fix the issues reported as `FAIL`.

```
Weight: 12
```

- apiserver working?
- Issues fixed?



#### Solution

The fixes are mentioned in the same report. Update the `kube-apiserver` static pod definition file as per the recommendations.

1. Make sure that `--authorization-mode=Node,RBAC`.

#### No.06

There is something suspicious happening with one of the pods running an `httpd` image in this cluster.
The Falco service in `node01` shows frequent alerts that start with: `File below a known binary directory opened for writing`.
Identify the rule causing this alert and update it as per the below requirements:

1. Output should be displayed as: `CRITICAL File below a known binary directory opened for writing (user=user_name file_updated=file_name command=command_that_was_run)`
2. Alerts are logged to `/opt/security_incidents/alerts.log`

Do not update the default rules file directly. Rather use the `falco_rules.local.yaml` file to override.
`Note:` Once the alert has been updated, you may have to wait for up to a minute for the alerts to be written to the new log location.

```
Weight: 13
```

- task completed?

#### Solution

Enable file_output in /etc/falco/falco.yaml on the controlplane node:
```sh
file_output:
  enabled: true
  keep_alive: false
  filename: /opt/security_incidents/alerts.log
```
Next, add the updated rule under the /etc/falco/falco_rules.local.yaml and hot reload the Falco service:
```sh
- rule: Write below binary dir
  desc: an attempt to write to any file below a set of binary directories
  condition: >
    bin_dir and evt.dir = < and open_write
    and not package_mgmt_procs
    and not exe_running_docker_save
    and not python_running_get_pip
    and not python_running_ms_oms
    and not user_known_write_below_binary_dir_activities
  output: >
    File below a known binary directory opened for writing (user=%user.name file_updated=%fd.name command=%proc.cmdline)
  priority: CRITICAL
  tags: [filesystem, mitre_persistence]
```
To perform hot-reload falco use 'kill -1 /SIGHUP':
```sh
$ kill -1 $(cat /var/run/falco.pid)
```
Alternatively, you can also restart the falco service by running:
```sh
$ systemctl restart falco
```
#### No.07

A pod called `busy-rx100` has been created in the `production` namespace. Secure the pod by recreating it using the `runtimeClass` called `gvisor`. You may delete and recreate the pod.

Note: As long as the pod is recreated with the correct runtimeClass, the task will be marked correct. This lab environment does not support gvisor at the moment so if the pod is not in a running state, ignore it and move on to the next question.

```
Weight: 10
```

- pod secured?



#### Solution


Use the below YAML file to create the pod with the gvisor runtime class:
```sh
apiVersion: v1
kind: Pod
metadata:
    labels:
        run: busy-rx100
    name: busy-rx100
    namespace: production
spec:
    runtimeClassName: gvisor
    containers:
        -
            image: nginx
            name: busy-rx100
```



#### No.08

We need to make sure that when pods are created in this cluster, they cannot use the `latest` image tag, irrespective of the repository being used.
To achieve this, a simple Admission Webhook Server has been developed and deployed. A service called `image-bouncer-webhook` is exposed in the cluster internally. This Webhook server ensures that the developers of the team cannot use the latest image tag. Make use of the following specs to integrate it with the cluster using an `ImagePolicyWebhook`:

1. Create a new admission configuration file at `/etc/kubernetes/admission-configuration.yaml`
2. The `kubeconfig` file with the credentials to connect to the webhook server is located at `/root/CKS/ImagePolicy/Admission-kubeconfig.yaml`. Note: The directory `/root/CKS/ImagePolicy/` has already been mounted on the `kube-apiserver` at path `/etc/admission-controllers` so use this path to store the admission configuration.
3. Make sure that if the latest tag is used, the request must be rejected at all times.
4. Enable the Admission Controller.

Finally, delete the existing pod in the `magnum` namespace that is in violation of the policy and recreate it, ensuring the same image but using the tag `1.27`.

```
Weight: 15
```

- ImagePolicyWebhook enabled and API server running?
- policy implemented?
- pod recreated with the correct image?
- pod running?

#### Solution

Create the below admission-configuration inside /root/CKS/ImagePolicy directory in the controlplane node:

```sh
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:

- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/admission-controllers/admission-kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false
```
The /root/CKS/ImagePolicy is mounted at the path /etc/admission-controllers directory in the kube-apiserver. So, you can directly place the files under /root/CKS/ImagePolicy. Here is a snippet of the volume and volumeMounts (already added to apiserver config):

```sh
  containers:
  .
  .
  .
  volumeMounts:
  
  - mountPath: /etc/admission-controllers
      name: admission-controllers
      readOnly: true
  
  volumes:
  - hostPath:
      path: /root/CKS/ImagePolicy/
      type: DirectoryOrCreate
    name: admission-controllers
```
Next, update the kube-apiserver command flags and add ImagePolicyWebhook to the enable-admission-plugins flag. Use the configuration file that was created in the previous step as the value of `admission-control-config-file`.

Note: Remember, this command will be run inside the kube-apiserver container, so the path must be `/etc/admission-controllers/admission-configuration.yaml` (mounted from /root/CKS/ImagePolicy in controlplane)

    - --admission-control-config-file=/etc/admission-controllers/admission-configuration.yaml
    - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook