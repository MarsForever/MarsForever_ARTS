### Section 3:環境準備

#### Terraform用IAMユーザー作成

![](./images/Screenshot_1.png)



![](./images/Screenshot_2.png)

```cmd
PS C:\Users\marsforever> aws configure
AWS Access Key ID [************NYIY]: 
AWS Secret Access Key [************ldq7]: 
Default region name [us-east-1]: ap-northeast-1
Default output format [json]: json

PS C:\Users\marsforever> aws configure --profile terraform
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

#### GitBashインストール

![](./images/Screenshot_3.png)

#### Terraformインストール

![](./images/Screenshot_4.png)

![](./images/Screenshot_5.png)

create a `.bashrc` file under C:\Users\$Username

```cmd
export PATH=$PATH:/d/git_repositories/tfenv/bin
```



```cmd
# check the version list
 tfenv list-remote
# install specific version 
$ tfenv install 0.14.6
# use the specific version
tfenv use 0.14.6
# check terraform version
$ terraform version
Terraform v0.14.6
Your version of Terraform is out of date! The latest version
is 1.1.8. You can update by downloading from https://www.terraform.io/downloads.html

# check local terraform version
$ tfenv list
* 0.14.6 (set by /d/git_repositories/tfenv/version)
```

#### git-secrets インストール

##### AWS破産

誤ってアクセスキーとシークレットキーを一般公開される

git-secrets:誤ってコミットするのを防いでくれるツール

![](./images/Screenshot_6.png)

initialize.ps1

```
git secrets --register-aws --global
git secrets --install $env:userprofile/.git-templates/git-secrets -f
git config --global init.templatedir $env:userprofile/.git-templates/git-secrets
```



![](./images/Screenshot_7.png)

initialize.sh

```
#!/bin/sh
git secrets --register-aws --global
git secrets --install ~/.git-templates/git-secrets -f
git config --global init.templatedir ~/.git-templates/git-secrets
```

はじかれることを確認する

![](./images/Screenshot_8.png)



#### VSCodeプラグインインストール

"HashiCorp Terraform"プラグインインストール

#### VSCodeデフォルトターミナルの変更

Windows推奨(GitBashが必要)

MacOSは不要

![](./images/Screenshot_9.png)

file > setting > "terminal integrated shell windows"

Edit in setting.json 



### Section 4: Terraform入門

#### はじめてのTerraform

デフォルトVPCにEC2を起動

main.tf

```tf
provider "aws" {
 profile = "terraform"
 region = "ap-northeast-1"
}

resource "aws_instance" "black-mirror" {
 ami = "$amiName"
 instance_type = "t2.micro"
}
```

実行コマンド

```shell
terraform init
terraform apply
```

#### tfstateファイル

ec2の情報が表示されます。

- iam
- instance id

#### EC2の変更(タグ追加)

```
provider "aws" {
  profile = "terraform"
  region = "ap-northeast-1"
}

resource "aws_instance" "black-mirror" {
  ami = "ami-0a3d21ec6281df8cb"
  instance_type = "t2.micro"

  tags = {
      Name = "BlackMirror"
  }
}
```

```
terraform apply
```

#### EC2の変更(再作成)

1. UserDataにnginxをインストールするスクリプトを追加する
2. tfstateの確認

main.tf

```
provider "aws" {
  profile = "terraform"
  region = "ap-northeast-1"
}

resource "aws_instance" "black-mirror" {
  ami = "ami-0a3d21ec6281df8cb"
  instance_type = "t2.micro"

  tags = {
      Name = "BlackMirror"
  }

  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}
```



疑問点：

１．演習はec2インスタンスが削除され、新しいインスタンスが作成される

２．実際はインスタンスの内容が更新された

３．作ったインスタンスはnginxをインストールされたかどうか確認できない

#### EC2の削除

```
terraform destory 
```

#### Terraform 基本構文

terraform plan

![](./images/Screenshot_10.png)

![](./images/Screenshot_11.png)

![](./images/Screenshot_12.png)

#### 

### Section 5: Terraform基本構文

#### HCL2とは

ソースコードはHCL2(HashiCorp Language2)と呼ばれる独自構文

ヒアドキュメントができる(EOFで始まると終了する構文)

ブロックタイプとラベルで構成する

![](./images/Screenshot_15.png)

![](./images/Screenshot_16.png)



#### 変数(locals, variables)

![](./images/Screenshot_17.png)





![](./images/Screenshot_18.png)



##### locals

![](./images/Screenshot_19.png)

![](./images/Screenshot_20.png)



##### variables

![](./images/Screenshot_21.png)



![](./images/Screenshot_22.png)



#### データ型

![](./images/Screenshot_23.png)

##### プリミティブ（Primitive　原始的）

![](./images/Screenshot_24.png)

##### object

![](./images/Screenshot_25.png)

![](./images/Screenshot_26.png)



##### tuple(配列)

![](./images/Screenshot_27.png)

![](./images/Screenshot_28.png)

##### list

![](./images/Screenshot_29.png)

##### map

![](./images/Screenshot_30.png)

##### set 

![](./images/Screenshot_31.png)

![](./images/Screenshot_32.png)

#### 外部から変数を与える

![](./images/Screenshot_33.png)

上書き順番：環境変数 > 変数ファイル > コマンド引数

コマンド引数(後勝ち)

##### 環境変数

![](./images/Screenshot_34.png)

##### 変数ファイルを使った上書き

![](./images/Screenshot_35.png)

##### コマンドを使った上書き

![](./images/Screenshot_36.png)

##### 変数の上書き使い分け

![](./images/Screenshot_37.png)

#### Terraform設定(terraform)

![](./images/Screenshot_38.png)

![](./images/Screenshot_39.png)

##### バージョン指定

![](./images/Screenshot_40.png)

![](./images/Screenshot_41.png)



#### プロバイダ(probider)

![](./images/Screenshot_42.png)



![](./images/Screenshot_43.png)



![](./images/Screenshot_44.png)



#### データリソース

![](./images/Screenshot_45.png)

![](./images/Screenshot_46.png)

![](./images/Screenshot_47.png)



![](./images/Screenshot_48.png)



#### 出力(output)

![](./images/Screenshot_49.png)

![](./images/Screenshot_50.png)

![](./images/Screenshot_51.png)

疑問点：ec2_instance_id以外の変数を指定することはできる?



####　リソース参照

![](./images/Screenshot_52.png)

![](./images/Screenshot_53.png)

![](./images/Screenshot_54.png)

![](./images/Screenshot_55.png)

![](./images/Screenshot_56.png)

![](./images/Screenshot_57.png)

![](./images/Screenshot_58.png)

#### 組み込み関数

![](./images/Screenshot_59.png)

https://www.terraform.io/language/functions



![](./images/Screenshot_60.png)

![](./images/Screenshot_61.png)

```hcl
$ terraform console
> floor(4.9)
4
>  substr("hello world", 1, 4)
"ello"
>
```





#### ファイル分割

![](./images/Screenshot_62.png)

![](./images/Screenshot_63.png)

![](./images/Screenshot_64.png)

![](./images/Screenshot_65.png)



#### 公式ドキュメントの見方

![](./images/Screenshot_66.png)

HCL2 https://www.terraform.io/language

CLI https://www.terraform.io/cli

provider https://registry.terraform.io/providers/hashicorp/aws/latest/docs



####　ひな型作成

![](./images/Screenshot_67.png)

main.tf

```
# -----------------------------------
# Terraform configuration
# -----------------------------------
terraform {
    required_version = ">=0.13"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>3.0"
        }
    }
}
# -----------------------------------
# Provider
# -----------------------------------
provider "aws" {
  profile = "terraform"
  region = "ap-northeast-1" 
}

# -----------------------------------
# Variables
# -----------------------------------
variable "project" {
    type = string
}

variable "environment" {
  type = string
}

```

疑問点：awsのバージョンとは何?

terraform.tfvars

```
project = "tastylog"
environment = "dev"
```



.gitignore は下記のサイトを参照

https://www.toptal.com/developers/gitignore

初期化

```sh
terraform init
# 整形する
$ terraform fmt
main.tf
terraform.tfvars
```



### Section 6:作成するWebアプリケーション

#### Webアプリケーションの概要

![](./images/Screenshot_13.png)

### 

![](./images/Screenshot_13.png)

![](./images/Screenshot_14.png)

### Section 7:　VPC　ネットワーク設定

#### VPCの作成

VPCを作成する際は resourceを利用する

![](./images/Screenshot_68.png)

![](./images/Screenshot_69.png)



括弧内部の定義について下記にまとめました

![](./images/Screenshot_70.png)

192.168.0.0/20のVPCを作成する

![](./images/Screenshot_71.png)



network.tf

```
# -----------------------------------
# VPC
# -----------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}
```



```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

#### サブネットの作成

resourceブロックで定義する

![](./images/Screenshot_72.png)



![](./images/Screenshot_73.png)



![](./images/Screenshot_74.png)



![](./images/Screenshot_75.png)



network.tf 

vpcの後からsubnetを追加する

```
# -----------------------------------
# VPC
# -----------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# -----------------------------------
# Subnet
# -----------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}
```

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

VPC => subnet画面から追加されていることを確認する

#### ルートテーブルの作成

![](./images/Screenshot_76.png)



![](./images/Screenshot_77.png)

resourceブロックを利用する

![](./images/Screenshot_78.png)



![](./images/Screenshot_79.png)



![](./images/Screenshot_80.png)

![](./images/Screenshot_81.png)



![](./images/Screenshot_82.png)



前回のnetwork.tfに追加する

```
# -----------------------------------
# Route table
# -----------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}
```

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```



#### インターネットゲートウェイの作成

![](./images/Screenshot_83.png)





![](./images/Screenshot_84.png)



インターネットゲートウェイはresourceで定義する

![](./images/Screenshot_85.png)



![](./images/Screenshot_86.png)



aws route

![](./images/Screenshot_87.png)

![](./images/Screenshot_88.png)



作成するWebアプリケーションの位置

![](./images/Screenshot_89.png)

network.tfの後に追加する

```
# -----------------------------------
# Internet Gateway
# -----------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
```

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

インターネットゲートウェイが作成されているのか

VPC=>インターネットゲートウェイ画面から確認する



インターネットゲートウェイとpublicサブネットを関連されているのか

VPC=>ルートテーブル=>ルートを選択する=>ルートタブ



### Section 8: SG ファイアウォール設定

#### セキュリティグループのリソース

![](./images/Screenshot_90.png)

![](./images/Screenshot_91.png)



resource ブロックに定義する

![](./images/Screenshot_92.png)



![](./images/Screenshot_93.png)



注意点

![](./images/Screenshot_94.png)

セキュリティグループの設定

![](./images/Screenshot_95.png)



#### セキュリティグループの作成１

![](./images/Screenshot_96.png)

![](./images/Screenshot_97.png)

Web用のingressとegress

![](./images/Screenshot_98.png)



APのingressとegress

![](./images/Screenshot_99.png)

運用管理のingressとegress

![](./images/Screenshot_100.png)

DBのingressとegress

![](./images/Screenshot_101.png)

security_group.tf

```
# -----------------------------------
# Security Group
# -----------------------------------
# Web security group
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_out_tcp3000" {
  security_group_id       = aws_security_group.web_sg.id
  type                    = "egress"
  protocol                = "tcp"
  from_port               = 3000
  to_port                 = 3000
  source_security_group_id = aws_security_group.app_sg.id
}

# App security group


resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}


# opmng security group
resource "aws_security_group" "opmng_sg" {
  name        = "${var.project}-${var.environment}-opmng-sg"
  description = "operation and management role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-opmng-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "opmng_in_ssh" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_in_tcp3000" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_http" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "opmng_out_https" {
  security_group_id = aws_security_group.opmng_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app_sg.id
}
```

実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

VPC=>セキュリティグループの画面からinboudとoutboundにある内容を確認する



####　ブレフィックスリストの取得

![](./images/Screenshot_102.png)

dataブロックを利用する

![](./images/Screenshot_103.png)



![](./images/Screenshot_104.png)

![](./images/Screenshot_105.png)



```
data "aws_prefix_list" "s3_pl" {
  #nameはVPC=> マネジメントフィックスリスト画面から確認する
  #regionが違う可能性があるので、regionの部分を*にする
  name = "com.amazonaws.*.s3"
}
```



実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

terraform.tfstateファイルからdataが追加されていることを確認できる

####　セキュリティグループの作成２

AP　サーバーのセキュリティグループの作成

![](./images/Screenshot_106.png)





security_group.tf に追加する

アプリのセキュリティグループの作成

```
# App security group


resource "aws_security_group" "app_sg" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "application server role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-app-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "app_in_tcp3000" {
  security_group_id = aws_security_group.app_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "app_out_http" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  prefix_list_ids = data.aws_prefix_list.s3_pl.id
}

resource "aws_security_group_rule" "app_out_https" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_ids = [data.aws_prefix_list.s3_pl.id]
}

resource "aws_security_group_rule" "app_out_tcp3306" {
  security_group_id = aws_security_group.app_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  source_security_group_id = [aws_security_group.db_sg.id]
}
```



実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

VPC=>セキュリティグループの画面からinboudとoutboundにある内容を確認する

### Section 9: RDS データベース作成

#### パラメータグループの作成

![](./images/Screenshot_107.png)







![](./images/Screenshot_108.png)

![](./images/Screenshot_109.png)

rds.tf

```
# -----------------------------------
# RDS parameter group
# -----------------------------------
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}
```



実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

確認

RDS=>パラメータグループ(選択されたリージョンを注意する)

character_set_databaseとcharacter_set_serverが正しく設定されていることを確認する

#### オプショングループの作成

![](./images/Screenshot_110.png)



![](./images/Screenshot_111.png)

rds.tfに追加する

```
# -----------------------------------
# RDS option group
# -----------------------------------
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name = "mysql"
  major_engine_version = "8.0"
}
```

実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => オプショングループ画面を確認する



#### サブネットグループの作成

![](./images/Screenshot_112.png)



![](./images/Screenshot_113.png)



![](./images/Screenshot_114.png)



rds.ftに追加する

```
# -----------------------------------
# RDS subnet group
# -----------------------------------
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}
```

実行コマンド

```
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => サブネットグループ画面を確認する

サブネットが入っていることを確認する

#### ランダム文字列の作成

パスワードを作成するためにランダム文字列を作成する

![](./images/Screenshot_115.png)



![](./images/Screenshot_116.png)

![](./images/Screenshot_117.png)



rds.tfに追加する

```

# -----------------------------------
# RDS instance
# -----------------------------------
resource "random_string" "db_password" {
  length = 16
  special = false
}
```

実行コマンド

```sh
terraform fmt
#hashicorp/randomを生成するため
terraform init
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

terraform.tfstateを確認する

db_password



#### RDSの作成

![](./images/Screenshot_118.png)

![](./images/Screenshot_119.png)

![](./images/Screenshot_120.png)





![](./images/Screenshot_121.png)

![](./images/Screenshot_122.png)

![](./images/Screenshot_123.png)



![](./images/Screenshot_124.png)

![](./images/Screenshot_125.png)

![](./images/Screenshot_126.png)



rds.tfに追加する

```
# -----------------------------------
# RDS instance
# -----------------------------------
resource "random_string" "db_password" {
  length = 16
  special = false
}
```



実行コマンド

```sh
terraform fmt
#hashicorp/randomを生成するため
terraform init
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => オプショングループ画面を確認する



#### RDSの作成(演習)





![](./images/Screenshot_127.png)



![](./images/Screenshot_118.png)

rds.tfに追加する

```sh

resource "aws_db_instance" "mysql_standalone" {
  #基本設定
  engine         = "mysql"
  engine_version = "8.0.20"
  identifier    = "${var.project}-${var.environment}-mysql-standalone"
  instance_class = "db.t2.micro"
  username       = "admin"
  password       = random_string.db_password.result

  #ストレージ
  #基本20GB
  allocated_storage = 20
  #最大50GB
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  #ネットワーク
  multi_az               = false
  availability_zone      = "ap-northeast-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  #DB設定
  name                 = "tasylog"
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  #バックアップ
  #backupの時間
  backup_window = "04:00-05:00"
  #backupの日数
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  #削除防止
  deletion_protection = true
  skip_final_snapshot = false
  apply_immediately   = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}
```

実行コマンド

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => データベース画面を確認する

#### RDSのパスワード

![](./images/Screenshot_128.png)



![](./images/Screenshot_129.png)

![](./images/Screenshot_130.png)



![](./images/Screenshot_131.png)



![](./images/Screenshot_132.png)



#### RDSの削除防止



![](./images/Screenshot_133.png)

![](./images/Screenshot_134.png)

![](./images/Screenshot_135.png)

rds.tf変更点

```sh
#削除時
  deletion_protection = false
  skip_final_snapshot = true
```



実行コマンド

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

下記の内容をコメントアウトする

```
# resource "aws_db_instance" "mysql_standalone" {
}
```

データベースを削除する

```
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => データベース画面（削除されていること）を確認する



データベースを元に戻すには、コメントアウトを外す
```
resource "aws_db_instance" "mysql_standalone" {
}
```

データベースを作成する

```
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

RDS => データベース画面を確認する

#### RDS接続用踏み台サーバー作成(手動)

#####　鍵作成

EC2 => キーペア画面=>作成する

名前:tmp-tastylog-dev-keypair

鍵ファイルをダウンロードする

##### EC2を作成する

VPCはtastylog-dev-vpcを選択する

サブネットはtastylog-dev-public-subnet-1aを選択する

パブリックIPの自動割り当てを有効に設定する

セキュリティグループを追加する

　tastylog-dev-opmng

​    tastylog-dev-app-sg

キーペアは作成した　tmp-tastylog-dev-keypair　を選択する

インスタンス起動する

##### EC2にアクセスする

C:\Users\＄usernameの配下にキーペアを置く(他の箇所だと権限が広すぎることでアクセスできない)

```sh
 ssh -i .\tmp-tastylog-dev-keypair.pem ec2-user@$publicIP
 #mysqlをインストールする
 sudo yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
 #GPG鍵をインストールする
 sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
 #clientをインストールする
 sudo yum install -y mysql-community-client
```

terraform.tfstateからaddress、username、passwordを取得する

```sh
mysql -h"${address}" -P"${MYSQL_PORT}" -u"${MYSQL_USERNAME}" -p"${MYSQL_PASSWORD}"

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| tasylog            |
+--------------------+
```



#### RDSへデータ投入(手動)

![](./images/Screenshot_136.png)



![](./images/Screenshot_136.png)

ファイルを転送する

```sh
scp -i .\tmp-tastylog-dev-keypair.pem ..\data.tar.gz ec2-user$publicIP:/home/ec2-user/
#ログインして転送ファイルを確認する
ls -l
#ファイルを解凍する
 tar -zxvf ./data.tar.gz
#bdaccess.cnfを編集する
# terraform.tfstateを参照する
#password、host（address）

#userを更新する
cd 10_alter_user/
#パスワードを変更する
vi  alter_user.sql
sh alter_user.sh

#テーブルを作成する
cd ../20_create_table/
sh create_table.sh

#データをinsertする
cd ../30_insert_data/
sh insert_sampledata.sh
```

```sh
#データベースにログインする
mysql -h"${address}" -P"${MYSQL_PORT}" -u"${MYSQL_USERNAME}" -p"${MYSQL_PASSWORD}"

#データを確認する
use tastylog;
show tables;
mysql> select * from t_user limit 10;
```

EC2を終了する

EC2のキーペアを削除する

### Section 10: EC2 APサーバー作成(1)

#### AMIの検索

![](./images/Screenshot_138.png)



![](./images/Screenshot_139.png)







![](./images/Screenshot_140.png)



![](./images/Screenshot_141.png)



![](./images/Screenshot_142.png)

![](./images/Screenshot_143.png)

```sh
aws ec2 describe-images --image-ids ami-0bcc04d20228d0cf6

#下記の内容が表示される
 "ImageOwnerAlias": "amazon",
            "Name": "amzn2-ami-kernel-5.10-hvm-2.0.20220419.0-x86_64-gp2",
            "RootDeviceName": "/dev/xvda",
            "RootDeviceType": "ebs",
            "SriovNetSupport": "simple",
            "VirtualizationType": "hvm",
```

data.tfに追加する

```tf
data "aws_ami" "app" {
  most_recent = true
  owners = [ "slef", "amazon" ]

  filter{
    name = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter{
    name = "virtualzation-type"
    values = ["hvm"]
  }
}
```



実行コマンド

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

取り込まれているのかを確認する

terraform.tfstateファイルに「aws_ami」を検索する

idはawsのマネジメントコンソールと一致するのかを確認する

#### キーペアの作成

![](./images/Screenshot_144.png)

![](./images/Screenshot_145.png)





![](./images/Screenshot_146.png)

![](./images/Screenshot_147.png)

![](./images/Screenshot_148.png)

```
ssh-keygen -t rsa -b 2048 -f tastylog-dev-keypair
```

vscodeからsrcフォルダを作成し、作成した暗号鍵と公開鍵をsrcフォルダに移動する

tastylog-dev-keypairを「tastylog-dev-keypair.pem」に変更する

appserver.tf

```
resource "aws_key_pair" "keypair" {
  key_name = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")
  tags ={
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}
```

実行コマンド

```sh
terraform fmt
terraform plan
#yesを入力せずに実行する
terraform apply -auto-approve
```

EC2 => キーペア画面を確認する

#### EC2の作成



#### EC2の作成(演習)



### Terraform(ステートファイル)

#### tfstateをS3へ保管

#### リソース一覧の確認

#### リソース詳細の確認

#### リソース名の変更

#### リソースの取り込み

#### リソースの削除

#### 現状の反映

### 

#### 

#### 

#### 

### 

#### 

#### 

#### 

### 

#### 

#### 

#### 

### 

#### 

#### 

#### 

### 

#### 

#### 

#### 

### 

#### 

#### 

#### 



### 



