### Mock Exam 1

### Question

#### No.01 

A kube-bench report is available at the `Kube-bench assessment report` tab. Fix the tests with `FAIL` status for `4 Worker Node Security Configuration` .

Make changes to the `/var/lib/kubelet/config.yaml`

After you have fixed the issues, you can update the published report in the `Kube-bench assessment report` tab by running `/root/publish_kubebench.sh` to validate results.

- authorization mode is not AlwaysAllow?
- Enabled protectKernelDefaults?

#### No.02

Enable auditing in this kubernetes cluster. Create a new policy file that will only log events based on the below specifications:

Namespace: `prod`
Level: `metadata`
Operations: `delete`
Resources: `secrets`
Log Path: `/var/log/prod-secrets.log`
Audit file location: `/etc/kubernetes/prod-audit.yaml`
Maximum days to keep the logs: `30`

Once the policy is created it, enable and make sure that it works.



- Auditing Enabled?
- Correct Log Path Used?
- Correct log retention set?
- Policy working as expected?

#### No.03

\- Enable `PodSecurityPolicy` in the Kubernetes API server.

\- Create a PSP with below conditions:

1. PSP name : `pod-psp`
2. Privilege to run as root on host: `false`
3. Allowed volumes to mount on pod: `configMap,secret,emptyDir,hostPath`
4. seLinux, runAsUser, supplementalGroups, fsGroup: `RunAsAny`

\- Fix the pod definition `/root/pod.yaml` based on this PSP and deploy the pod. Ensure that the pod is running after applying the above pod security policy.



- PSP created?
- PSP created with privileged false?
- Correct volumes added to PSP?
- Pod psp-app running?
- Pod with privileged false created?
- Capabilities removed from pod?

#### No.04

We have a pod definition template `/root/kubesec-pod.yaml` on `controlplane` host. Scan this template using the `kubesec` tool and you will notice some failures.

Fix the failures in this file and save the success report in `/root/kubesec_success_report.json`.

Make sure that the final kubesec scan status is `passed`.



- Template is scanned and report saved ?
- kubesec-pod.yaml fixed?

#### No.05

In the `dev` namespace create below resources:

\- A role `dev-write` with access to get, watch, list and create pods in the same namespace.

\- A Service account called `developer` and then bind `dev-write` role to it with a rolebinding called `dev-write-binding`.

\- Finally, create a pod using the template `/root/dev-pod.yaml`. The pod should run with the service account `developer`. Update `/root/dev-pod.yaml` as necessary



- dev-write role created?
- dev-write role created for pods?
- dev-write role created for correct permissions?
- developer serviceaccount created?
- RoleBinding created?
- RoleBinding created with correct role and serviceaccount?
- dev-pod created with correct serviceAccount?

#### No.06

Try to create a pod using the template defined in `/root/beta-pod.yaml` in the namespace `beta`. This should result in a failure.
Troubleshoot and fix the OPA validation issue while creating the pod. You can update `/root/beta-pod.yaml` as necessary.



The Rego configuration map for OPA is in `untrusted-registry` under `opa` namespace.

NOTE: In the end pod need not to be successfully running but make sure that it passed the OPA validation and gets created.



- Pod created as per OPA policy?

#### No.07



#### No.08

