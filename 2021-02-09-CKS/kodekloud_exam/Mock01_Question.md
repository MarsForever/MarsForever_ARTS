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

#### No.02

A pod has been created in the `orion` namespace. It uses secrets as environment variables. Extract the decoded secret for the `CONNECTOR_PASSWORD` and place it under `/root/CKS/secrets/CONNECTOR_PASSWORD`.

You are not done, instead of using secrets as an environment variable, mount the secret as a read-only volume at path `/mnt/connector/password` that can be then used by the application inside.

```
Weight: 13
```

- pod secured?

- secret mounted as read-only?
- existing secret extracted to file?

#### No.03

A number of pods have been created in the `delta` namespace. Using the `trivy` tool, which has been installed on the controlplane, identify all the pods that have `HIGH` or `CRITICAL` level vulnerabilities and delete the corresponding pods.

Note: Do not modify the objects in anyway other than deleting the ones that have high or critical vulnerabilities.

```
Weight: 12
```

- vulnerable pods deleted?
- non-vulnerable pods running?



#### No.04

Create a new pod called `audit-nginx` in the default namespace using the `nginx` image. Secure the syscalls that this pod can use by using the `audit.json` seccomp profile in the `pod's` security context. The pod should run on node01.

The `audit.json` is provided at `/root/CKS` directory. Make sure to move it under the `profiles` directory inside the default seccomp directory before creating the pod

```
Weight: 12
```

- audit-nginx uses the right image?
- pod running?
- pod uses the correct seccomp profile?

#### No.05

The CIS Benchmark report for the `kube-apiserver` is available at the tab called `CIS Report 1`.

Inspect this report and fix the issues reported as `FAIL`.

```
Weight: 12
```

- apiserver working?

- Issues fixed?

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

#### No.07

A pod called `busy-rx100` has been created in the `production` namespace. Secure the pod by recreating it using the `runtimeClass` called `gvisor`. You may delete and recreate the pod.

Note: As long as the pod is recreated with the correct runtimeClass, the task will be marked correct. This lab environment does not support gvisor at the moment so if the pod is not in a running state, ignore it and move on to the next question.

```
Weight: 10
```

- pod secured?

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