### Install Centos 7

#### 01 Graphic setting

add dvd to storage

system: Pointing Device:USB Tablet(solve the mouse can't click problem)

add japanese keyboard layout

NETWORK & HOST NAME => turn on

Network => Adapter 1 => Attached to NAT

​                 =>Adapter 2 => Attached to Host-only Adapter

​                                        =>VirtualBox Host-Only Ethernet Adapter #2

File => Host Network Manager => VirtualBox Host-Only  Ethernet Adapter #2 

```
#Important
#You should configure adapter manually or it will change ip#
#check DHCP Server
Lower Address Bound
Upper Address Bound

check Adapter
```



#### 02 upgrade yum

yum update -y

yum install -y vim

#for ifconfig command

yum install -y net-tools



#### 03 Connect to Host

Windows

```
Ethernet adapter VirtualBox Host-Only Network #2:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : xxxxxxxxxxxxxxxxxxxx
   IPv4 Address. . . . . . . . . . . : 192.168.99.1
   Subnet Mask . . . . . . . . . . . : xxxxxxxxxxxxxxxxxxxx
```

 nmtui

```
setting 
Address:range Lower Address Bound ~ Upper Address Bound
Gateway:192.168.99.1(Windows)
```

 systemctl restart  NetworkManager
 systemctl restart  network

```
#From windows
ping $CentosIP
#From Centos
ping $WindowsIP
```

#### 04 Clone

```
nmcli connection modify enp0s8 ipv4.address $ip(between rang)
 systemctl restart  NetworkManager
 systemctl restart  network
```

#### 05 ssh using teraterm

##### Using password to login

```
"C:\Program Files (x86)\teraterm\ttermpro.exe" $ip:22 /auth=passwd /user=$username /passwd=$password
```



##### Using rsa key to login

```
"C:\Program Files (x86)\teraterm\ttermpro.exe" $ip:22 /auth=publickey /user=$username /passwd=$password /keyfile=$.ssh\id_rsa
```

