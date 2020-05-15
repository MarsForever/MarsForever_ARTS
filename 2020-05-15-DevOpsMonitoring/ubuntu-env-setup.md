#### 0.Using a Custom Environment
Vagrantfile
Use the following Vagrantfile to spin up an Ubuntu 18.04 server:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "app" do |app|
    app.vm.box = "bento/ubuntu-18.04"
    app.vm.hostname = "app"
    app.vm.network "private_network", ip: "192.168.50.88"
  end

end
```
Preparing the Environment
If using Vagrant or otherwise, follow these steps to set up an environment that mimics the one of our Cloud Playground:

#### 1.Install Docker and related packages:
```
 sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
 sudo apt-key fingerprint 0EBFCD88
 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
 sudo apt-get install docker-ce
```
#### 2.Enable sudo-less Docker:

```
 sudo usermod -aG docker vagrant
```

Substitute vagrant with whatever user you intend on using. Refresh your Bash session before continuing.

#### 3.Install Node.js and NPM:
```
 curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
 sudo chmod +x nodesource_setup.sh
 sudo ./nodesource_setup.sh
 sudo apt-get install nodejs
 sudo apt-get install build-essential
```
Add the forethought application to the home directory (or whatever directory you wish to work from):
```
 sudo apt-get install git -y
 git clone https://github.com/linuxacademy/content-devops-monitoring-app.git forethought
```
#### 4. Create an image:
```
 cd forethought
 docker build -t forethought .
 ```