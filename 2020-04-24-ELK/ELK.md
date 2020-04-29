## LogStash

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

![](./images/Screen Shot 2020-04-24 at 09.20.46.PNG)



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

![Advanced Pipeline](./images/Screen Shot 2020-04-25 at 21.39.36.PNG)



### LogStash Plugins

![](./images/Screen Shot 2020-04-25 at 21.42.32.PNG)

#### Input Plugin

![](./images/Screen Shot 2020-04-25 at 21.44.16.PNG)

#### Filter Plugin

![](./images/Screen Shot 2020-04-25 at 21.46.24.PNG)

#### Output Plugin

![](./images/Screen Shot 2020-04-25 at 21.47.36.PNG)

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