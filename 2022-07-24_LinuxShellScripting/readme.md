### 1.Download software

#### 1.1 virtual box

http://mirror.linuxtrainingacademy.com/virtualbox/

#### 1.2 vagrant

http://mirror.linuxtrainingacademy.com/vagrant/

### 2. Create vagrant virtual os

#### 2.1 Create one virtual OS

```bash
#add new box to virtualbox
vagrant box add jasonc/centos7
#create virtualbox client folder
mkdir shellclass
cd shellclass/
mkdir testbox01
# create a new vitual os centos7
vagrant init jasonc/centos7
# power on vitualbox
vagrant up
vagrant status
# access centos7
vagrant ssh
#logout 
exit
# shutdown virtual os
vagrant halt


```

Vagrantfile

```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "jasonc/centos7"
  config.vm.hostname = "testbox01"
  config.vm.network "private_network", ip: "192.168.56.1"
end
```

```bash
# reload Vagrantfile
vagrant reload
#check it works
ping -c 3 192.168.56.1
# delete vagrant virtual OS
vagrant destroy
```



#### 2.2 Create multi virtual OS

Create multi environment

```bash
mkdir multitest
cd multitest/
# create two virtualbox
vagrant init jasonc/centos7
vagrant up
vagrant ssh test1
#logout
exit
vagrant ssh test2
ping -c 3 192.168.56.2
# You can access the files in the vagrant project directory that resides on your local machine inside the
#virtual machine. The vagrant project directory is mounted, or shared, via the /vagrant directory. The
#only file in our local directory is the Vagrantfile. You can look at the file from within the vm. Run the
#following commands while you're still logged into the test2 VM:
ls /vagrant
cat /vagrant/Vagrantfile

#logout
exit

#shutdown virtual os
vagrant halt
```



Vagrantfile

```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "jasonc/centos7"
  
  config.vm.define "test1" do |test1|
    test1.vm.hostname = "test1"
    test1.vm.network "private_network", ip: "192.168.56.2"
  end

  config.vm.define "test2" do |test2|
    test2.vm.hostname = "test2"
    test2.vm.network "private_network", ip: "192.168.56.3"
  end
end
```

### 3. basic command

```bash
type

# show bash command munual
man bash

# show shell grammer?
type -a whoami
type -a if

#show shell keyword grammer
help if

# example [[
type -a [[
[[ is a shell keyword

help [[

type -a test
test is a shell builtin
test is /usr/bin/test

# show test manual
help test | less


[vagrant@localhost vagrant]$ type -a [
[ is a shell builtin
[ is /usr/bin/[
[vagrant@localhost vagrant]$ type -a [[
[[ is a shell keyword
```



