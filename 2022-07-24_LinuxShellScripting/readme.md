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



/vagrant/Vagrantfile

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

### 4. Script

src/luser-demo01.sh

- naming
- permissions
- variables
- builtins

```bash
#!/bin/bash

# Hello from the main OS.
echo "Hello"

WORD='script'

echo "$WORD"

echo '$WORD'

echo "This is a shell $WORD"

echo "This is a shell ${WORD}"

echo "${WORD}ing is fun!"

echo "$WORDing is fun!"

ENDING='ed'

echo "This is ${WORD}${ENDING}."

ENDING='ing'

echo "${WORD}${ENDING} is fun!"

ENDING='s'
echo "You ar going to write many ${WORD}${ENDING} in this class!"

```

output

```text
Hello
script
$WORD
This is a shell script
This is a shell script
scripting is fun!
 is fun!
This is scripted.
scripting is fun!
You ar going to write many scripts in this class!
```

luser-demo02.sh
- special variables
- pseudocode
- command substitution
- if statement
- conditionals

```bash
#!/bin/bash

#Display the UID and username of the user executing this script.
#Display if the user is the root user or not.


#Display the UID
echo "Your UID is ${UID}"

#Display the username

#new write
#USER_NAME=$(id -un)

#old write
USER_NAME=`id -un`

echo "Your username is ${USER_NAME}"

#Display if the user is the root user or not.
#new write [[ ]]
#old write [ ]
if [[ "${UID}" -eq 0 ]]
then
  echo 'You are root.'
else
  echo 'You are not root.'
fi
```

output

```
Your UID is 1000
Your username is vagrant
You are not root.
```

```
[vagrant@localhost vagrant]$ type -a exit
exit is a shell builtin
[vagrant@localhost vagrant]$ help exit
exit: exit [n]
    Exit the shell.

    Exits the shell with a status of N.  If N is omitted, the exit status
    is that of the last command executed.
[vagrant@localhost vagrant]$ help test
```

src/luser-demo03.sh

- exit statuses
- return codes
- string test conditionals
- more special variables

src/luser-demo04.sh

```bash
[vagrant@localhost vagrant]$ man useradd
[vagrant@localhost vagrant]$ sudo useradd dougstamper
[vagrant@localhost vagrant]$ sudo su - dougstamper
[dougstamper@localhost ~]$ ps -ef
dougsta+  2262  2261  0 04:15 pts/0    00:00:00 -bash
dougsta+  2285  2262  0 04:16 pts/0    00:00:00 ps -ef
exit
# adduser default config
cat /etc/login.defs
# change password
passwd
```

src/add-local-user.sh

```bash
cat /etc/passwd
# check last 3 lines.
tail -3 /etc/passwd
```

