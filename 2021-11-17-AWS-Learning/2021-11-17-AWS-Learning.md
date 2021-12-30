#### 一般的なDNS

AWSのDNS
AWS Provided DNS
Route53 Resolver

AWSのNTP

Amazon Time Sync Service

`chrony` クライアントを使用して、インスタンスに Amazon Time Sync Service を設定する

https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/set-time.html



#### DNS

- SOA: SOAレコードとは、DNSで定義されるそのドメインについての情報の種類の一つで、ゾーンの管理のための情報や設定などを記述するためのもの。
  - ゾーンの管理とは

- Aレコード:A(Address)レコードは、IPｖ4でホスト名とIPアドレスの関連づけを定義するレコードです。
- Cレコード:CNAMEレコードは正規ホスト名に対する別名を定義するレコードです。
  - なぜ別名が必要なのか

- TTL :Time To Liveの略称。パケットの有効期間を表す値となり、数値が小さいほどレコードの保持時間が短くなります。

https://help.onamae.com/answer/7883

https://e-words.jp/w/SOA%E3%83%AC%E3%82%B3%E3%83%BC%E3%83%89.html



#### VPC Endpoint 

- Gateway VPC Endpoint

  - S3
  - DynamoDB

  > it uses routes an prefix lists to rout privately to AWS Cloud Services

- Interface VPC Endpoint

  - (powered by AWS PrivateLink) special elastic network interfaces in VPC
  - create endpoint network interfaces in the subnets
  - uses IPV4 addresses

Endpointがあるとき、とないときEC2インスタンス/Cloudwatchの違い

> EndpointとEC2は同じsubnetにある際、AWSのサービスにアクセスできる

Endpointのメリット

> VPC endpoint does not require a NAT Gateway, NAT instance, Internet Gateway, or any VPN services to access AWS Services.



> There are two types of VPC endpoints: Gateway and Interface.

IGAがあるとき、EC2をネットにつながる、つながらないときの違い



#### セキュルティグループとACLの違い

| セキュリティグループ設定                                     | ネットワークACLs設定                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| サーバー単位で適用する                                       | VPC/サブネット単位で適用する                                 |
| ステートフル(インバウンド※1 のみの設定でアウトバウンド※2 も許可される) | ステートレス(インバウンド設定のみではアウトバウンドは許可されない) |
| 許可のみをin/outで指定                                       | 許可と拒否をin/outで指定                                     |
| デフォルトではセキュリティグループ内通信のみ許可             | デフォルトではすべての通信を許可                             |
| すべてのルールを適用                                         | 番号の順序通りに適用(複数の通信制御を設定した場合、上のだけ適用されて後ろは適用されないこともある) |

https://qiita.com/mzmz__02/items/25e3208a30c94f4af1d7





Firewall,IDS/IPS、WAFの違い:該当するIOS層が違う?

WAF: Application: HTTP/HTTPS　第7層アプリケーション

IPS/IDS: TCP/UDP　第4層トランスポート

Firewall: IP　第3層ネットワーク







L3 Routing VS NAT

>  ルーティングとは異なるネットワークアドレスにパケット（データ）を送る行為のことです。主にルータがこの役割をします。

> NATとはパケットの送信元アドレスや送信先アドレスを変換することを言います。

> ルータの本来の役割はルーティングであり、ルーティングする際に、NATも同時にするかどうかというだけです。
>
> ただ、ほとんどのルータはNATの機能が付いていています。

L2 Switch と L3 Switchの違い

> 一方、同じルーティングの機能を持つL３スイッチなどは、ルーティングの機能を持ちルータとよく似ていながら、NATの機能を持たないものが多いです。その代わりL2スイッチの機能を持つ
>
> L2スイッチ：データリング層
>
> L3スイッチ：ネットワーク層

https://itsakura.com/network-switch





VPC同士の接続パターンまとめ　6種類

  1. VPCピアリング
  2. AWS Transit Gateway
  3. ソフトウェア サイト間VPN
  4. ソフトウェアVPN to AWSマネージドVPN
  5. AWSマネージドVPN
  6. AWS PrivateLink

https://dev.classmethod.jp/articles/whitepaper-vpc-conectivity-options-02/



#### VPC Flow Logs

>



#### KMS(AWS Key Management Service)

- **Signing Requests**: can use the aws security token service to generate temporary security credentials 

https://docs.aws.amazon.com/kms/latest/APIReference/Welcome.html

