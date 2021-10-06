##### 101. Introduction

### Open Policy Agent

- Introduction to OPA and Gatekeeper
- Enforce Labels
- Enforce Pod Replica Count

![](.\images\Section19\Screenshot_1.png)



![](.\images\Section19\Screenshot_2.png)

![](.\images\Section19\Screenshot_3.png)

![](.\images\Section19\Screenshot_4.png)



![](.\images\Section19\Screenshot_6.png)

##### 102. Practice - Install OPA

 - Install OPA Gatekeeper

```sh
#check the admission-plugins
vim /etc/kubernetes/manifests/kube-apiserver.yaml
---
    - --enable-admission-plugins=NodeRestriction
---
#create gatekeeper-system namespace
kubectl create -f https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/opa/gatekeeper.yaml
---
namespace/gatekeeper-system created
Warning: apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
customresourcedefinition.apiextensions.k8s.io/configs.config.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constraintpodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplatepodstatuses.status.gatekeeper.sh created
customresourcedefinition.apiextensions.k8s.io/constrainttemplates.templates.gatekeeper.sh created
serviceaccount/gatekeeper-admin created
role.rbac.authorization.k8s.io/gatekeeper-manager-role created
clusterrole.rbac.authorization.k8s.io/gatekeeper-manager-role created
rolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
clusterrolebinding.rbac.authorization.k8s.io/gatekeeper-manager-rolebinding created
secret/gatekeeper-webhook-server-cert created
service/gatekeeper-webhook-service created
deployment.apps/gatekeeper-audit created
deployment.apps/gatekeeper-controller-manager created
Warning: admissionregistration.k8s.io/v1beta1 ValidatingWebhookConfiguration is deprecated in v1.16+, unavailable in v1.22+; use admissionregistration.k8s.io/v1 ValidatingWebhookConfiguration
validatingwebhookconfiguration.admissionregistration.k8s.io/gatekeeper-validating-webhook-configuration created
---
---
oot@cks-master:~# k get ns
NAME                STATUS   AGE
default             Active   15d
gatekeeper-system   Active   17s
kube-node-lease     Active   15d
kube-public         Active   15d
kube-system         Active   15d
---

root@cks-master:~# k -n gatekeeper-system get pod,svc
NAME                                                 READY   STATUS    RESTARTS   AGE
pod/gatekeeper-audit-6ffc8f5544-nt5mg                1/1     Running   0          99s
pod/gatekeeper-controller-manager-6f9c99b4d7-mwghg   1/1     Running   0          99s

NAME                                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/gatekeeper-webhook-service   ClusterIP   10.96.117.31   <none>        443/TCP   99s

```

##### 103. Practice - Deny All Policy

```sh

root@cks-master:~# k get crd
NAME                                                 CREATED AT
configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
# there is not constrainttemplates ,so can't get the resource
root@cks-master:~# k get constrainttemplates
No resources found


root@cks-master:~# vim templates.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deny-all/alwaysdeny_template.yaml
root@cks-master:~# k -f templates.yaml create
constrainttemplate.templates.gatekeeper.sh/k8salwaysdeny created


root@cks-master:~# k get K8sAlwaysDeny
No resources found


root@cks-master:~# vim constraint.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deny-all/all_pod_always_deny.yaml
root@cks-master:~# k -f constraint.yaml create
k8salwaysdeny.constraints.gatekeeper.sh/pod-always-deny created


root@cks-master:~# k get K8sAlwaysDeny
NAME              AGE
pod-always-deny   41s

#can't create a pod
root@cks-master:~# k run pod --image=nginx
Error from server ([denied by pod-always-deny] ACCESS DENIED!): admission webhook "validation.gatekeeper.sh" denied the request: [denied by pod-always-deny] ACCESS DENIED!

```



##### 104. Practice - Enforce Namespace Labels

- All namespaces created need to have the label 'cks'

  ```sh
  # create template
  vim template.yaml 
  
  https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/namespace-labels/k8srequiredlabels_template.yaml
  
  root@cks-master:~# k -f template.yaml create
  constrainttemplate.templates.gatekeeper.sh/k8srequiredlabels created
  ```

  ```sh
  # create constraints
  vim constraints.yaml
  https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/namespace-labels/all_ns_must_have_cks.yaml
  
  root@cks-master:~# k -f constraints.yaml create
  k8srequiredlabels.constraints.gatekeeper.sh/ns-must-have-cks created
  
  ```

  ```sh
  # show Custom Resources 
  root@cks-master:~# k get crd
  NAME                                                 CREATED AT
  configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
  constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
  constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
  constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
  k8salwaysdeny.constraints.gatekeeper.sh              2021-10-02T16:46:17Z
  k8srequiredlabels.constraints.gatekeeper.sh          2021-10-03T05:27:47Z
  root@cks-master:~# k get k8srequiredlabels
  NAME               AGE
  ns-must-have-cks   49s
  root@cks-master:~# k describe k8srequiredlabels ns-must-have-cks
  Name:         ns-must-have-cks
  Namespace:
  Labels:       <none>
  Annotations:  <none>
  API Version:  constraints.gatekeeper.sh/v1beta1
  Kind:         K8sRequiredLabels
  Metadata:
    Creation Timestamp:  2021-10-03T05:40:43Z
    Generation:          1
    Managed Fields:
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:spec:
          .:
          f:match:
            .:
            f:kinds:
          f:parameters:
            .:
            f:labels:
      Manager:      kubectl-create
      Operation:    Update
      Time:         2021-10-03T05:40:43Z
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:status:
          .:
          f:auditTimestamp:
          f:byPod:
          f:totalViolations:
          f:violations:
      Manager:         gatekeeper
      Operation:       Update
      Time:            2021-10-03T05:41:29Z
    Resource Version:  38159
    UID:               779ad3d3-0f58-480a-8d0d-0cc584e57a90
  Spec:
    Match:
      Kinds:
        API Groups:
  
        Kinds:
          Namespace
    Parameters:
      Labels:
        cks
  Status:
    Audit Timestamp:  2021-10-03T05:43:33Z
    By Pod:
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-audit-6ffc8f5544-nt5mg
      Observed Generation:  1
      Operations:
        audit
        status
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-controller-manager-6f9c99b4d7-mwghg
      Observed Generation:  1
      Operations:
        webhook
    Total Violations:  5
    Violations:
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                default
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                gatekeeper-system
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-node-lease
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-public
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-system
  Events:                  <none>
  ```

  

  ```sh
  # add labels to namespace default
  # Total Violations:  5 to 4
  k edit ns default
  
  ---
    labels:
      cks: amazing
  ---
  root@cks-master:~# k describe k8srequiredlabels ns-must-have-cks
  Name:         ns-must-have-cks
  Namespace:
  Labels:       <none>
  Annotations:  <none>
  API Version:  constraints.gatekeeper.sh/v1beta1
  Kind:         K8sRequiredLabels
  Metadata:
    Creation Timestamp:  2021-10-03T05:40:43Z
    Generation:          1
    Managed Fields:
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:spec:
          .:
          f:match:
            .:
            f:kinds:
          f:parameters:
            .:
            f:labels:
      Manager:      kubectl-create
      Operation:    Update
      Time:         2021-10-03T05:40:43Z
      API Version:  constraints.gatekeeper.sh/v1beta1
      Fields Type:  FieldsV1
      fieldsV1:
        f:status:
          .:
          f:auditTimestamp:
          f:byPod:
          f:totalViolations:
          f:violations:
      Manager:         gatekeeper
      Operation:       Update
      Time:            2021-10-03T05:41:29Z
    Resource Version:  38579
    UID:               779ad3d3-0f58-480a-8d0d-0cc584e57a90
  Spec:
    Match:
      Kinds:
        API Groups:
  
        Kinds:
          Namespace
    Parameters:
      Labels:
        cks
  Status:
    Audit Timestamp:  2021-10-03T05:48:51Z
    By Pod:
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-audit-6ffc8f5544-nt5mg
      Observed Generation:  1
      Operations:
        audit
        status
      Constraint UID:       779ad3d3-0f58-480a-8d0d-0cc584e57a90
      Enforced:             true
      Id:                   gatekeeper-controller-manager-6f9c99b4d7-mwghg
      Observed Generation:  1
      Operations:
        webhook
    Total Violations:  4
    Violations:
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                gatekeeper-system
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-node-lease
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-public
      Enforcement Action:  deny
      Kind:                Namespace
      Message:             you must provide labels: {"cks"}
      Name:                kube-system
  Events:                  <none>
  
  ```

  ```sh
  #can't create ns without label cks
  
  root@cks-master:~# k create ns test
  Error from server ([denied by ns-must-have-cks] you must provide labels: {"cks"}): admission webhook "validation.gatekeeper.sh" denied the request: [denied by ns-must-have-cks] you must provide labels: {"cks"}
  
  ```

##### 105. Practice - Enforce Deployment replica count

```sh
# delete constraint and template
root@cks-master:~# k -f constraints.yaml delete
k8srequiredlabels.constraints.gatekeeper.sh "ns-must-have-cks" deleted
root@cks-master:~# k -f template.yaml delete
constrainttemplate.templates.gatekeeper.sh "k8srequiredlabels" deleted
root@cks-master:~# rm *.yaml
```

```sh
# create template
vim template.yaml
https://github.com/killer-sh/cks-course-environment/blob/master/course-content/opa/deployment-replica-count/k8sminreplicacount_template.yaml

root@cks-master:~# k -f template.yaml create
constrainttemplate.templates.gatekeeper.sh/k8sminreplicacount created

root@cks-master:~# k get crd
NAME                                                 CREATED AT
configs.config.gatekeeper.sh                         2021-10-02T16:33:24Z
constraintpodstatuses.status.gatekeeper.sh           2021-10-02T16:33:24Z
constrainttemplatepodstatuses.status.gatekeeper.sh   2021-10-02T16:33:24Z
constrainttemplates.templates.gatekeeper.sh          2021-10-02T16:33:24Z
k8salwaysdeny.constraints.gatekeeper.sh              2021-10-02T16:46:17Z
k8sminreplicacount.constraints.gatekeeper.sh         2021-10-03T06:40:44Z
```

```sh
# create constraints
root@cks-master:~# k -f constraint.yaml create
k8sminreplicacount.constraints.gatekeeper.sh/deployment-must-have-min-replicas created
root@cks-master:~# k get k8sminreplicacount
NAME                                AGE
deployment-must-have-min-replicas   52s
```

```sh
# can't create deploy
root@cks-master:~# k create deploy test --image=nginx
error: failed to create deployment: admission webhook "validation.gatekeeper.sh" denied the request: [denied by deployment-must-have-min-replicas] you must provide 1 more replicas


root@cks-master:~# k create deploy test --image=nginx -oyaml --dry-run=client > deploy.yaml

#change replica 1 to 2
---
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: test
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
---

root@cks-master:~# k -f deploy.yaml create
deployment.apps/test created

```



##### 106 Practice - The Rego Playground and more examples

- Reference url
  - https://play.openpolicyagent.org
  - https://github.com/BouweCeunen/gatekeeper-policies

##### 107.Recap

- OPA overview
- Used Gatekepper's CRDs
- created templates and constraints
- Rego
- Reference url
  - https://www.youtube.com/watch?v=RDWndems-sk

#### Section 20 Supply Chain Security - Image Footprint
##### 108.Intro

- Image footprint
  - Containers and Docker
  - Reduce Image Footprint [Multi Stage]
  - Secure Images

![](.\images\Section20\Screenshot_1.png)

![](.\images\Section20\Screenshot_2.png)

##### 109. Practice - Reduce Image Footprint with Multi-Stage

```sh
# reference url
#https://github.com/killer-sh/cks-course-environment/tree/master/course-content/supply-chain-security/image-footprint

wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/supply-chain-security/image-footprint/Dockerfile

wget https://raw.githubusercontent.com/killer-sh/cks-course-environment/master/course-content/supply-chain-security/image-footprint/app.go

chmod +x Dockerfile app.go


# build docker container
docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0

root@cks-master:~# docker image list | grep app
app                                  latest     2157eb70e068   25 minutes ago   694MB

```



```sh
vim Dockerfile
---
#stage 0
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN CGO_ENABLED=0 go build app.go

# stage 1
FROM alpine
# copy from stage 0
COPY --from=0 /app .
CMD ["./app"]
---
docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0
# the image size is very small
root@cks-master:~docker image list | grep app
app                                  latest     8f2e91e2df15   About a minute ago   7.73MB
```

##### 110. Practice - Secure and harden Image

1. Use specific package versions

```sh
cat Dockerfile
---
#stage 0
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN CGO_ENABLED=0 go build app.go

# stage 1
FROM alpine:3.12.1
# copy from stage 0
COPY --from=0 /app .
CMD ["./app"]
---
root@cks-master:~# docker build -t app .
root@cks-master:~# docker run app
user: root id: 0
user: root id: 0
user: root id: 0
```

2. Don't run as root

```sh
---modified---
# stage 1
FROM alpine:3.12.1
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]   
---modified---
docker build -t app .
docker run app
user: appuser id: 100
user: appuser id: 100

```

3.  Make filesystem read only

```sh
---modified---
# stage 1
FROM alpine:3.12.1
RUN chmod a-w /etc
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]
---modified---
docker build -t app .
# run app in the back ground
docker run -d app
bf89ce4d7907d5fa421726041ddd709b3f58460917253147fd47465be5b5dd5a
docker exec -it bf89ce4d7907d5fa421726041ddd709b3f58460917253147fd47465be5b5dd5a sh

# etc don't have writing privileges 
# but is not to /etc/*
/ $ ls -lh
total 60K
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 bin
drwxr-xr-x    5 root     root         340 Oct  3 08:26 dev
dr-xr-xr-x    1 root     root        4.0K Oct  3 08:26 etc
drwxr-xr-x    1 root     root        4.0K Oct  3 08:25 home
drwxr-xr-x    7 root     root        4.0K Oct 21  2020 lib
drwxr-xr-x    5 root     root        4.0K Oct 21  2020 media
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 mnt
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 opt
dr-xr-xr-x  218 root     root           0 Oct  3 08:26 proc
drwx------    2 root     root        4.0K Oct 21  2020 root
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 run
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 sbin
drwxr-xr-x    2 root     root        4.0K Oct 21  2020 srv
dr-xr-xr-x   13 root     root           0 Oct  3 08:26 sys
drwxrwxrwt    2 root     root        4.0K Oct 21  2020 tmp
drwxr-xr-x    7 root     root        4.0K Oct 21  2020 usr
drwxr-xr-x   12 root     root        4.0K Oct 21  2020 var
```

4. remove shell access

```sh
vim Dockerfile
---modified---
# stage 1
FROM alpine:3.12.1
RUN chmod a-w /etc
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
RUN rm -rf /bin/*
# copy from stage 0
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]
---modified---
docker build -t app .
root@cks-master:~# docker run app
user: appuser id: 100
user: appuser id: 100
#can't use shell to login the docker container
root@cks-master:~# docker run -d app
f5dfc110fe8338f19aeaf9b95f7efb0fb660cc659d2fbe684858e68bff526a90
root@cks-master:~# docker exec -it f5dfc110fe8338f19aeaf9b95f7efb0fb660cc659d2fbe684858e68bff526a90 sh
OCI runtime exec failed: exec failed: container_linux.go:380: starting container process caused: exec: "sh": executable file not found in $PATH: unknown

```



##### 111.Recap

- reference 
  - https://docs.docker.com/develop/develop-images/dockerfile_best-practices
- Reduce image footprint
- Use multi stage build
- Secure images wiht restrictions

#### Section 21 Supply Chain Security - Static Analysis
##### 112.Intro

- Static Analysis

  - Looks at source code ant text files

  - Check against rules

  - Enforce rules

  - Static Analysis Rules

    - always define resource requests and limits
    - Pods should never user the default ServiceAccount
      - Depend on use case and  company or project
      - Generally: don't store sensitive data plain in K8s/Docker file

  - Static Analysis in CI/CD

    ![](.\images\Section21\Screenshot_1.png)

- Manual approach

  - Manual Check
    - not hard coding

- Tools for kubernetes and scenarios

##### 113. Kubesec

- Security risk analysis for Kubernetes resources
- Opernsource
- Opinionated ! Fixed set of rules(Security Best Practices)
- Run as:
  - Binary
  - Docker container
  - Kubectl plguin
  - Admission Controller(kubesec-webhook)
  - https://kubesec.io/

##### 114. Practice - Kubesec

- Using the kubesec public docker image

```sh
k run nginx --image nginx -oyaml --dry-run=client > pod.yaml
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < pod.yaml

```

https://github.com/controlplaneio/kubesec

##### OPA Conftest

- OPA=Open Policy Agent
- Unit test framework for Kubernetes configurations
- Uses Rego Language

![](.\images\Section21\Screenshot_2.png)

##### 116. Practice -OPA conftest for K8s YAML

- OPA conftest K8s Deployment
  - Use conftest to check a k8s example
  - 

```sh
git clone https://github.com/killer-sh/cks-course-environment.git

cd cks-course-environment/course-content/supply-chain-security/static-analysis/conftest/kubernetes

./run.sh

```





```sh
# modified the blow and run ./run.sh again
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: test
  name: test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: test
    spec:
##add
	securityContext:
        runAsNonRoot: true
      containers:
##add
        - image: httpd
          name: httpd
          resources: {}
status: {}
```

##### 117. Practice - OPA Conftest for Dockerfile

- Use conftest to run a Dockerfile example

```sh
root@cks-master:~/cks-course-environment/course-content/supply-chain-security/static-analysis/conftest/kubernetes# cd ..

 ls
docker  kubernetes
 l
Dockerfile  policy/  run.sh*

```



```sh
#modified ubuntu => alpine
FROM alpine
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN go build app.go
CMD ["./app"]

cat policy/commands.rego
# from https://www.conftest.dev

package commands
#delete apt
denylist = [
  "apk",
  "pip",
  "curl",
  "wget",
]

deny[msg] {
  input[i].Cmd == "run"
  val := input[i].Value
  contains(val[_], denylist[_])

  msg = sprintf("unallowed commands found %s", [val])
}

```

##### 118.Recap

- Static Analysis
- Manual Approach
- Kubesec
- OPA Conftest

Docs: "Rego - Policy Language"

#### Section 22 Supply Chain Security - Image Vulnerability Scanning
##### 119.Intro

- Image Vulnerabilities

  - Web servers or other apps can contain vulnerabilities(Buffer overflows)

  - Targets

    - Remotely accessible application in container
    - Local application inside container

  - Results

    - Privilege escalation
    - Information leaks
    - DDOS
  
- Containers - Layers - Dependencies

  - Layer1(ubuntu=14)
  - Layer4(nginx=x.x)
  - Layer6(curl=x.x)

- Known Image Vulnerabilities

  - Databases
    - https://cve.mitre.org
    - https://nvd.nist.gov 	
  - Vulnerabilities can be discovered in our own image and dependencies
    - Check during build
    - Check at runtime
  - Check for Known Image Vulnerabilities
  
  ![](.\images\Section22\Screenshot_1.png)
  
  
  
  - Known Image Vulnerabilities - Admission Controllers
  
  
  
  
  
  ![](.\images\Section22\Screenshot_2.png)



##### 120. Clair and Trivy

- Clair
  - Open source project
  - static analysis of vulnerabilities in application containers
  - Ingests vulnerability metadata from a configured set of sources
  - Provides API
- Trivy
  - Open source project
  - "A Simple and comprehensive Vulnerability Scanner for Containers and other Artifcacts, Suitable for CI."
  - Simple,Easy and fast

##### 121. Practice - Use Trivy to scan images

##### 122.Recap

#### Section 23 Supply Chain Security - Secure Supply Chain
##### 123. Intro

- Supply Chain

![](.\images\Section23\Screenshot_1.png)

- K8s and Container Registries

![](.\images\Section23\Screenshot_2.png)

- Validate and whitelist Images and Registries

##### 124. Practice - Image Digest

##### 125. Practice - Whitelist Registries with OPA

##### 126. ImagePolicyWebhook
![](.\images\Section23\Screenshot_3.png)

![](.\images\Section23\Screenshot_4.png)





##### 127. Practice - ImagePolicyWebhook



##### Recap

#### Section 24 Runtime Security - Behavioral Analytics at host and container level
##### 129. Intro

- Kernel vs User Space

![](.\images\Section24\Screenshot_1.png)

https://man7.org/linux/man-pages/man2/syscalls.2.html

![](.\images\Section24\Screenshot_2.png)



##### Recap
#### Section 25 Runtime Security - Immutability of containers at runtime
##### 138. Intro

- Immutability
  - Container won't be modified during its lifetime

![](.\images\Section25\Screenshot_1.png)

![](.\images\Section25\Screenshot_2.png)



##### 139. Ways to enforce immutability

![](.\images\Section25\Screenshot_3.png)

![](.\images\Section25\Screenshot_4.png)

![](.\images\Section25\Screenshot_5.png)



- Enforce Read-Only Root Filesystem
  - Enforce Read-Only root filesystem using *SecurityContexts* and *PodSecurityPolicies*
- Move logic to InitContainer?

![](.\images\Section25\Screenshot_6.png)

##### Recap

#### Section 26 Runtime Security - Auditing
##### 143.Intro

- Audit Logs - Introduction
  - ![](.\images\Section26\Screenshot_1.png)
  - ![](.\images\Section26\Screenshot_2.png)

![](.\images\Section26\Screenshot_3.png)

##### Recap

#### Section 27 System Hardening - Kernel Hardening Tools
##### Intro
##### Recap
#### Section 28 System Hardening - Reduce Attack Surface
##### Intro
##### Recap
#### Section 29 CKS Exam Series

##### 

#### Section 30 CKS Simulator

##### 166 Intro

##### 168 Rating and feedback