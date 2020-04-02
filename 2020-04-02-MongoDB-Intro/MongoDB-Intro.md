## How to Learn (学習の進め方)

- lecture(レクチャー)
  - Lesson(講義)
  - Practice(演習)
- Summarize(まとめ)
- Q & A
- Remediation(補習)

RDB VS No-SQL

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
