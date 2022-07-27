### Install Centos 7

#### 01 Graphic setting

add dvd to storage

system: Pointing Device:USB Tablet(solve the mouse can't click problem)

add japanese keyboard layout

#####  method 1

NETWORK & HOST NAME => turn on

Network => Adapter 1 => Attached to NAT

​                 =>Adapter 2 => Attached to Host-only Adapter

​                                        =>VirtualBox Host-Only Ethernet Adapter #2

File => Host Network Manager => VirtualBox Host-Only  Ethernet Adapter #2 

##### method2(設定はこれのみ、02以降設定不要？)

- 該当するvirtual osを選択し、設定をクリックする

- ネットワーク=>アダブター１=>ネットワーク有効化=＞割り当て「NAT」

- 高度=>ポートファオワーディング=>新規ルール追加
  - ssh
    - 名前：ssh(例)
    - プロトコル：TCP
    - ホストIP：127.0.0.1(例)
    - ホストポート：2222(例)
    - ゲストIP：空欄
    - ゲストポート：22(sshの場合、)
  - http
    - 名前：http(例)
    - プロトコル：TCP
    - ホストIP：127.0.0.2(例)
    - ホストポート：2223(例)
    - ゲストIP：空欄
    - ゲストポート：80(httpの場合)



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

