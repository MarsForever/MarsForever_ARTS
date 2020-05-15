# DevOps Monitoring Deep Dive

https://linuxacademy.com/cp/modules/view/id/329

# Linux User Management Deep Dive

https://linuxacademy.com/cp/modules/view/id/443



# Monitoring Kubernetes With Prometheus

https://linuxacademy.com/cp/modules/view/id/285

# AIOps Essentials (Autoscaling Kubernetes with Prometheus Metrics)

https://linuxacademy.com/cp/modules/view/id/304

#### 1. Add User

adduser $username

passwd $username

usermod -aG wheel $username

``on CentOS,memeber of ``**wheel** ``group have sudo privileges`` $username => dev01

##### Switch to new user

su - $username

##### verify user can use superuser privileges

sudo ls -la /root



#### 2. Install docker

docker-installer.sh

```sh
sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
```

```
#Specific version
yum install docker-ce-xxxxx
#latest version
yum install docker-ce

# Enable sudo-less Docker
sudo groupadd docker
sudo usermod -aG docker dev01
exit
su - dev01

# Check sudo-less user can run docker
docker info
```

#### 3. Install Node.js and NPM
```shell
curl -sL https://rpm.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo chmod +x nodesource_setup.sh
sudo ./nodesource_setup.sh
sudo yum install -y nodejs
sudo yum groupinstall 'Development Tools'
```

#### 4. Add the `forethought` application to the home directory


```shell
sudo yum install git -y
git clone https://github.com/linuxacademy/content-devops-monitoring-app.git forethought
```

#### 5. Create image:

```shell
cd forethought
docker build -t forethought .
```

#### 6. Docker image:

````shell
docker image list
docker run --name ft-app -p 80:8080 -d forethgought
````





