### Pseudo File Systems

#### proc

Contains information about the processes running on a system. Processes are listed by PID, with hardware and process data both in the same directory structure

```shell
cd /proc
#show blue directories in left side,which running on the computer of pid(process id)
#example
#partitions,uptime,cpuinfo,meminfo,version
ls
#
ls 1/
```





#### sys

Contains information about the system’s hardware and kernel modules. No process information listed here



#### man proc

Shows local documentation on the /proc pseudo file system