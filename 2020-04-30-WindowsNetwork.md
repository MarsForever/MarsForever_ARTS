```
# check active port
netstat -aon | findstr :53


```

```shell
#Error
C:\Program Files\Docker\Docker\resources\bin\docker.exe: Error response from daemon: Ports are not available: listen tcp 0.0.0.0:1677: bind: An attempt was made to access a socket in a way forbidden by its access permissions.


#check cannot be used port
netsh int ipv4 show excludedportrange protocol=tcp

#add port 
#https://www.kaoriya.net/blog/2019/11/02/
netsh int ipv4 add excludedportrange protocol=tcp startport=2222 numberofports=1

#delete port
netsh int ipv4 delete excludedportrange protocol=tcp startport=4000 numberofports=1

#may be you need to restart your pc
```





