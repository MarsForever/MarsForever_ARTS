# Lab Details

1. This lab walks you through the steps to block web traffic with a WAF (**web application firewall**) in AWS.
2. Duration: **1 Hour**
3. AWS Region: **US East (N. Virginia) us-east-1**

# Introduction

## WAF (web application firewall)

1. AWS WAF is a web application firewall that helps you to protect your web applications against common web exploits that might affect availability and compromise security.
2. AWS WAF gives you control over how traffic reaches your applications by enabling you to create security rules that block common attack patterns like SQL injection and cross-site scripting.
3. It only allows the request to reach the server based on the rules or patterns you define.
4. Users create their own rules and specify the conditions that AWS WAF searches for in incoming web requests.
5. The cost of WAF is only for what you use. 
6. The pricing is based on how many rules you deploy and how many web requests your application receives.
7. For example, you can deploy AWS WAF on Amazon CloudFront with an Application Load Balancer in front of your web servers or servers running on EC2.

## Features of WAF

### Web traffic filtering using custom rules 

- You can create your own rules, depending on your requirements, whether to block or allow the incoming and outgoing request. You can also customise the string that appears in your web request.

###  Blocking malicious requests

- You can also configure rules in AWS WAF to identify and block web requests threats like SQL injections and cross-site scripting.

### Tune your rules and monitor traffic                 

- AWS WAF also allows us to review our rules and customize them to prevent new attacks from reaching the server.

# Lab Description

## Application Load Balancer (ALB)

- **Load Balancer**, a **service** that **allows you to distribute the incoming application or network traffic across multiple targets**, such as Amazon **EC2** instances, containers, and IP addresses, in multiple Availability Zones.
- ALB is used to route the HTTP and HTTPS traffic across the targets based on the rules attached with the target group.
- **Rules** determine what action is taken when a rule matches a client request.
- The **target group** is used to route requests across registered **targets** as part of an action rule. Target groups consist of a protocol and target port. We can also configure health checks to monitor the status of the target group. A single ALB can route traffic to multiple target groups.
- **Targets** consist of EC2 instances that are registered with the ALB as part of a target group.

## Web servers

- Two web servers are launched in the Private subnet to handle the web request.
- The request to web servers is shared using the ALB.
- Web servers are attached to the ALB Target group.
- Servers are pre-installed with HTTPD on both servers and have the test pages **RESPONSE COMING FROM SERVER 1** and **RESPONSE COMING FROM SERVER 2** respectively.
- They are attached to a security group via port 80 that allows the web traffic coming from ALB.

# Architecture Diagram    

![img](https://play.whizlabs.com/frontend/web/media/2020/07/23/task_id_67_blocking_web_traffic_with_waf_in_aws_25_28.png)![img](https://play.whizlabs.com/frontend/web/media/2020/07/23/blank_diagram.png)

# Task Details

1. Launching lab environment
2. Create Security Group for Load Balancer
3. Steps to create the web servers
4. Create a Load Balancer
5. Testing the Load Balancer
6. Create an IP Set
7. Create a web ACL
8. Testing the working of the WAF
9. Unblocking the IP
10. Validation of the lab





# Lab Steps

## Task 1: Launching Lab Environment

1. Launch the lab environment by clicking on ![img](https://play.whizlabs.com/frontend/web/media/2021/05/31/start_lab.png). Please wait until the lab environment is provisioned. It will take less than 2 minutes to provision the lab environment.
2. Once the Lab is started, you will be provided with ***IAM user name\***, ***Password\***, **AccessKey** and ***Secret Access Key\***.
3. Click on the ![img](https://play.whizlabs.com/frontend/web/media/2021/05/31/open_console.png), AWS Management Console will open in a new tab.
4. In the AWS sign in page, the Account ID will be present by default.
   - Leave the Account ID as default. Do not remove or change the Account ID otherwise you cannot proceed with the lab.
5. Copy and paste the ***IAM user name*** and ***Password\*** into AWS Console. Click on **Sign in** to log into the AWS Console.

**Note :** If you face any issues, please go through [**FAQs and Troubleshooting for Labs**](https://play.whizlabs.com/site/task_support/faqs-and-troubleshooting).

## Task 2: Creating Security group for Load balancer

1. Navigate to the EC2 Dashboard and scroll down to **Security Groups**. In the left menu, click on **Create Security Group**
2. **Configure the security** group as follows:

- Security group name: Enter ***LoadBalancer-SG***
- Description : Enter ***Security group for Load balancer***
- VPC : **Leave as default**
- In **Inbound rules**, Click on **Add Rule** and add the port as follow.

- Type    **:** Select **HTTP**
- Protocol   : **TCP**
- Port range**: 80** 
- Source   : Select **Custom**, and enter ***0.0.0.0/0***

- Once you provide the above details, click on Create and the security group for the load balancer will be created.

## Task 3: Steps to create the Web-servers

1. Make sure you are in the **US East (N. Virginia)** Region. 
2. Navigate to **EC2** by clicking on the ![img](https://play.whizlabs.com/frontend/web/media/2020/11/26/image2.png) menu in the top, then click on ![img](https://play.whizlabs.com/frontend/web/media/2020/11/26/image5.png) under ![img](https://play.whizlabs.com/frontend/web/media/2020/11/26/image31.png) section.
3. Navigate to **Instances** on the left panel and click on **Launch Instance**

1. Choose an Amazon Machine Image (AMI): Search for **Amazon Linux 2 AMI** in the search box and click on the **select** button.

![img](https://play.whizlabs.com/frontend/web/media/2020/11/09/amzn_linux_2.png)

1. Instance Type: Select **t2.micro**
2. **Configure Instance Details:** 

- Number of instances   : Enter ***1***     

- Auto-assign Public IP   : Select **Enable**

- Click on **Advanced Details****.**

- Under the **User data** section, enter the following script to create an HTML page served by an Apache HTTPD web server. 

   Copy

  **#!/bin/bash****sudo su****yum update -y****yum install -y httpd****systemctl start httpd****systemctl enable httpd****echo "Response coming from server A" > /var/www/html/index.html**

  ​         

1. Now click on **Next: Add Storage**

1. **Add Storage:** No need to change anything in this step, click on **Next: Add Tags**
2. **Add Tags:** Click on **Add Tag**

- Key        : Enter ***Name\***     
- Value       : Enter ***webserver-A\***     
- Click on : **Next: Configure Security Group**

1.  **Configure Security Group:**

- Name     : Enter ***webserver-SG***
- Description   : Type ***security group for webserver***
- To add SSH
  - Choose Type     : Select **SSH**
  - Source     : Choose **Anywhere**

- To add **HTTP**
  - Choose Type   **:** Select ***\*HTTP\****
  - Source     : Choose **LoadBalancer-SG**

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image27_01_52.png)

 

1. After that, click on **Review and Launch**

2. **Key Pair:** Create a new key pair named ***webkey\*** and click on **Download Key Pair** . The key pair **will be downloaded to your local system.** After that, click on **Launch Instances**.

3. After a few minutes, you will see a new instance named **webserver-A** running.

4. Repeat the above steps to create **Webserver-B** by selecting the existing security group **webserver-SG** providing the following details:

   - **User Data:**

      Copy

     **#!/bin/bash****sudo su****yum update -y****yum install -y httpd****systemctl start httpd****systemctl enable httpd****echo "Response coming from server B" > /var/www/html/index.html**

- Name: Enter ***webserver-B***
- Security Group: Choose **Select an existing group** and select **webserver-SG**
- Key Name: Select **Choose an existing key pair** and select **webkey** and **acknowledge.**

1. Navigate to the EC2 Dashboard to find the two instances (webserver-A and webserver-B) running.

![img](https://play.whizlabs.com/frontend/web/media/2021/07/12/task_3_step_14.jpg)

## Task 4: Creating a Load balancer

1. Make sure you are in the **US East (N. Virginia) us-eat-1** Region. 
2. In the **EC2** console, navigate to **Load Balancers** in the left side panel.
3. Click on **Create Load Balancer** on top left to create a new load balancer for our web servers.
4. On the next screen, choose **Application Load Balancer** since we are testing the high availability of our web application.
5. In **configure the load balancer**, provide the following details:

- Name     : Enter ***Web-server-LB***
- Scheme   : Select **Internet-facing**
- Ip address type   : Choose **ipv4**
- Listener     : **Default** (Http:80)
- Availability Zones
  - VPC       : Choose **Default**
  - Availability Zones : Select **All Availability Zones ,** 

**(Note:** we must specify the availability zones in which the load balancer needs to be enabled so it can route the traffic only to the targets launched in those availability zones. You must include **subnets from a minimum of two Availability zones** to make our Load balancer **Highly Available.)**

1. Once filling in all the details above, ignore the warning and click onNext: **Configure Security Settings**
2. **Configure Security Settings:**

- Select an **existing** security group and chose the security group **LoadBalancer-SG** that we created in the above step.

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image62.png)

1. **configure Routing** 

- Target Group: Select New target group (default)
  - Name     : Enter ***web-server-TG***
  - Target Type   : Select **Instance**
  - Protocol   : Choose **HTTP**
  - Port     : Enter ***80***
  - **Note: The target group** is used to **route requests** to one or more registered targets
- Health check:
  - Protocol   : Choose **HTTP**
  - Path     :Enter ***/index.html***
  - Click on **Next: Register Targets**
  - **Note**: The load balancer periodically sends pings, attempts connections, or sends requests to test the EC2 instances. These tests are called health checks.

- Create an **index.html** file the default Apache document root **/var/www/html** of web servers to pass the health check. This can be done by navigating to the route and executing the command: echo "hello world" > index.html

1. **Registering Targets**

- Choose the two web instances, click on **Add to registered** and click on **Next: Review** 

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image17_16_47.png)

1. Once you reviewed the settings, click on **Create**.
2. You have **successfully created** the **Application Load balancer.** Wait for 4 to 5 minutes for the Load balancer to become Active.

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image16.png)

## Task 5: Testing the Load Balancer

1. Navigate to **![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image14_18_33.png)** and select the **load balancer** that you created. Click on **Description ,** **copy the DNS name** and paste it in the browser

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image57.png)

1. Refresh the browser a few times and you will see the request is serving from both servers. You will see the output as **RESPONSE COMING FROM SERVER A & RESPONSE COMING FROM SERVER B.** This shows that load is shared between the two web servers via Application Load Balancer.

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image31_22_31.png)

![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image35_22_52.png)

## Task 6: Creating an IP set

1. Click on ![img](https://play.whizlabs.com/frontend/web/media/2020/01/30/image36_23_59.png) and select ![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image11.png) under the ![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image34.png) section.
2. Select ![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image20.png) in the right side menu and click on **Create IP set**
3. On the next screen, fill out the following details under **Create IP set.**

- **IP set details:**
  - IP set name  : Enter ***MyIPset***
  - Description  : Enter ***IP set to block my public IP***
  - Region      : Select **US EAST (N.Virginia )**
  - IP Version    : Select **IPv4**
  - IP address   : Enter ***IP of your local network/32*** from https://www.whatismyip.com/.
  - Note: You have to give /32 after the IP is pasted or else you won't be able to create an IP set.
- Once you have provided the above details, click on **Create IP set**

## Task 7: Creating a web ACL

1. **Web ACL details**

- Navigate to the **AWS WAF** dashboard and select **Web ACLs** . Click on **Create web ACL** to create a new web ACL.
- Configure the ACL as below:
  - **Web ACL details**

- Name : Enter ***MywebACL***
- Description: Enter ***ACL to block my public IP***
- Resource type: Select **Regional resources (Application Load Balancer and API Gateway)** 
- Region: Select **US EAST (N.Virginia)****![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image28.png)**
- To associate an AWS resource, click on **Add AWS resources**
- In Add AWS resources select **Application Load Balancer** and select the name of **ALB**. Click on **Add**

![img](https://play.whizlabs.org/frontend/web/media/2020/10/19/waf_lab_1_28_41.png)

- Lastly click on **Next**.

1. **Add rules and rule groups**

- Under **Rules** click on **Add rule** and select **Add my own rules and rule groups** in the drop-down menu.
- In **Rule type** select **IP set** as shown below and fill the details as given below:
  - Rule type  : Select **IP set** 
  - Name      : Enter ***MywebACL-rule***
  - IP set      : **select the IP set created Above ( MyIPset )**
  - IP address to use as the originating address***\*: Source IP address\****
  - Action      : Select **Block**
- Once you provide the above details, click on **Add rule**.
- Lastly click on **Next**.

1. **Set rule priority**

- Leave as default and click on **Next**.

1. **Configure metrics**

- Leave as default and click on **Next.**

1. **Review and create web ACL**

- Review all your inputs and click on **Create web ACL**

1. Wait for 1 or 2 minute until you will see that your web ACL is successfully created.

![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image18.png)

1. You have successfully created a web ACL for ALB with the help of an IP set created with your public IP.

## Task 8: Testing the working of the WAF

1. To test the WAF, navigate to **Load Balancers** from the EC2 left menu under the sub-heading **Load balancing**
2. Under the Load balancer section, select the Application load balancer **Web-server-LB.**
3. Copy the DNS name under Description and paste it in your desired browser. 

- **Example**: web-server-lb-1903855210.us-east-1.elb.amazonaws.com

![img](https://play.whizlabs.org/frontend/web/media/2020/10/19/waf_lab_2.png)

1. You will get a **403 forbidden error** showing that WAF blocked your connection to ALB.

![img](https://play.whizlabs.org/frontend/web/media/2020/10/19/waf_lab_3.png)

## Task 9: Unblocking the IP 

1. To unblock the IP, navigate to **IP sets** and click on **MyIPset.** Select your public IP and then click on **Delete** 

![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image15.png)

1. Enter your IP followed by CIDR /32 from the link: https://www.google.com/search?client=firefox-b-d&q=what+is+my+ip/
2. Type **delete** in the confirmation box and click on **Delete**.
3. You have successfully removed the IP from WAF.
4. Wait for a few minutes.
5. Navigate **toLoad Balancers** from EC2 left menu under the sub-heading **Load balancing**
6. Under the Load balancer section, select the Application load balancer **Web-server-LB****.**
7. Copy the DNS name under Description and paste it in your desired browser. 

- **Example**: web-server-lb-1903855210.us-east-1.elb.amazonaws.com

1. You will get the response from the web servers either stating **RESPONSE COMING FROM SERVER 1** or **RESPONSE COMING FROM SERVER 2** as shown below:

![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image24.png)

## Task 10: Validation Test

1. Once the lab steps are completed, please click on the ![img](https://play.whizlabs.com/frontend/web/media/2021/03/17/image70.png) button on the left side panel.
2. This will validate the resources in the AWS account and displays whether you have completed this lab successfully or not.
3. Sample output :

 ![img](https://play.whizlabs.com/frontend/web/media/2021/01/23/waf_lab.png)

# Completion and Conclusion

1. You have successfully created an IP set using your public IP. 
2. You have successfully created a web ACL rule using an IP set and application load balancer (ALB).
3. You have successfully tested the working of the ALB after implementing a WAF, blocking the web request to the ALB from your local network.
4. You deleted the IP set and tested the working of the ALB.

# End Lab

1. Sign out from the AWS Account.
2. You have successfully completed the lab.
3. Once you have completed the steps click on ![img](https://play.whizlabs.com/frontend/web/media/2019/12/30/image4.png) from your whizlabs dashboard



 

 