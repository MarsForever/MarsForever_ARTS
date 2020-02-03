

1. ### Scheduling(5%)

   1. Manual scheduling: add nodeName under spec
   2. Labels and Selectors:add nodeSelector under spec
   3. Taints and Tolerations:
      1. kubectl taint nodes $nodename$key=$value:$Effect
      2. reference: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/#concepts
      3. Remove the taint on master, which currently has the taint effect of NoSchedule
         1. kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-
   4. Node Affinity
      1. add affinity parallel spec.containers,just like spec.affinity
   5. Static PODs
      1. get static pod (name with pod's name )
         1. kubectl get pod -n kube-system | grep $nodename
      2. What is the path of the directory holding the static pod definition files?
         1.  `ps -aux | grep kubelet`  | grep config
         2.  grep static $configPath(example /var/lib/kublet/config.yaml)
      3. Create a static pod named `static-busybox` that uses the `busybox` image and the command `sleep 1000`
         1. kubectl run --restart=Never --image=busybox static-busybox --dry-run -o yaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
      4. create new shceduler
         1. copy /etc/kubernetes/manifests/kube-scheduler.yaml and change port
            1. check port :netstat -natulp | grep 10251
            2. add port under command, and set same port to 1
            3. change leader-elect=true to leader-elect=false
         2. add new parameter --scheduler-name
         3. change kube-scheduler to my-scheduler with command and image
      5. add schedulername to pod

2. ### Logging & Monitoring(5%)

   1. Monitor Cluster Components
      1. metric git
         1. https://github.com/kodekloudhub/kubernetes-metrics-server.git
      2. get top of kubernetes
         1. kubectl top node
   2. Managing Application Logs
      1. A user - 'USER5' - has expressed concerns accessing the application. Identify the cause of the issue.
         1. kubectl  logs $podName
      2. get container log
         1. kubectl logs $podName $containerName

3. ### Application Lifecycle Management(8%)

   1. Rolling Updates and Rollbacks
      1. Check deployment settings
         1. kubectl describe deploy $deployName 
      2. Commands and Arguments
         1. add command under containers 
      3. Up to how many PODs can be down for upgrade at a time 
         7. 	Look at the Max Unavailable value under RollingUpdateStrategy in deployment details
      
   2. Commands and Arguments

      ```yaml
      spec:
        containers:
      
      - name: simple-webapp
        image: kodekloud/webapp-color
        command: ["python", "app.py"]
        args: ["--color", "pink"]
      ```

   3. Env Variables : empty

   4. Secrets

      1. kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
      
   5. Multi Container Pods:empty

   6. Init Containers: empty

4. ### Cluster Maintenance(11%) =>need to learn again

   1. OS Upgrades
      1. Maintenance the node01
         1. kubectl drain node01 --ignore-daemonsets
      2. The maintenance tasks have been completed. Configure the node to be schedulable again.
         1. kubectl uncordon node01
      3. Why are there no pods on `node01`?
         1. Only new pod will be created on node01=> why
      4. why there is no pod on master
         1. master is on tain?
      5. why node02 can't be drained
         1.  POD not part of a replicaset hosted on `node02`
      6. What would happen to `hr-app` if `node02` is drained forcefully?
         1. hr-app will be lost forever
      7. Node03 has our critical applications. We do not want to schedule any more apps on node03. Mark `node03` as `unschedulable` but do not remove any apps currently running on it .
         1. kubectl cordon node03
      
   2. Upgrade Process

      1. What is the current version of the cluster?

         1. kubectl get node 
2. How many nodes are part of this cluster?(Includes master and node)
   
   1. kubectl get node
      3. How many nodes can host workloads in this cluster?

         1. kubectl get pod -o wide
4. How many applications are hosted on the cluster?How many applications are hosted on the cluster?
   
   1. kubectl get deploy
      5. What nodes are the pods hosted on?

         1. kubectl get pod -o wide
6. You are tasked to upgrade the cluster. User's accessing the applications must not be impacted. And you cannot provision new VMs. What strategy would you use to upgrade the cluster?
   
   1. Upgrade one node at a time while moving the workloads to the other
      7. What is the latest stable version available for upgrade?

         1. kubeadm upgrade plan
8. How should you go about upgrading from the current version to the latest stable version?
   
   1. Upgrade one minor version at a time until the latest stable version
      9. We will be upgrading the master node first. Drain the master node of workloads and mark it `UnSchedulable`

         1. kubectl drain master --ignore-daemonsets
10. Upgrade the master components to `v1.12.0`
    
    1. apt install kubeadm=1.12.0-00
          2. kubeadm upgrade apply v1.12.0
    3. apt-get install kubelet=1.12.0-00
      11. Mark the master node as "Schedulable" again

          1. kubectl uncordon master
12. Next is the worker node. `Drain` the worker node of the workloads and mark it `UnSchedulable`
    
    1. kubectl drain node01 --ignore-daemonsets
      13. Upgrade the worker node to v1.12.0
          14. 	apt install kubeadm=1.12.0-00
          2. apt install kubelet=1.12.0-00
    3. kubeadm upgrade node config --kubelet-version $(kubelet --version | cut -d ' ' -f 2)
      14. Remove the restriction and mark the worker node as schedulable again.
    1. kubectl uncordon node01
    
3. Backup and Restore Methods
   
   1. We have a working kubernetes cluster with a set of applications running. Let us first explore the setup.How many deployments exist in the cluster?
   
      1. kubectl get deploy
   
   2. What is the version of ETCD running on the cluster?Check the ETCD Pod or Process

      1. kubectl logs etcd-master -n kube-system  | grep version OR
      2. kubectl describe pod etcd-master -n kube-system | grep images
   
   3. At what address do you reach the ETCD cluster from your master node?
   
      1. kubectl describe pod etcd-master -n kube-system | grep listen-client-urls
   
   4. Where is the ETCD server certificate file located?
   
      1. kubectl describe pod etcd-master -n kube-system | grep --cert-file
   
   5. Where is the ETCD CA Certificate file located?
   
      1. kubectl describe pod etcd-master -n kube-system | grep ca-file
   
   6. The master nodes in our cluster are planned for a regular maintenance reboot tonight. While we do not anticipate anything to go wrong, we are required to take the necessary backups. Take a snapshot of the **ETCD** database using the built-in **snapshot** functionality.
   
      Store the backup file at location /tmp/snapshot-pre-boot.db
   
      1. - [ ] important
   
         ```
         ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
              --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
              snapshot save /tmp/snapshot-pre-boot.db
         ```
   
   7. Wake up! We have a conference call! After the reboot the master nodes came back online, but none of our applications are accessible. Check the status of the applications on the cluster. What's wrong?
   
      1. deployment,pod,service are not present.
   
   8. - [ ] I don't know
   
   9. 
   
5. ### Security(12%)

6. ### Storage(7%)

7. ### Networking

   1. Explore Environment
      1. 
   2. Explore CNI weave
      1. Inspect the kubelet service and identify the network plugin configured for Kubernetes.
         1. ps -aux | grep kubelet
      2. Identify which of the below plugins is not available in the list of available CNI plugins on this host
         1. ls /opt/cni/bin | grep -E 'vlan|dhcp|cisco|bridge'
      3. ls /opt/cni/bin | grep -E 'vlan|dhcp|cisco|bridge'
         1. ls /etc/cni/net.d/ 
      4. What binary executable file will be run by kubelet after a container and its associated namespace are created.
         1. cat /etc/cni/net.d/10-weave.conf | grep type
   3. Explore CNI weave 2
      1. ip link
      2. ip addr show weave
   4. Deploy Network Solution:empty
   5. Networking Weave:empty
   6. Service Networking
      1. What network range are the nodes in the cluster part of?
         1. ip addr 
      2. What is the range of IP addresses configured for PODs on this cluster?
         1. kubectl logs <weave-pod-name> weave -n kube-system | grep  ipalloc-range
      3. What is the IP Range configured for the services within the cluster?
         1. ps -aux | grep kube-api | grep ip-range
      4. What type of proxy is the kube-proxy configured to use?
         1. kubectl logs kube-proxy-xxxx -n kube-system
   7. CoreDNS in Kubernetes
   8. CKA-Ingress Networking 1
   9. CKA-Ingress Networking 2

8. ### Troubleshooting(10%)

9. ### Core Concepts(19%)



#### Curriculum

https://github.com/cncf/curriculum/blob/master/certified_kubernetes_administrator_exam_v1.15.pdf