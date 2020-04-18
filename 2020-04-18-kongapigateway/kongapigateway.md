### REST API Principles

* Uniform Interface
* Client-server
* Stateless: without cookies,session
* Cacheable
* Layered system
* Code on demand

### HTTP Status Codes

* 1xx: Informational
* 2xx: Success
* 3xx: Redirection
* 4xx: Client error
* 5xx: Server error

REST API, REST Service, REST Web Service(Basically, same thing)

## REST API Types

* Private/Internal
* Partner
* Public

### API Management

* Creating & publishing API
* Enforcing usage policies
* Controlling access & traffic
* Collect & analyze usage statistic
* Performance reporting
* Gateway

### API Functions

![API Functions](./images/Capture.PNG)

### API Management

![API Management](./images/Capture2.PNG)



## Single Site

### Without API Management 1

![Without API Management 1](./images/Capture3.PNG)

### With API Management 1

![With API Management 1](./images/Capture4.PNG)



## Multi Site

### Without API Management 2 

![Without API Management 2](./images/Capture5.PNG)

### With API Management 2

![With API Management 2](./images/Capture6.PNG)





## Multi Client

### Without API Management 3

![Without API Management 3](./images/Capture7.PNG)

### With API Management 3

![With API Management 3](./images/Capture8.PNG)



### Required Port

The following port must be available to be used in this course:

- **5432** : PostgreSQL. If you have PostgreSQL server currently running, please stop it since we will use Docker PostgreSQL.
- **3306**:  Mysql
- **8000** : Kong gateway
- **80** : Kong gateway (we will change later from 8000 to 80)
- **8001** : Kong admin API
- **1337** : Kong administration dashboard
- **9001, 9002, 9003, 9004** : Dummy services (alpha, beta, gamma, omega)

Optional port that used in some lectures. If you skip the lectures, you won't need these ports:

- **9411** : Zipkin. We will use it on lecture about distributed tracing
- **9200, 9600, 5555, 5601** : Elastic stack (Elasticsearch, Logstash, Kibana). We will use it on lecture about API analytics

#### API Management install Fast Installation

cd files

docker-compose up 

#### API Management install Fast Installation

execute file docker-setup.md's command

#### Dummy Service List

* Alpha
  * Virtual IP:172.1.1.1
  * Virtual DNS: alpha
* Beta
  * Virtual IP: 172.1.1.2
  * Virtual DNS: beta
* Gamma
  * Virtual IP: 172.1.1.3
  * Virtual DNS: gamma
* Omega
  * Virtual IP: 172.1.1.4
  * Virtual DNS: omega

Konga url: localhost:1337

