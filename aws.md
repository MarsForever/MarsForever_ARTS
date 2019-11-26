---
title: aws
date: 2019-11-11 00:11:16
tags:

---

AWS Associate Solution的考试范围

Security（安全），Identity & Compliance（认证和协议），Compute（计算），Network & Content Delivery（网络和内容交付），Storage（存储），Databases（数据库），

AWS Global Infrasturcture（AWS全球基础设施）

* Identity Access Manangement Consists Of The Following
  * Users（用户）
  * Groups（组）
  * Roles（角色）
  * Policies（策略）

NAT Gateway
ネットワークアドレス変換 (NAT) ゲートウェイを使用して、プライベートサブネットのインスタンスからはインターネットや他の AWS サービスに接続できるが、
インターネットからはこれらのインスタンスとの接続を開始できないようにすることができます。


AWS Lambda 関数スケーリング
最初のバーストの後、関数の同時実行数は、1 分ごとにさらに 500 インスタンス増加します。

冗長化
・multi az
・data center
・ec2(autoscaling)
・managed service(s3 DynamoDB Lambda)

设计（1-2备案）
・计算 lambda ec2
・网络 cloudfront route53（故障转移方式）ELB（round robin）
・存储 s3,EFS，EC2(Snapshot)
・数据 rds(multi az),DynamoDB,Redshift,backup
・中间件服务 ElasticCache(放在rds前) AutoScaling

ELB AutoScaling

本地环境和aws环境连接
direct connection
vpn
通过网络

## 計算





## ネットワーク 

* Route53
    * シンプルルーティングポリシー
        * ドメイン特定
        * インターネットトラフィック
        * ランダムな順序で再帰的リゾルバーに返す
    * フェイルオーバールーティングポリシー
        * アクティブ・パッシブフェイルオーバー
        * 位置ルーティングポリシー
    * ユーザの場所に基づく
        * 地理的近接性ルーティングポリシー
        * リソースの場所に基づく
    * レイテンシールーティングポリシー
        * 複数の場所に基づく
        * レイテンシーが最も小さいリソース
    * 複数値回答ルーティングポリシー
        * ランダムに選ぶ
    * 最大8つの正常なレコード
    * 加重ルーティングポリシー
        * 指定した比率で複数のリソース
* Elastic Load Balancer
    * Classic Load Balancer
        * パスに基づいてリクエストを転送するルールを持つリスナーを作成できます。これは、パスルーティングと呼ばれます。マイクロサービスを実行している場合、パスルーティングを使用して1つのALBで複数のバックエンドサービスにトラフィックをルーティングすることができます。
    * Application Load Balancer
        * 複数のバックエンドサービスにトラフィックをルーティングする際はバックエンドサービスの数に合わせてCLBを設置する必要があり、構成が複雑になってしまいます。
    * Network Load Balancer 
        * OSIモデルの第 4 層で機能します。毎秒数百万のリクエストを処理できます。ロードバランサーは、接続リクエストを受信すると、デフォルトルールのターゲットグループからターゲットを選択します。リスナー構成で指定されたポート上の選択したターゲットへの TCP 接続を開こうとします。


## セキュリティ
* Amazon Cognito
    * web application mobile application 認証、許可、ユーザ管理
    * ユーザー名、パスワードでアサイン
    * Facebook,Aamazon,Googleなどのサードパーティでアサイン
    * コンポーネント：ユーザーグループ、IDグループ
        * ユーザーグループ：
            * アプリユーザーのサインアップとサインオプションを提供するユーザーディレクトリ
            * ユーザーがサインインするための組み込みのカスタマイズ可能なWeb UI
            * ユーザーディレクトリとユーザープロファイルの管理
            * 多要素認証（MFA）などのセキュリティ機能、漏洩した認証情報のチェック、アカウントの乗っ取り保護、電話とEメールによる検証
            * カスタマイズされたワークフローとAWS Lambdaトリガーによるユーザー移行
        * IDプール：AWSの他のサービスに対するアクセスをユーザーに許可する
        * 別々もしくは一緒に使用が可能
* Encryption
    * Client Side Encryption(CSE)はクライアント内で暗合したオブジェクトをS3に登録して、暗号化キーの生成・監理はクライアント側で実行します。
    * (SES-S3)
    * AWS KMS
        * 安全で可用性の高いハードウェアおよびソフトウェアを結合するサービスであり、キーの作成と管理をマネージド型サービスで提供します。
    * Server-Side Encryption with Customer-Provided Encryption Keys (SSE-C)
        暗号化をAWSではなく、ユーザである我々が管理する鍵によって行えるようになりました。
## データベース
* RDS
RDSは一般的なリレーショナルデータベースとしてデータを中長期処理するために利用されます。データ処理を行って、短期間でデータを廃棄するといったライフサイクル管理には向いていません。
* Aurora
    * リードレプリカを最大15個設置
    * 読込処理性能を向上させることが出来ます。
* DynamoDB
    * DynamoDB Accelerator (DAX)
      * ノード:DAX クラスターは、1 つのみのプライマリノードと、0～9 個のリードレプリカノードで構成されます。
      * 簡単にリードレプリカを増やせない
      * DynamoDB Accelerator(DAX) を有効化することで、1 秒あたりのリクエスト数が数百万件になる場合でも、ミリセカンドからマイクロセカンドへの最大 10 倍のパフォーマンス向上を実現します。キャッシュを利用しているため特定のデータへの処理が高い場合などに中長期的な性能向上のために有効な対策。コストが高い
      * グローバルテーブル は、マルチリージョンにマルチマスターデータベースをデプロイするための完全マネージド型のソリューションです。これにより、高い冗長化を実現することができます



## Analytics
* Amazon Athena
    * Amazon Athena はインタラクティブなクエリサービスで、Amazon S3 内のデータを標準 SQL を使用して簡単に分析できます。Athena はサーバーレスなので、インフラストラクチャの管理は不要です。実行したクエリに対してのみ料金が発生します。
    * Athena は初期状態で AWS Glue データカタログと統合されており、さまざまなサービスでメタデータの統合リポジトリを作成できます。
### Migration
* AWS Server Migration Service
    * WS Server Migration Service は、オンプレミスの VMware vSphere、Microsoft Hyper-V/SCVMM、または Azure 仮想マシンの AWS クラウドへの移行を自動化します。AWS SMS は、サーバー仮想マシンをクラウドホストの Amazon マシンイメージ (AMI) として段階的にレプリケートし、Amazon EC2 にデプロイします。

    

* AWS Glue
    * AWS Glue は抽出、変換、ロード (ETL) を行う完全マネージド型のサービスで、お客様の分析用データの準備とロードを簡単にします。

[AWS Lambda を Amazon SNS に使用する](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/with-sns.html)
- Lambda 関数を使用して、Amazon Simple Notification Service 通知を処理することができます。
- Amazon SNS は、トピックに送信されるメッセージのターゲットとして Lambda 関数をサポートしています。
- 関数は、同じアカウントまたは他の AWS アカウントのトピックにサブスクライブ(subscribe)できます。



[Lambda と Amazon SES を使用して E メールを送信するステップ](https://aws.amazon.com/jp/premiumsupport/knowledge-center/lambda-send-email-ses/)

- Lambda が API 呼び出しを実行するための AWS Identity and Access Management (IAM) アクセス許可
- 検証済みの Amazon SES ID (ドメインまたは E メールアドレス)。
- Amazon SES を介して E メールを送信するためのロジックを備えた Lambda 関数。


## Application & Integration
 * SQS
    * SQS消息队列
    * 先进先出
    * 按用收费

 * SWF
    * SWF（simple　 workflow）
    * 发起者，决策者，参与者，domains

 * swf和sqs的区别
    * swf面向任务，sqs面向消息
    * swf只执行一次不回重复；sqs可能会被处理多次

 * SES
    * Amazon SESデジタルマーケティング担当者やアプリケーション開発者がマーケティング、通知、トランザクションに関するEメールを送信できるように設計された、クラウドベースのEメール送信サービスです。

 * SNS
    * Amazon SNS を利用すれば、アプリケーションは「プッシュ」メカニズムを使用して、複数のサブスクライバーにタイミングが重要なメッセージを送信することができます。そのため、更新を定期的に確認したり、「ポーリング」したりする必要性がなくなります。
 ## HA Architecure
  * CloudFormation
    * リソースのモデル化およびセットアップに役立つサービスです。リソース管理に割く時間を減らし、AWS で実行するアプリケーションにさらに注力できるようになります。
  ### Store
    * EC2
        * EBS
            * のスナップショット取得のライフサイクルポリシーを設定できます。Amazon Data Lifecycle Manager (Amazon DLM)を使用するとEBSのバックアップであるスナップショットの作成、保存、削除を自動化できます。 定時バックアップをスケジュールして貴重なデータを保護します。
        * CloudWatch
            * CloudWatchエージェントを動かし､ログをCloudWatch Logsに転送することで、EC2インスタンスのログ管理を実施することができます。

 ## Deployment
  * Elastic Beanstalk
    * 開発されたウェブアプリケーションとウェブサービスをデプロイし、自動的にデプロイメントの詳細 (容量のプロビジョニング、負荷分散、Auto Scaling、アプリケーションのヘルスモニタリングなど) を処理します。
    * アプリケーションを実行しているインフラストラクチャについて学習することなく、AWS クラウドでアプリケーションをすばやくデプロイし、管理できます。Elastic Beanstalk は、選択肢を狭めたり制御を制限したりすることなく、管理の複雑さを軽減します。アプリケーションをアップロードするだけで、Elastic Beanstalk が自動的に容量のプロビジョニング、負荷分散、拡張、およびアプリケーションの状態のモニタリングといった詳細を処理します。
  * OpsWorks
    * OpsworksはChef や Puppet のマネージド型インスタンスを利用できるようになる構成管理サービスです。Chef や Puppet は、コードを使用してサーバーの構成を自動化できるようにするためのオートメーションプラットフォームです。OpsWorks では、サーバーのパッチ適用、アップデート、バックアップが自動的に実行され、Chef サーバーが管理されます。OpsWorks を使用すると、独自の設定管理システムを運用したり、そのインフラストラクチャを管理したりする必要がなくなります。
  * Elastic Beanstalk vs OpsWorks
    * OpsWorksはインフラ管理をメインにした環境設定の仕組みです。したがって、サーバーのパッチ適用、アップデート、バックアップの自動化というユースケースからOpsWorksと特定することができます。一方でElastic BeanStalkはウェブアプリケーションの展開に利用する仕組みです。


aws lambda
34% 回復性の高いアーキテクチャを設計する
24% パフォーマンスに優れたアーキテクチャを定義する
26% セキュアなアプリケーションおよびアーキテクチャを規定する
10% コストに最適化アーキテクチャを設計する
6% オペレーショナルエクセレンスを備えたアーキテクチャを定義する

IAM是全球化的服务

新建用户没有任何的权限

疑問点
aws sample question
sample 1
sample 9

udemyAWS 認定ソリューションアーキテクト アソシエイト模擬試験問題集（5回分325問）
1回分
q4
データ処理停止時のイベントトリガーにより、モバイルにメールが通知される。


