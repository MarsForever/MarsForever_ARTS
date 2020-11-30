## 0-Refrence

[Blog: AWS Certified Solution Architect – Professional (SAP-C01) Exam Learning Path](https://jayendrapatil.com/aws-certified-solution-architect-professional-exam-learning-path/)

[【AWS認定】ソリューションアーキテクト プロフェッショナル（AWS CSA-Pro）に合格してきた【英語重要】 2018-04-06](https://qiita.com/tmiki/items/c83df748261c7b87ed18)

### Linux Academy AWS SAP

https://interactive.linuxacademy.com/diagrams/OrionPapersPro.html

[AWS Certified Solutions Architect- Professional(SAP-C01) Exam Guide](https://d1.awsstatic.com/training-and-certification/docs-sa-pro/AWS_Certified_Solutions_Architect_Professional-Exam_Guide_1.2.pdf)


### WhizLabs
[WhizLabs](https://www.whizlabs.com/aws-solutions-architect-professional/)
https://www.whizlabs.com/learn/course/aws-csap-practice-tests/


### Udemy AWS SAP
[AWS Certified Solutions Architect Professional Practice Exam](https://www.udemy.com/course/aws-solutions-architect-professional-practice-exams-amazon/)



This was a really tough exam and below are my details of the learning path I took and few tips!

Did Adrian course twice and really took note on the tips Adrian provided and explored them further

I read following whitepapers

• Whitepaper: AWS Security Best Practices

• Whitepaper: AWS Well-Architected Framework

• Whitepaper: Architecting for the Cloud: AWS Best Practices

• Whitepaper: Practicing Continuous Integration and Continuous Delivery on AWS: Accelerating Software Delivery with DevOps

• Whitepaper: Microservices on AWS

• Whitepaper: Amazon Web Services: Overview of Security Processes

• AWS Documentation

• AWS Architecture Center

• https://d1.awsstatic.com/whitepapers/Storage/BackupandRecoveryApproachesUsing_AWS.pdf

Ready all the core subjects FAQ’s 

I watched all of the following reinvent videos:

https://www.youtube.com/watch?v=LNYY3bMSiHM

https://www.youtube.com/watch?v=DXFooR95BYc&t=2s

https://www.youtube.com/watch?v=ar6sLmJ45xs

https://www.youtube.com/watch?v=VIgAT7vjol8&t=4s

https://www.youtube.com/watch?v=01ewawuL-IY&t=255s

https://www.youtube.com/watch?v=oA04URWQXnM

https://www.youtube.com/watch?v=fnxXNZdf6ew

https://www.youtube.com/watch?v=D1n5kDTWidQ

https://www.youtube.com/watch?v=yQGxPEGt_-w

https://www.youtube.com/watch?v=HaEPXoXVf2k

https://www.youtube.com/watch?v=yNVmUevq04I

https://www.youtube.com/watch?v=QdzV04T_kec&t=227s

https://www.youtube.com/watch?v=tflZjGckK8c&t=922s

https://www.youtube.com/watch?v=U42mC_iKSBg

https://www.youtube.com/watch?v=ar6sLmJ45xs&t=220s

Completed all the Wizlabs. & Braincert AWS Certified Solutions Architect – Professional Practice Exams [Highly Recommended] – These practice exam allowed me to understand how to breakdown the questions, work on my speed and reach in depth to understand the recommended answer!.

https://tutorialsdojo.com/aws-cheat-sheets/ and dojo practice exams. I found Braincert and Wizlabs more comprehensive then dojo exams.

Did the AWS official preparation course. I found it a good summary and it gave tips on how to digest the question and core areas to focus on.

Completed the AWS official practice exam 3 days prior to the actual exam. I got 64%. 

For the exam know the following in depth to pass:

Management & Governance tools

• Understand AWS Organizations: ( Know the difference between Service Control Policies and IAM Policies (I got a question on blacklist SCP policy and person unable to access S3 due to IAM premision)

• Systems Manager: (parameter store, patch manager)

• Understand CloudWatch ( I got more then 5 question on complex CloudWatch logs and Subscription along with CloudTrail

• Know CloudFormation nested stacks and SAM along with OpsWork & CodeDeploy esp. in terms of Disaster recovery to replicate environment across regions.

Networking & Content Delivery

• Direct connect – How to make it resilience, long with Public VIF setup for S3 access

• Understand VPC Endpoints (hint: know how to restrict access on S3 to specific VPC Endpoint)

• Understand VPC Peering

• Route 53: Routing Policies and their use cases Focus on Weighted, Latency routing policies

• Understand CloudFront and use cases (hint : S3 caching)

• Understand API Gateway and exposed microservices within the AWS network

Migration & Transfer ( got 4 to 5 questions)

• Understand Cloud Migration Services, along with using Storage gateway for migration

• Know Server Migration Service (hint IBM WebSphere and DB2 on ZOS)

• Know Database Migration Service (hint: Elasticsearch is supported by DMS)

• Know Snowball vs Snowball Edge 

• Know AWS Application Discovery Service (hint: agentless mode does not track processes)

Load Balancer

• Understand ELB, ALB and NLB 

• Understand ELB with Auto Scaling

• Security, Identity & Compliance

• AWS Identity and Access Management

• Understand IAM Roles and use cases

• Understand IAM Web Identity & Federation

• Know IAM Best Practices

• Know AWS Shield, WAF for DDoS Protection

Storage

• Focus on EBS SSD or HDD selection based IOPS and data type 

• Understand S3 Permissions (hint: know S3 bucket polices to control access to VPC Endpoints)

• Know S3 disaster recovery across region. (hint : cross region replication)ront for caching to improve performance

• Understand Storage Gateway

Database

• Know Aurora DR & HA using Read Replicas and Global Database ( had pick question on this

• RedShift (had question on how to protect it out of region)

• Understand RDS Multi-AZ vs Read Replicas (hint: cross region replication and availability of data)

• Know DynamoDB and DynamoDB Streams for tracking changes

• Improve performance – Best practices (hint : one question for selection of keys)

Compute

• Understand EC2 Instance Purchase Types

• Understand Auto Scaling

• Know Elastic Beanstalk mainly from the perspective of migration.

• Understand Lambda (hint: know what it takes to run Lambda within an VPC and Lambda@Edge)

• Fargate 

Analytics

• Understand the difference between Kinesis Data Streams and Kinesis Firehose (again had 3 questions on this)

• Know Amazon Elasticsearch provides a managed solution and Kabana 

Integration Tools

• Understand SQS in terms of loose coupling and scaling.

• Know the difference between SQS Standard and FIFO

• Know how CloudWatch integration with SNS and Lambda can help in notification



### SMART

Specific:

Got AWS sap certification on August

Measurable:

complete Linux Academy's course, finish udemy aws sap exam and got 90% score

Attainable:

Linux Academy

Relevant:

Can improve architect skill ,improve my salary

Time-Based:

before August

#### Keyword

- DR:RPO/RTO
  - RPO(Recovery Point Objective):恢复点目标。The time between when a disaster occurs and the last recoverable copy of key business data was created. Minimize the length of this time period(via regular backups, snapshots, and transaction logs) to avoid business disruptive(破坏的) data loss.
  - RTO(Recovery Time Objective):恢复时间目标。The time between when a disaster occurs and when the system can be restored to an operational(即可使用的) state and handed over to the business for testing. Improve this by decreasing restore time, having hot spares(热后备) tested and ready to use, and enforcing efficient processes.
- HA(High Availability):高可用性。例子：汽车备胎
- FT(Fault Tolerance):容错，故障容差。飞机两侧都有两个引擎，两侧中的一个故障都不影响飞行
- DR(Disaster Recovery):灾难恢复。战斗机上的驾驶员紧急弹射。
- Data Persistence
  - Ephemeral Storage(临时)：Instance Store Volume,Amazon ElasticCache
  - Transient Storage(暂态存储)：Simple  Queue
  - Persistent(持久存储)：Amazon EBS,Amazon EFS
- [7-Layer OSI Model ](https://www.wikiwand.com/en/OSI_model)
  - 1 - Physical :01010101
  - 2 - Data Link: ae:43:4f(MAC address)
  - 3 - Network: 10.0.0.1(IP)
  - 4 - Transport : TCP&UDP
  - 5 - Session: Port 443
  - 6 - Presentation: LoadBalancer ?
  - 7 - Application: HTTP

##### Service

If an instance reboots, the data in the instance store persists. If an instance stops, terminates, or the underlying disk(基本磁盘) fails, the data in the instance is lost.

# AWS Certified Solutions Architect - Professional Linux Academy

## Getting Started

### CSA Pro Exam Overiew

| Domain                                                 | % of Examination |
| ------------------------------------------------------ | ---------------- |
| Domain1: Design for Organizational Complexity          | 12.5%            |
| Domain2: Design for New Solutions                      | 31%              |
| Domain3: Migration Planning                            | 15%              |
| Domain4: Cost Control                                  | 12.5%            |
| Domain5: Continuous Improvement for Existing Solutions | 29%              |
| **TOTAL**                                              | **100%**         |

1. **Domain 1: Design for Organizational Complexity** 

   1. Determine cross-account authentication and access strategy for complex organizations(for example, an organization with varying compliance requirements,multiple business units, and varying scalability requirements).

      定义复杂组织的跨账户身份验证和访问策略（例如，不同的合规要求，多个业务部门和变化的可伸缩性要求的组织）

   2. Determine how to design networks for complex organizations (for example, an organization with varying compliance requirements, multiple business units, and varying scalability requirements)

      定义如何为复杂组织设计网络（例如，不同的合规要求，多个业务部门和变化的可伸缩性要求的组织）

   3.  Determine how to design a multi-account AWS environment for complex organizations (for example, an organization with varying compliance requirements, multiple business units, and varying scalability requirements)

      定义如何为复杂组织设计一个多账户AWS环境（例如，具有不同的合规性要求，多个业务部门和变化的可伸缩要求的组织）

2. **Domain 2: Design for New Solutions **

   1. Determine security requirements and controls when designing and implementing a solution 

      在设计和实施解决方案时，确定安全要求和控制

   2. Determine a solution design and implementation strategy to meet reliability requirements 

      确定一个解决方案设计和实施策略以满足可靠性要求

   3. Determine a solution design to ensure business continuity 

      确定一个解决方案设计以确保业务连续性

   4. Determine a solution design to meet performance objectives 

      确定解决方案设计以满足性能目标

   5. Determine a deployment strategy to meet business requirements when designing and implementing a solution

      在设计和实施解决方案时，确定一个部署战略以满足业务需求

3. **Domain 3:Migration Planing**

   1.  Select existing workloads and processes for potential migration to the cloud 

      为潜在的迁移到云选择现有的工作负载和流程

   2. Select migration tools and/or services for new and migrated solutions based on detailed AWS knowledge 

      依据详细的AWS知识选择迁移工具和/或服务为新的，移植的解决方案

   3. Determine a new cloud architecture for an existing solution 

      为现有的解决方案确定一个新的云构架

   4. Determine a strategy for migrating existing on-premises workloads to the cloud

      为迁移现有的私有工作负载到云定义一个战略

4. **Domain 4: Cost Control**

   1. Select a cost-effective pricing model for a solution 

      选择一种具有成本效益的定价模型作为解决方案

   2. Determine which controls to design and implement that will ensure cost optimization 

      确定设计和实施哪些控件以确保成本优化

   3. Identify opportunities to reduce cost in an existing solution

      识别机会以降低现有解决方案的成本

5. **Domain 5: Continuous Improvement for Existing Solutions**

   1. Troubleshoot solution architectures 

      排除结构性的解决方案故障

   2. Determine a strategy to improve an existing solution for operational excellence 

      为卓越的运营确定一个战略以改善现有解决方案

   3. Determine a strategy to improve the reliability of an existing solution 

      确定改善现有解决方案可靠性的战略

   4. Determine a strategy to improve the performance of an existing solution 

      确定改善现有解决方案的性能的战略

   5. Determine a strategy to improve the security of an existing solution 

      确定改善现有解决方案的安全的战略

   6. Determine how to improve the deployment of an existing solution

      确定如何去改善现有的部署解决方案

https://d1.awsstatic.com/training-and-certification/docs-sa-pro/AWS-Certified-Solutions-Architect-Professional_Exam-Guide.pdf

## AWS Essentials
### AWS Accounts
authenticate:鉴定，使生效
authorize: 授权，批准，委托

### Regions,AZs, and Edge Infrastructure

### High Availability, Fault Tolerance, and Disaster Recovery

HA:高可用，例子：汽车备胎

FT:容错，例子HA，FT:飞机两翼各有两个引擎

DR:灾难复原，例子：飞行员紧急弹射

### Disaster Recovery: RPO and RTO




## Identity & Access Management(IAM)

### IAM Essentials:

- **IAM** (Identity & Access Management) allows you to control access to AWS services and resources. 

Create a policy can access full s3 resources

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
```

execute command on your pc using access key

```shell
aws configure
#enter your accesskey and your secret key 
#the key will show when you create a new user
aws s3 ls
```

Create testuser-first-bukcet and testuser-first-bucket2 under s3

s3_specific_bucket(you should change the testuser-first-bucket to your bucket's name)

arn: amazon resource names

```json
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Action":[
                "s3:ListAllMyBuckets"
            ],
            "Resource":"arn:aws:s3:::*"
        },
        {
            "Effect":"Allow",
            "Action":[
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource":"arn:aws:s3:::testuser-first-bucket"
        },
        {
            "Effect":"Allow",
            "Action":[
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource":"arn:aws:s3:::testuser-first-bucket/*"
        }
    ]
}
```

```shell
#show all bucket
aws s3 ls
#show all files under testuser-first-bucket
aws s3 ls s3://testuser-first-bucket
:'
2020-03-22 15:43:06      55868 game-picture.jpg
2020-03-22 15:43:24       1547 tags.sql
'
#get the error
aws s3 ls s3://testuser-first-bucket2
#An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied
```

upload file  to s3

```shell
aws s3 cp $filename s3://testuser-first-bucket
aws s3 ls s3://testuser-first-bucket
:'
2020-03-22 15:43:06      55868 game-picture.jpg
2020-03-22 15:43:24       1547 tags.sql
2020-03-22 15:54:29       1568 videos.sql
'
```

