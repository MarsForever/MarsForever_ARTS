#### 0 Firewall Setting

##### 1. [+] create new zone for elk service

firewall-cmd --permanent --new-zone=elk

##### 2. [+] add new zong to device

#check device

#method1

firewalld-cmd --get-active-zone

#method2

ip addr

firewall-cmd --permanent --zone=elk --change-interface=enp0s3

firewall-cmd --permanent --zone=elk --change-interface=enp0s8



##### 3. [+] add serivce to new zone

firewall-cmd --permanent --zone=elk --add-service=dhcpv6-client

firewall-cmd --permanent --zone=elk --add-service=ssh

firewall-cmd --permanent --zone=elk --add-service=http



##### 4.[+] add port to service

##### add elastic port

firewall-cmd --permanent --zone=elk --add-port =9200/tcp

##### add kibana port

firewall-cmd --permanent -zone=elk --add-port=5601/tcp

##### 5. [*] apply the setting to firewalld and change the default zone

firewall-cmd --reload

firewall-cmd --set-default --zone=elk



#### 1 Install ELK

##### 1.[+]  Create a yum repository for elastic products
```
#Install public signing key
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

vim /etc/yum.repos.d/elastic_stack.repo
```
#Installing from the RPM repository
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```
##### 2.[+]  Install Java
```
yum install java-1.8.0-openjdk -y
```

#####  3. [+]Install elasticsearcy
yum install elasticsearch -y

#####  4.[*] Modify yml file

vim /etc/elasticsearch/elasticsearch.yml

```
network.host: $kibana_private_ip
http.port: 9200
```
#####  5.[+] Start Elasticsearch

systemctl daemon-reload

systemctl enable elasticsearch
systemctl start elasticseearch

systemctl status elasticsearch

curl localhost:9200

##### 6. [+] Install kibana
yum install kibana -y

##### 7. [*] Modify yml file

vim /etc/kibana/kibana.yml

```
server.port: 5601
server.host: "localhost"
elasticsearch.hosts: ["http://$elasticsearch_private_ip:9200"]
discovery.seed_hosts: ["elasticsearch_private_ip"]
```
#####  8. [+]Start Kibana

systemctl daemon-reload

systemctl enable kibana

systemctl start kibana

systemctl status kibana

curl localhost:5601

##### 9. [+] Install logstash





##### 10. [*]  edit yml 

vim /etc/filebeat/filebeat.yml

```
filebeat.inputs:
- type: docker
  containers.ids:
  - '*'
  paths:
  - /var/lib/docker/containers/*.log


setup.kibana:
  host: 192.168.99.105:5601


output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["http://192.168.99.105:9200"]

  # Protocol - either `http` (default) or `https`.
  #protocol: "https"
  protocol: "http"
```



# LogStash

## Data Processing with Logstash(and Filebeat)

### Section 1: Getting Started

```
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.7.0.tar.gz
tar -xzvf logstash-7.7.0.tar.gz
cd logstash-7.7.0
bin/logstash -e "input { stdin { } } output { stdout { } }"
```

Section 2: Basics of Logstash

```
mkdir pipelines
cd pipelines
vim pipelines.conf
---
input{
	stdin{
	
	}
}

output{
	stdout{
	
	}
}
---
cd ../..
bin/logstash -f config/pipelines/pipeline.conf
abc
```

pipeline.conf

**in version 7.7 it's same to the before conf file**

```
input{
	stdin{
	
	}
}

output{
	stdout{
		codec => rubydebug
	}
}
input:
abc
output:
{
          "host" => "ELK",
      "@version" => "1",
    "@timestamp" => 2020-05-14T13:25:42.431Z,
       "message" => "abcd"
}
```

### 6. Handling JSON input

```
bin/logstash -f config/pipelines/pipeline.conf
input:
{ "amount": 10, "quantity": 2}
output:
{
    "@timestamp" => 2020-05-14T13:21:38.426Z,
      "@version" => "1",
       "message" => "{ \"amount\": 10, \"quantity\": 2}",
          "host" => "ELK"
}
```



```
vim config/pipelines/pipeline.conf
---
input{
	stdin{
		codec => json
	}
}

output{
	stdout{
		codec => rubydebug
	}
}
---
bin/logstash -f config/pipelines/pipeline.conf
input:
{ "amount": 10, "quantity": 2}
output:
{
          "host" => "ELK",
    "@timestamp" => 2020-05-14T13:27:22.240Z,
      "@version" => "1",
        "amount" => 10,
      "quantity" => 2
}

input:
[ { "name": "order1"}, {"name": "order2"}]
output:
{
          "host" => "ELK",
    "@timestamp" => 2020-05-14T13:29:26.095Z,
          "name" => "order2",
      "@version" => "1"
}
{
          "host" => "ELK",
    "@timestamp" => 2020-05-14T13:29:26.095Z,
          "name" => "order1",
      "@version" => "1"
}

input:
{ invalid json }
output:
{
          "host" => "ELK",
    "@timestamp" => 2020-05-14T13:30:25.993Z,
          "tags" => [
        [0] "_jsonparsefailure"
    ],
      "@version" => "1",
       "message" => "{ invalid json }"
}
```



### 7. Outputting events to file

```
vim config/pipelines/pipeline.conf
---
input{
	stdin{
		codec => json
	}
}

output{
	stdout{
		codec => rubydebug
	}
	file {
	   path => "output.txt"
	}
}
---
input:
{ "amount": 10, "quantity": 2}
output:
{
      "@version" => "1",
      "quantity" => 2,
        "amount" => 10,
    "@timestamp" => 2020-05-14T14:16:11.378Z,
          "host" => "ELK"
}
[2020-05-14T10:16:12,213][INFO ][logstash.outputs.file    ][main][9864b56af4c10e48b43a086789ba1d9a423a5839fecb7ae25cf2ede92b325678] Opening file {:path=>"/root/logstashs/logstash-7.7.0/output.txt"}
```



https://github.com/codingexplained/data-processing-with-logstash



### 8. Working with HTTP input

### 9. Filtering events

### 10. Common filter options

### 11. Understanding the Logstash execution model

### 12.Section wrap up

### Section 3: Project Apache

### 14. Automatic config reload & file input

### 15. Parsing request with Grok

### 16. Finishing the Grok pattern
### 17.Accessing field values
### 18. Formatting dates
### 19. Setting the time of the event

### 20. Introduction to conditional statements

### 21. Working with conditional statements



### Section 4: Collecting Logs with Filebeat



### 51. Handling multiline logs - approach #2

### 52. Wrap up

### Section 5: COnclusion





#### Learning Outcomes

* Explain the features and utility of LogStash
* Install and configure LogStash
* Improve work/ project / career prospects

## Chapter2:Getting Started With LogStash

### Define

* open source
* server-side data processing pipeline that ingests data from a multitude(much) of sources simultaneously, transforms it,and then sends it to a specified output.
* Anaylysis
* Archiving
* Monitoring
* Alerting

#### Importance of LogStash

* Open source data collection engine
* Centralize data processing of all types
* Normalized(归一化) varying（不同的） schema for business critical（重要的） data
* Support for multiple and custom formats
* Extensibility(可扩展性) via plugins

#### Core Features

* Data ingestion(汲取) workhorse(重负荷机器)
* Events envirchment(充实？) and transformation(改变)
* Extensible(可扩展的) plugin ecosystem
* It is highly available, scalable and elastic in nature(Pluggable pipeline architecture)
* Horizontally scalable data processing pipeline
* Strong Elasticsearch and Kibana synergy(协同作用)
* Handles data of all shapes and sizes

#### LogStash Versatility(多功能，多用途)
* Analysis
* Archiving
* Search
* Monitoring
* Alerting

#### Components and Terminology

* INPUTS
  * Specifiy the source of events LogStash can handle variety of sources
  * Most commont ones are:
    * Logs
    * Network
    * Web
    * Data stores and streams
    * Sensors and IoT
* FILTERS
  * Responsible for parsing the incoming events
  * May enrich(充实) the events
  * Most common ones are:
    * grok(深刻了解，心意相通)
    * mutate(转换)
    * drop(减少)
* OUTPUTS
  * Final stage of the pipeline: Sends the enriched output to a specified destination
  * LogStash can handle variety of destinations
    * ElasticSearch
    * AWS S3 buckets
    * Files

![](./images/image01.PNG)



## Chapter 3: LogStash in Action

### The Pre-requisites

* Prerequisites
  * requires Java 7 or higher
* Installation steps
  * Download from elastic.co web site
  * Use Linux package manager to install
  * Logstash
  * Install LogStash as a service
  * [Download URL1](https://www.elastic.co/downloads/logstash) 
  * [DownloadURL2](https://www.elastic.co/guide/en/logstash/current/installing-logstash.html)

~~sudo chown -R $(whoami) $(brew --prefix)/*~~

~~https://qiita.com/ArcCosine@github/items/2b8417fb3a0759045edb~~

~~brew install dpkg~~

~~sudo dpkg -i logstash-7.6.2.deb~~

```shell
#install xcode
xcode-select --install
#install gcc
brew install gcc
#tap the Elastic Homebrew repository
brew tap elastic/tap
#install the default distribution of Logstash
brew install elastic/tap/logstash-full
#start logstash with homebrew
brew services start elastic/tap/logstash-full
# run logstash
logstash

```

#### Simple LogStash piepline

```shell
#/usr/local/Cellar/logstash-full/7.6.2/libexec/config/pipelines.yml
inputs{
	stdin{}
}
#optional
filter{
  
}
output{
	stdout{}
}

#logstash -f pieplines.yml
```

```shell
logstash -e 'input{ stdin{} } output{ stdin{} }'
#type "Hello World"
```



Advanced Pipeline

![Advanced Pipeline](./images/image02.PNG)



### LogStash Plugins

![](./images/image03.PNG)

#### Input Plugin

![](./images/image04.PNG)

#### Filter Plugin

![](./images/image05.PNG)

#### Output Plugin

![](./images/image06.PNG)

#### Input Plugins

```pipelines.yml
#ElasticSearch input plugin
input{
	# read all documents from elasticsearch
	elasticsearch{
		hosts	=> "$ip"
		indes	=> "$name"
		query => '{ "$ip"}:{"match_all"}:{}}}'
		type => "my-data-elasticsearch"
	}
}

#File input
inputs{
# Read events from file of folder
	file{
		path => "/var/log/*"
		execlue => "*.gz"
		sincedb_path => "/dev/null"
		start_position => "beginning"
		type => "my-data-csv"
	}
}

#JDBC input
input{
	# read all records from mySQL
	# database
	jdbc {
		jdbc_driver_library => "/opt/longstash/lib/mysql-connector-java-5.1.6-bin.jar"
		jdbc_driver_class => "com.mysql.jdbc.Driver"
		jdbc_connection_string => "jdbc:mysql://localhost:3306/mydb"
		jdbc_user => "root"
		jdbc_password => "password"
		statement => "SELECT * from users"
	}
}

# AWS S3 input
input{
	# read all documents from aws s3
	s3{
		bucket => "my-bucket"
		credentials => ["my-aws-key", "my-aws-token"]
		region_endpoint => "us-east-1"
		codec => "json"
	}
}

#TCP input
input{
	# read all events over TCP socket
	tcp{
		port => "5000"
		type => "syslog"
	}
}

#UDP input
input{
	# read all events over UDP port
	udp{
		port => "5001"
		type => "netflow"
	}
}
```

#### filter plugins

```yml
# CSV filter
filter{
	csv{
	# List of columns as they appear in csv
		column => ["column_1", "column_2"]
		column => {"column_3"=>"integer","column_4"=> "boolean"}
		type => "syslog"
	}
}

# timestamp in ISO8601 format
# exmaple "Jan 01 10:40:01" => "MMM dd HH:mm:ss"

# data filter
filter{
	data{
		match =>["logdate", "MMM dd HH:mm:ss"]
		# Default for target is @timestamp
		target => "logdate_modified"
	}
}

# drop filter
filter{
	# drop the events of their loglevel is debug
	drop{
		if[loglevel] == "debug"{
			drop{}
		}
	}
}
```

#### filter range

```yaml
#range filter
filter{
	range{
		ranges=>["request_time",0, 10,"tag: short",
						 "request_time",11, 100,"tag: medium",
						 "request_time",101, 1000,"tag: long",
						 "request_time",1001, 100000, "drop",
						 "request_length",0, 100,"field:size:small",
						 "request_length",101, 200, "fiedl: size: normal",
						 "request_length",201, 1000, "field: size: big",
						 "request_length",1001, 100000, "fiedl: size: hugel",
						 "number_of_requests",0, 10, "tag:request_from_%{host}"]
	}
}
```

#### filter grok

* Grok is one of the most widely used plugin
* It is instrumental in parsing arbitrary and unstructured text into structed and queryable data field
* It is widely used to parse syslog, apache logs,mySQL logs,cutom application logs, postifix logs etc.
* Grok works based on patterns
* Syntax for grok pattern is %{SYNTAX:SEMANTIC(语义的)}
* Custom patterns can be added

```yml
# grok filter
input{
	file{
		path => "/var/log/http.log"
		# sample log entry
		# 55.11.55.11 GET/index.html 453 12
	}
	
	filter{
		# parse http log
		grok{
			match=>{"message"=>"% {IP:client} %{WORD: method} %{URIPATHPARAM: request} %{NUMBER: duration}"}
		}
	}
}
```

Grok supports custom patterns

* inline cutom pattern using Oniguruma syntax
* file based custom patterns

## Beats

### Key takeways

* Beats is collection of light-weight data shippers
* They are installed on servers and send data to outputs
* The most commonly used Beats are FileBeat and MetricBeat
* Modules reduce configuration and provide Kibana dashboards
* Sending data over the network has numerous advantages



FileBeat

https://www.elastic.co/blog/enrich-docker-logs-with-filebeat





Elastic Stack Essentials (Legacy)

https://linuxacademy.com/cp/modules/view/id/193

Elasticsearch Deep Dive

https://linuxacademy.com/cp/modules/view/id/213

Elastic Stack Essentials

https://linuxacademy.com/cp/modules/view/id/503

The Linux Academy Elastic Certification Preparation Course

https://linuxacademy.com/cp/modules/view/id/409

Course data mining

https://www.coursera.org/learn/data-manipulation/lecture/goGJR/appetite-whetting-extreme-weather



Complete Guide to Elasticsearch

https://www.udemy.com/course/elasticsearch-complete-guide/



ElasticSearch, LogStash, Kibana ELK #1 - Learn ElasticSearch

https://learning.oreilly.com/videos/elasticsearch-logstash-kibana/9781788999816?autoplay=false



ElasticSearch, LogStash, Kibana ELK #2 - Learn LogStash

https://learning.oreilly.com/videos/elasticsearch-logstash-kibana/9781788997904



ElasticSearch, LogStash, Kibana ELK #3 - Learn Kibana

https://learning.oreilly.com/videos/elasticsearch-logstash-kibana/9781788991193



ElasticSearch, LogStash, Kibana (the ELK Stack) # 1

https://learning.oreilly.com/videos/elasticsearch-logstash-kibana/100000006A0739

ElasticSearch, LogStash, Kibana (the ELK Stack) # 2

https://learning.oreilly.com/videos/elasticsearch-logstash-kibana/100000006A0740