# Part1

### Find

#### find file

find -name $filename

#### find every .txt file and has then given us the location of each one

find -name *.txt



### Grep 

grep "$keyword" $targetFile

```
grep "81.14.14.12" access.log
grep "THM" access.log
```

#### Show how many line in the file

wc -l $filename



## Shell Operation

| Symbol / Operator | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| &                 | This operator allows you to run commands in the background of your terminal. |
| &&                | This operator allows you to combine multiple commands together in one line of your terminal. |
| >                 | This operator is a redirector - meaning that we can take the output from a command (such as using cat to output a file) and direct it elsewhere. |
| >>                | This operator does the same function of the `>` operator but appends the output rather than replacing (meaning nothing is overwritten). |

#### command1 && command2

 it's worth noting that `command2` will only run if `command1` was successful.

#### Operator ">"

##### wanted to create a file named "welcome" with the message "hey"

```
tryhackme@linux1:~$ echo hey > welcome
tryhackme@linux1:~$ ls -ltr
-rw-rw-r-- 1 tryhackme tryhackme     4 Jul 30 20:09 welcome
tryhackme@linux1:~$ cat welcome
hey
```

# Part2

### ls command

#### Show all files(includes hiddenfiles files and folders with ".")

```
ls -a
```

#### show help

```
ls --help
```

#### show manual page

```
man ls
```

### file command(Determine the type of a file)

file $filename

```
tryhackme@linux2:~$ file unknown1
unknown1: ASCII text
```

## Common Directories

### /etc

a commonplace location to store system files 

sudoers.d file contains a list of the users & groups that have permission to run sudo or a set of commands as the root user.

"**passwd**" and "**shadow**" files show how your system stores the passwords for each user in encrypted formatting called sha512.

### /var

 "var" being short for variable data, is one of the main root folders found on a Linux install. This folder stores data that is frequently accessed or written by services or applications running on the system. For example, log files from running services and applications are written here (**/var/log**), or other data that is not necessarily associated with a specific user (i.e., databases and the like).

### /root

Unlike the **/home** directory, the **/root** folder is actually the home for the "root" system user. There isn't anything more to this folder other than just understanding that this is the home directory for the "root" user. But, it is worth a mention as the logical presumption is that this user would have their data in a directory such as "**/home/root**" by default. 

### /tmp

This is a unique root directory found on a Linux install. Short for "**temporary**", the /tmp directory is volatile and is used to store data that is only needed to be accessed once or twice. Similar to the memory on your computer, once the computer is restarted, the contents of this folder are cleared out.

# Part3

##**Transferring Files From Your Host - SCP (SSH)**

- Copy files & directories from your current system to a remote system

```
scp important.txt ubuntu@192.168.1.30:/home/ubuntu/transferred.txt
```

- Copy files & directories from a remote system to your current system

```
scp ubuntu@192.168.1.30:/home/ubuntu/documents.txt notes.txt 
```

### Viewing Processes

#### ps

We can use the friendly `ps` command to provide a list of the running processes as our user's session and some additional information such as its status code, the session that is running it, how much usage time of the CPU it is using, and the name of the actual program or command that is being executed:

```
root@ip-10-10-47-9:~# ps
  PID TTY          TIME CMD
 2937 pts/1    00:00:00 bash
 2958 pts/1    00:00:00 ps
```

To see the processes run by other users and those that don't run from a session (i.e. system processes), we need to provide **aux** to the `ps` command like so: `ps aux`

```
root@ip-10-10-47-9:~# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  2.5  0.2 160196  9440 ?        Ss   03:44   0:04 /sbin/init
root         2  0.0  0.0      0     0 ?        S    03:44   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        I    03:44   0:00 [kworker/0:0]
root         4  0.0  0.0      0     0 ?        I<   03:44   0:00 [kworker/0:0H]
root         5  0.0  0.0      0     0 ?        I    03:44   0:00 [kworker/u30:0]
root         6  0.0  0.0      0     0 ?        I<   03:44   0:00 [mm_percpu_wq]
```

#### top

top gives you real-time statistics about the processes running on your system instead of a one-time view. These statistics will refresh every 10 seconds, but will also refresh when you use the arrow keys to browse the various rows. Another great command to gain insight into your system is via the `top` command

#### managing processes

#### kill 

```
kill $PID
```

- SIGTERM - Kill the process, but allow it to do some cleanup tasks beforehand
- SIGKILL - Kill the process - doesn't do any cleanup after the fact
- SIGSTOP - Stop/suspend a process

#### systemctl

four options with `systemctl`:

- Start
- Stop
- Enable
- Disable

#### **An Introduction to Backgrounding and** **Foregrounding** **in Linux**

Here we're running `echo "Hi THM"` , where we expect the output to be returned to us like it is at the start. 

But after adding the `&` operator to the command, we're instead just given the ID of the echo process rather than the actual output -- as it is running in the background.

```
tryhackme@linux3:~$ echo "HI THM"
HI THM
tryhackme@linux3:~$ echo "HI THM" &
[1] 1157
tryhackme@linux3:~$ HI THM

```

This is great for commands such as copying files because it means that we can run the command in the background and continue on with whatever further commands we wish to execute (without having to wait for the file copy to finish first)

We can do the exact same when executing things like scripts -- rather than relying on the & operator, we can use `Ctrl + Z` on our keyboard to background a process. It is also an effective way of "pausing" the execution of a script or command like in the example below:

#### **Foregrounding a process**

With our process backgrounded using either `Ctrl + Z` or the `&` operator, we can use `fg` to bring this back to focus like below, 

where we can see the `fg` command is being used to bring the background process back into use on the terminal, where the output of the script is now returned to us.

##  Maintaining Your System: Automation

We're going to be talking about the `cron` process, but more specifically, how we can interact with it via the use of `crontabs` . Crontab is one of the processes that is started during boot, which is responsible for facilitating and managing cron jobs.

| Value | Description                               |
| ----- | ----------------------------------------- |
| MIN   | What minute to execute at                 |
| HOUR  | What hour to execute at                   |
| DOM   | What day of the month to execute at       |
| MON   | What month of the year to execute at      |
| DOW   | What day of the week to execute at        |
| CMD   | The actual command that will be executed. |

You may wish to backup "cmnatic"'s "Documents" every 12 hours. We would use the following formatting: 

```
0 *12 * * * cp -R /home/cmnatic/Documents /var/backups/
```

An interesting feature of crontabs is that these also support the wildcard or asterisk (`*`). If we do not wish to provide a value for that specific field, i.e. we don't care what month, day, or year it is executed -- only that it is executed every 12 hours, we simply just place an asterisk. `*12`

Crontabs can be edited by using `crontab -e`, where you can select an editor (such as Nano) to edit your crontab.

## Maintaining Your System: Package Management

### Introducitn Packages & Softare Rpos

When using the`ls`command on a Ubuntu 20.04 Linux machine, these files serve as the gateway/registry. 

```
ls /etc/apt
```

Whilst Operating System vendors will maintain their own repositories, you can also add community repositories to your list! This allows you to extend the capabilities of your OS. Additional repositories can be added by using the `add-apt-repository`command or by listing another provider! For example, some vendors will have a repository that is closer to their geographical location.

### Managing Your Repositories (Adding and Removing)

adding and removing a repository using the `add-apt-repository`

Whilst you can install software through the use of package installers such as `dpkg`, the benefits of apt means that whenever we update our system -- the repository that contains the pieces of software that we add also gets checked for updates. 

### example

**1.** Let's download the GPG key and use apt-key to trust it: `wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -`

**2.** Now that we have added this key to our trusted list, we can now add Sublime Text 3's repository to our apt sources list. A good practice is to have a separate file for every different community/3rd party repository that we add.

**2.1.** Let's create a file named **sublime-text.list** in **/etc/apt/sources.list.d** and enter the repository information like so:

**2.2.** And now use Nano or a text editor of your choice to add & save the Sublime Text 3 repository into this newly created file:

**2.3.** After we have added this entry, we need to update apt to recognise this new entry -- this is done using the `apt update` command

**2.4.** Once successfully updated, we can now proceed to install the software that we have trusted and added to apt using `apt install sublime-text`

Removing packages is as easy as reversing. 

This process is done by using the `add-apt-repository --remove ppa:PPA_Name/ppa` command or by manually deleting the file that we previously fulfilled. Once removed, we can just use `apt remove [software-name-here]` i.e. `apt remove sublime-text`

##  Conclusions & Summaries

- The find command - https://tryhackme.com/room/thefindcommand
- Bash Scripting - https://tryhackme.com/room/bashscripting
- Regular Expressions - https://tryhackme.com/room/catregex
