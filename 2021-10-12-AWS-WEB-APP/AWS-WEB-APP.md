

![](./images/Screenshot_1.png)

![](./images/Screenshot_2.png)

### よく見るあの絵の入手と利用

1.公式アーキテクチャアイコン

https://aws.amazon.com/jp/architecture/icons/

2.draw.io

### 作成するWebアプリケーション

![](./images/Screenshot_3.png)

![](./images/Screenshot_4.png)

## Section 5 [VPC]ネットワーク設定

#### IPアドレスとは

![](./images/Screenshot_5.png)

####　グローバルとプライベート

> インターネットから見て一意に特定できるのがグローバルIPアドレス
>
> 内部で独自に降っているのがプライベートIPアドレス
>
> 独自に振っているIPアドレスは他の場所で被ることもある
>
> 例：A社とB社のプライベートアドレスが一つのネットワークに作られることがある

> グローバルアドレスとプライベートアドレスを変換してくれるのがルーター
>
> ルーターは異なるネットワークをつなぐものになる

#### IPアドレスとサブネットマスク

![](./images/Screenshot_6.png)



#### CIDR

![](./images/Screenshot_7.png)

### VPC とは

![](./images/Screenshot_8.png)

![](./images/Screenshot_9.png)

![](./images/Screenshot_10.png)

### VPCの作成

1. "192.168.0.0/20"のVPCの作成

![](./images/Screenshot_11.png)

![](./images/Screenshot_12.png)

> VPC => VPC作成
>
> VPC名前 "tastylog-dev-vpc"

### サブネットの作成

#### サブネットとは

![](./images/Screenshot_13.png)

![](./images/Screenshot_14.png)

サブネットマスク

![](./images/Screenshot_15.png)

![](./images/Screenshot_16.png)

![](./images/Screenshot_17.png)

![](./images/Screenshot_18.png)

#### サブネットを作成する

> VPC => サブネット => サブネット作成する

![](./images/Screenshot_19.png)

> 同様に残りの三つを作成する

![](./images/Screenshot_20.png)

### ルートテーブルの作成

![](./images/Screenshot_21.png)

![](./images/Screenshot_22.png)

![](./images/Screenshot_23.png)

![](./images/Screenshot_24.png)

![](./images/Screenshot_25.png)

#### ルートテーブル作成

> VPC => ルートテーブル　=> ルートテーブル作成

![](./images/Screenshot_26.png)

> 同様にprivateのも作成する

![](./images/Screenshot_27.png)



#### ルートテーブルにサブネットを関連付ける

ルートテーブルから「tastylog-dev-public-network」を選択する

サブネットの関連付け => サブネットの関連付けを編集を選択する

![](./images/Screenshot_28.png)

publicのネットワークを関連付けし、保存ボタンを押下する

![](./images/Screenshot_29.png)

> 同様にprivateも作成する

![](./images/Screenshot_30.png)





### セキュリティグループの作成

![](./images/Screenshot_31.png)

![](./images/Screenshot_32.png)

![](./images/Screenshot_33.png)

##### Webサーバー

![](./images/Screenshot_34.png)


> VPC => セキュリティグループ => セキュリティグループ作成

![](./images/Screenshot_38.png)

> どこからもアクセスするように「0.0.0.0」と設定する



![](./images/Screenshot_39.png)

> app　セキュリティグループ未作成ので、とりあえず「0.0.0.0」とする

##### APサーバー

![](./images/Screenshot_35.png)

![](./images/Screenshot_40.png)

> ソースの検索のところをweb セキュリティグループとする



![](./images/Screenshot_41.png)

> S3「 * 61a *」を選択する

![](./images/Screenshot_42.png)



> 漏れたmysqlを追加する

![](./images/Screenshot_43.png)

##### 管理運用

![](./images/Screenshot_36.png)

![](./images/Screenshot_44.png)

![](./images/Screenshot_45.png)

##### DBサーバー

![](./images/Screenshot_37.png)

![](./images/Screenshot_46.png)

![](./images/Screenshot_47.png)

すべてのセキュリティグループ

![](./images/Screenshot_48.png)



web セキュリティグループのアウトバウンドにappセキュリティグループを追加する

![](./images/Screenshot_49.png)

app セキュリティグループのアウトバウンドに dbセキュリティグループを追加する

![](./images/Screenshot_50.png)



###　インターネットゲートウェイの作成

![](./images/Screenshot_51.png)

![](./images/Screenshot_52.png)

![](./images/Screenshot_53.png)

![](./images/Screenshot_54.png)

> VPC > インターネットゲートウェイ

インターネットゲートウェイをアタッチする

![](./images/Screenshot_55.png)

![](./images/Screenshot_56.png)

> 作成したVPCにアタッチする



> ルートテーブルにインターネットゲートウェイを追加する

![](./images/Screenshot_57.png)

## Section6: [EC2]アプリサーバ作成

![](./images/Screenshot_58.png)

![](./images/Screenshot_59.png)

![](./images/Screenshot_60.png)



![](./images/Screenshot_62.png)



![](./images/Screenshot_63.png)





![](./images/Screenshot_64.png)



![](./images/Screenshot_65.png)



![](./images/Screenshot_67.png)

![](./images/Screenshot_66.png)

#### 仮想マシンのライフサイクル

![](./images/Screenshot_68.png)

![](./images/Screenshot_69.png)

![](./images/Screenshot_70.png)

![](./images/Screenshot_71.png)



![](./images/Screenshot_72.png)



![](./images/Screenshot_73.png)



![](./images/Screenshot_74.png)

![](./images/Screenshot_75.png)

![](./images/Screenshot_76.png)

### 仮想マシンへ接続(SSH)



![](./images/Screenshot_77.png)

![](./images/Screenshot_78.png)

#### 仮想マシンへファイル転送

![](./images/Screenshot_79.png)

#### ビルド/リリースプロセス

![](./images/Screenshot_80.png)

![](./images/Screenshot_81.png)

![](./images/Screenshot_82.png)



![](./images/Screenshot_83.png)





![](./images/Screenshot_83.png)

![](./images/Screenshot_84.png)







![](./images/Screenshot_85.png)









#### サービス(systemd)とは

![](./images/Screenshot_86.png)

![](./images/Screenshot_87.png)



![](./images/Screenshot_88.png)



![](./images/Screenshot_89.png)

#### サービス(systemd)操作

![](./images/Screenshot_90.png)

![](./images/Screenshot_91.png)

#### APサーバー構築

演習上は.shから実行することになります。

![](./images/Screenshot_92.png)

#### Elastic IP の取得と付与

![](./images/Screenshot_93.png)

## Section 7: [RDS]データベース作成

![](./images/Screenshot_94.png)

![](./images/Screenshot_95.png)



![](./images/Screenshot_96.png)

![](./images/Screenshot_97.png)



![](./images/Screenshot_98.png)

#### 仮想マシンからDBへ接続

![](./images/Screenshot_99.png)

![](./images/Screenshot_100.png)



```sh
yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum install -y mysql-community-client
```



![](./images/Screenshot_101.png)

#### ローカルマシンからDBへ接続

![](./images/Screenshot_102.png)

![](./images/Screenshot_103.png)

![](./images/Screenshot_104.png)

![](./images/Screenshot_105.png)



![](./images/Screenshot_106.png)

```sh
#ポートフォワーディング
ssh -i <KEYFILE> \
    -NL <LOCAL_PORT>:<DB_HOST>:<DB_PORT> \
    ec2-user@<PUBLIC_IP>

#local access
mysql -u<USER> -p<PASSWORD> -h<HOST> -P<PORT>
```



#### DBサーバ構築(初期化)

![](./images/Screenshot_107.png)

#### バックアップ

![](./images/Screenshot_108.png)



![](./images/Screenshot_109.png)



![](./images/Screenshot_110.png)







##　Section 8: [パラメータストア]　環境変数の利用

![](./images/Screenshot_111.png)



![](./images/Screenshot_112.png)



![](./images/Screenshot_113.png)

![](./images/Screenshot_114.png)

#### AWS CLIのインストールと設定



![](./images/Screenshot_115.png)

![](./images/Screenshot_135.png)



![](./images/Screenshot_135.png)

```sh
PS C:\Users\xxxx> aws --version
aws-cli/1.21.2 Python/3.8.2 Windows/10 botocore/1.22.2

PS C:\Users\marsforever> aws configure
AWS Access Key ID [****************ZRNJ]: xxxx
AWS Secret Access Key [****************TSjX]: xxxx
Default region name [None]: ap-northeast-1
Default output format [None]: json
```



#### パラメータの登録・変更・確認・削除

![](./images/Screenshot_136.png)

system manager => パラメータストア





#### パラメータストアに値を登録・確認(aws cli)

![](./images/Screenshot_137.png)



![](./images/Screenshot_138.png)

##### パス指定

![](./images/Screenshot_139.png)

![](./images/Screenshot_140.png)





![](./images/Screenshot_141.png)



```sh
#### 登録1
PS C:\Users\xxxx> aws ssm put-parameter --name /sample/dev/app/DB_USER --value admin --type String
{
    "Version": 1,
    "Tier": "Standard"
}
#system manager => path storeから確認する
#### 登録2
PS C:\Users\xxxx> aws ssm put-parameter --name /sample/dev/app/DB_PASS --value Passw0rd --type SecureString
{
    "Version": 1,
    "Tier": "Standard"
}

#更新
PS C:\Users\marsforever> aws ssm put-parameter --name /sample/dev/app/DB_USER --value root --type String --overwrite
{
    "Version": 2,
    "Tier": "Standard"
}
```

```sh
#値を取得する
PS C:\Users\marsforever> aws ssm get-parameters --names /sample/dev/app/DB_USER
{
    "Parameters": [
        {
            "Name": "/sample/dev/app/DB_USER",
            "Type": "String",
            "Value": "root",
            "Version": 2,
            "LastModifiedDate": 1634981712.196,
            "ARN": "arn:aws:ssm:ap-northeast-1:265882374955:parameter/sample/dev/app/DB_USER",
            "DataType": "text"
        }
    ],
    "InvalidParamete

#パス以下の値をすべて取得する
PS C:\Users\marsforever> aws ssm get-parameters-by-path --path /sample/dev/app/

#暗号化を解除した値を表示する
PS C:\Users\marsforever> aws ssm get-parameters-by-path --path /sample/dev/app --with-decryption
```

```sh
#値を削除する
PS C:\Users\marsforever> aws ssm delete-parameters --names /sample/dev/app/DB_USER /sample/dev/app/DB_PASS
{
    "DeletedParameters": [
        "/sample/dev/app/DB_PASS",
        "/sample/dev/app/DB_USER"
    ],
    "InvalidParameters": []
}
#GUIからも確認する

```



#### パラメータストアの値を取得(EC2)

![](./images/Screenshot_142.png)



![](./images/Screenshot_143.png)



![](./images/Screenshot_144.png)





![](./images/Screenshot_145.png)

```sh
[ec2-user@ip-192-168-1-175 ~]$ aws ssm get-parameters-by-path --region ap-northeast-1 --path /sample/dev/app/ --with-decryption
{
    "Parameters": [
        {
            "Name": "/sample/dev/app/DB_PASS",
            "DataType": "text",
            "LastModifiedDate": 1634982554.371,
            "Value": "Passw0rd",
            "Version": 1,
            "Type": "SecureString",
            "ARN": "arn:aws:ssm:ap-northeast-1:265882374955:parameter/sample/dev/app/DB_PASS"
        },
        {
            "Name": "/sample/dev/app/DB_USER",
            "DataType": "text",
            "LastModifiedDate": 1634982510.195,
            "Value": "admin",
            "Version": 1,
            "Type": "String",
            "ARN": "arn:aws:ssm:ap-northeast-1:265882374955:parameter/sample/dev/app/DB_USER"
        }
    ]
}
```





#### APサーバー再構築(1)

![](./images/Screenshot_146.png)

![](./images/Screenshot_147.png)

![](./images/Screenshot_148.png)



#### APサーバー再構築

![](./images/Screenshot_149.png)

## Section 9: [ELB] 負荷分散設定

#### ELBとは

![](./images/Screenshot_126.png)



![](./images/Screenshot_127.png)



![](./images/Screenshot_150.png)



![](./images/Screenshot_128.png)

実際はApplication　Load　BalancerとNetwork Load balancerがメイン



#### ターゲットグループ作成



![](./images/Screenshot_129.png)







![](./images/Screenshot_131.png)

![](./images/Screenshot_132.png)



![](./images/Screenshot_133.png)



![](./images/Screenshot_134.png)



#### ELBの作成

![](./images/Screenshot_151.png)

![](./images/Screenshot_152.png)

## Section10 [Route53] ドメイン取得/設定

#### Route 53 とは

![](./images/Screenshot_153.png)

![](./images/Screenshot_154.png)

![](./images/Screenshot_155.png)



#### DNS仕組み

![](./images/Screenshot_156.png)

![](./images/Screenshot_157.png)



![](./images/Screenshot_158.png)

> CNAMEレコード：別ネーム

![](./images/Screenshot_159.png)

#### Route53設定

![](./images/Screenshot_160.png)

![](./images/Screenshot_161.png)



## Section11:[ACM]証明書の発行/設定

#### HTTPS,SSL/TLS, PKI

![](./images/Screenshot_162.png)



![](./images/Screenshot_163.png)



![](./images/Screenshot_164.png)

![](./images/Screenshot_165.png)



![](./images/Screenshot_166.png)

![](./images/Screenshot_167.png)



![](./images/Screenshot_168.png)

#### ACMとは

![](./images/Screenshot_169.png)

![](./images/Screenshot_170.png)

![](./images/Screenshot_171.png)

![](./images/Screenshot_172.png)



#### 証明書の発行

![](./images/Screenshot_173.png)





![](./images/Screenshot_174.png)



#### SSL/TLSターミネーションとは

> SSL/TLS通信は復号して生の電文に戻すこと



![](./images/Screenshot_175.png)

#### ELBに証明書設定

![](./images/Screenshot_176.png)

![](./images/Screenshot_177.png)



![](./images/Screenshot_178.png)

## Section 12【S3】静的ファイル配信

#### S3とは

![](./images/Screenshot_179.png)



![](./images/Screenshot_180.png)



![](./images/Screenshot_181.png)





![](./images/Screenshot_182.png)



#### アクセス権の設定

![](./images/Screenshot_183.png)

![](./images/Screenshot_184.png)

![](./images/Screenshot_185.png)

![](./images/Screenshot_186.png)

![](./images/Screenshot_187.png)

![](./images/Screenshot_188.png)



![](./images/Screenshot_189.png)

![](./images/Screenshot_190.png)

![](./images/Screenshot_191.png)



パケットのポリシーGenerator

https://awspolicygen.s3.amazonaws.com/policygen.html



## Section 13【CloudFront】キャッシュサーバー設定

#### CloudFrontとは

![](./images/Screenshot_116.png)

![](./images/Screenshot_117.png)

![](./images/Screenshot_118.png)



![](./images/Screenshot_119.png)



![](./images/Screenshot_120.png)





![](./images/Screenshot_121.png)

![](./images/Screenshot_122.png)

![](./images/Screenshot_123.png)



![](./images/Screenshot_124.png)



![](./images/Screenshot_192.png)

![](./images/Screenshot_125.png)





#### CloudFrontの作成(オリジン設定)

![](./images/Screenshot_193.png)



![](./images/Screenshot_194.png)

#### ビヘイビア設定

![](./images/Screenshot_195.png)

![](./images/Screenshot_196.png)

## Section 14【CloudWatch】モニタリング設定

#### CloudWatchとは

![](./images/Screenshot_197.png)



![](./images/Screenshot_198.png)



![](./images/Screenshot_199.png)



![](./images/Screenshot_200.png)



![](./images/Screenshot_201.png)



![](./images/Screenshot_202.png)



#### メトリクスの確認

略

#### イベント駆動とは

![](./images/Screenshot_203.png)



![](./images/Screenshot_204.png)



![](./images/Screenshot_205.png)

![](./images/Screenshot_206.png)



![](./images/Screenshot_207.png)



![](./images/Screenshot_208.png)



![](./images/Screenshot_209.png)











## Section 15【EC2】オートスケーリング設定



## Section 16【IAM】アクセス権設定



## Section 17【SSM】運用管理アクセス経路

#### SSMとは

![](./images/Screenshot_210.png)



![](./images/Screenshot_211.png)

![](./images/Screenshot_212.png)



![](./images/Screenshot_213.png)

![](./images/Screenshot_214.png)

![](./images/Screenshot_215.png)

#### SSM利用準備(クライアント)

- インストールaws cli

- インストール aws session manager plugin

  ```sh
  PS C:\Users\marsforever> session-manager-plugin
  
  The Session Manager plugin was installed successfully. Use the AWS CLI to start a session.
  
  PS C:\Users\marsforever>
  ```

  

#### SSM利用準備(サーバー)

![](./images/Screenshot_216.png)



![](./images/Screenshot_216.png)

![](./images/Screenshot_217.png)

![](./images/Screenshot_218.png)

#### 仮想マシンへ接続(SSM)

![](./images/Screenshot_219.png)

![](./images/Screenshot_220.png)

```sh

PS C:\Users\marsforever> aws ssm start-session --target $instanceID

Starting session with SessionId: koichi_matsu-0550b6911ebc9715b
sh-4.2$
sh-4.2$ whoami
ssm-user
```

#### 仮想マシンへ接続(SSH on SSM)

![](./images/Screenshot_221.png)



![](./images/Screenshot_222.png)

事前設定.ssh/config

```
Host i-* mi-*
    ProxyCommand C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p"
```



## Section 18 おわりに
