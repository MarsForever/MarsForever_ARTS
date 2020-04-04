## How to Learn (学習の進め方)

- lecture(レクチャー)
  - Lesson(講義)
  - Practice(演習)
- Summarize(まとめ)
- Q & A
- Remediation(補習)

RDB(Relational Database) VS No-SQL(Not only SQL)

### RDB

- データ構造

　「表」と「表同士の関係性」でデータ構造を表現するデータベース

- トランザクション

　ACID特性(データ不整合が起こらないようにする)

- Product
  - Oracle Database
  - Microsoft SQL Server
  - MySQL
  - PostgreSQL

### No-SQL

- データ構造
RDB以外の構造で保存される
KVS型、ドキュメント型、グラフ型など
- トランザクション
　結果整合性(速度を優先で即座にデータ反映されていないこともある)
- Product
　- KVS
　　- redis
　　- Riak
　- Document
　   - mongoDB
　- Graph
　   - neo4j

### MongoDB の特徴
- データ構造
  - ドキュメント型(入れ子構造が取れる)
  - スキーマレス(定義なし、実行中でもスキーマを自由に変更できる)
- クエリ
  - 集約(Aggregation)　⇒　複雑な条件の集計を行う機能
  - テキストインデックス　⇒　全文検索 MongoDB 4.0は日本語未対応
  - 地理空間クエリ　⇒　GeoJSONを重なり検索や位置検索できる機能
- 性能
  - インデックスサポート(RDBと同様)
- レプリケーション
  - リプリケーションによる冗長性の確保(データを複数のサーバーに複製して同期する機能)
- スケールアウト
  - シャーディングによる水平拡張　※シャーディング：データを複数のサーバーに分散させる機能

## RDBとMongoDB

| Excel         | Oracle | MongoDB    |
| ------------- | ------ | ---------- |
| Book(ブック)  | Schema | Database   |
| Sheet(シート) | Table  | Collection |
| Column(行)    | Row    | Document   |
| Row(列)       | Column | Field      |
| cell(セル)    | Field  | Value      |

### MongoDBの"_id"

- ドキュメント挿入時に自動採番されるユニークキー


## Section 3:環境準備
###  6. Windows 10 へインストール

1. [ダウンロード　4.0.1 windows Enterprise ](https://www.mongodb.com/download-center/community)

2. インストール
   * uncheck [Install MongoDB as Service]
   * checked [Install MongoDB Compass]
   
3. 環境変数設定
   
   * add %Program Files%\MongoDB\Server\4.0\bin to System variables Path
   
4. フォルダ準備

   create new folder MongoDB under C driver

   cd MongoDB 

   tree 

   C:.
   └───server
       ├───data
       └───log

### 7. サーバー起動/終了
mongod(MongoDBサーバーの本体)
- MongoDBのメインプロセス

  データ操作、アクセス管理、バックグラウンド操作を実行。

- 起動

  mongod

  --bind_ip [ip]

     接続監視するIPアドレスを指定。デフォルト 127.0.0.1

  --port [number]

    接続可能なポート番号を指定。デフォルト 27017

  --dbpath [path]

    DBファイルの保存先ディレクトリを指定

  -- logpath [path]

    ログの保存先ファイルパスを指定

- 終了

  mongod実行中プロセス上

  ```shell
  Ctrl + c
  ```

  mongoクライアント上

  ```shell
  db.adminCommand({shutdown: 1, force: true})
  ```

launch cmd as adminstrator

cd C:\MongoDB\server

mongod -dbpath "C:\MongoDB\server\data" --logpath "C:\MongoDB\server\log\mongod.log"

### 8.設定ファイルの基本

- サーバー起動

  ```
  mongod
  ```

  --config [path]

  ​	設定ファイルのファイルパスを指定

- 設定ファイル(mongod.cfg)

  yaml形式

  ```yaml
  systemLog:
    destination: file
    path: C:\MongoDB\server\log\mongod.log
  storage:
    dbpath: C:\MongoDB\server\data
  net:
    bindIp: 127.0.0.1,xxx.xxx.xxx.xxx
    port:27017
  ```

- 設定ファイルのリファレンス

  - 設定ファイルのオプション情報

    [Reference > Configuration File Operations](https://docs.mongodb.com/v4.0/reference/configuration-options/)

1. 設定ファイルの準備
　create mongod.cfg under C:\MongoDB\server

```cfg
　systemLog:
　  destination: file
　  path: C:\MongoDB\server\mongod.log
　  logAppend: true
　storage:
　  journal:
　    enabled: true
　  dbPath: C:\MongoDB\server\data
　net:
　  bindIpAll: true
　  port: 27017
　```
　
2. MongoDBサーバー起動

    mongod --config "C:\MongoDB\server\mongod.cfg"

### 9. Windows サービスへ登録

- フォルダ/ファイル準備

  以前のフォルダ構造を参照

- サービス登録

  ```shell
  mongod --config "[FILE_PATH]" --install
  --config 設定ファイルへのパスを指定
  --install Windowsサービスに "MongoDB"という名前でサービスを登録
  ```

  check MongoDB is installed in Services

- サービス解除

  ```shell
  mongod --remove
  --remove Windowsサービスの登録を解除
  ```

### 10.サンプルデータ投入

- サンプルデータのテーマ

  - 本のレビューを題材とするデータベース

- データ構造(ER図)

  ![ER図](C:\Users\marsforever\git_repositories\MarsForever_ARTS\2020-04-02-MongoDB-Intro\images\Capture1.PNG)

- データ投入/削除に利用するコマンド

  ```shell
  mongo <URL> <JS_FILE>
  URL
      データベース接続先。IPアドレス、ポート、データベースを指定
      例) 127.0.0.1:27017/booklog
  JS_FILE
  	実行JavaScriptスクリプトファイル  
  ```

  1. データ投入

     ```bash
     #Start MongoDB service
     
     cd $MarsForever_ARTS\2020-04-02-MongoDB-Intro\file\10_insert_data
     #insert data
     mongo 127.0.0.1:27017/booklog ./insert.js
     MongoDB shell version v4.0.17
     connecting to: mongodb://127.0.0.1:27017/booklog?gssapiServiceName=mongodb
     Implicit session: session { "id" : UUID("54a95322-01f6-4dd7-a77c-2fcd2f720736") }
     MongoDB server version: 4.0.17
     
     #login to 
     mongo
     
     #Enter database booklog
     use booklog
     
     #show collections
     show collections
     ```

  2. データ削除

     mongo 127.0.0.1:27017/booklog ./drop.js

## Section 4:基本操作

### 12.サーバ接続/切断

- mongo

  - MongoDBへアクセスするクライアントアプリケーション

- mongo と mongo

  mongod MongoDBサーバーアプリケーション

  mongo MongoDBクライアントアプリケーション

- サーバー接続

  ```shell
  mongo <IP><:PORT></DATABASE>
  IP
  接続先IPアドレスを指定。デフォルト"127.0.0.1"
  PORT
  接続先ポート番号を指定。デフォルト"27017"
  DATABASE
  接続先データベース名。デフォルト"test"
  ```

  

- サーバー切断

  ```
  #method 1
  exit
  
  #method 2
  Ctrl + c
  ```

- 





https://medium.com/@alexrenoki/when-to-use-nosql-getting-started-with-mongodb-in-laravel-f5376ceaf545



https://github.com/jenssegers/laravel-mongodb