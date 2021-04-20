### Mock Exam 2
#### No.01
> Create a Deployment called *my-webapp* with:nginx,label *tier:fronted* and 2 replicas.Expose the deployment as a NodePort service with name *front-end-service*,port:*80* and NodePort: *30083*

*Weight: 8*

- Deployment my-webapp created?
- image:nginx
- Replicas = 2 ?
- service front-end-service created?
- service Type created correctly?
- Correct node Port used?

#### No.02

> Add a tain to the node node01 of the cluster. Use the specification below:

> key: *app_type*, value: *alpha* and effect:*NoScheduler*
>
> Create a pod called *alpha*, image:*redis* with toleration to node01

*Weight: 12*

- node01 with the correct taint?
- Pod alpha has the correct toleration?

#### No.03


