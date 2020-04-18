### This section is for Kong 

#### 1: Create Docker Network 
docker network create --subnet=172.1.1.0/24 kong-net

--subnet:Subnet in CIDR format that represents a network segment

#### 2: Create Kong Database ####
##### *With password is not working for konga
docker run -d --name kong-database --restart=always --network=kong-net -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong" -e "POSTGRES_PASSWORD=password" postgres:11-alpine

##### *Without password
docker run -d --name kong-database --restart=always --network=kong-net -p 5432:5432 -e "POSTGRES_USER=kong" -e "POSTGRES_DB=kong"  -e "POSTGRES_HOST_AUTH_METHOD=trust" postgres:11-alpine

-d: -d, --detach                    Run container in background and print container ID
-e:  Set environment variables
postgres:11-alpine: image name
--name string                    Assign a name to the container
#### 3: Run Kong Database Preparation ####
##### *With password is not working for konga
docker run --rm --network=kong-net  -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database"  -e "KONG_PG_PASSWORD=password" -e "KONG_PG_USER=kong" kong:1.3 kong migrations bootstrap

##### *Without password
docker run --rm --network=kong-net  -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database"   kong:1.3 kong migrations bootstrap

--rm                             Automatically remove the container


#### 4: Run Kong 
##### *With password
docker run -d --name kong --network=kong-net --restart always -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database"   -e "KONG_PG_PASSWORD=password" -e "KONG_PG_USER=kong" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 --ip 172.1.1.40 kong:1.3

##### *Without password
docker run -d --name kong --network=kong-net --restart always -e "KONG_DATABASE=postgres" -e "KONG_PG_HOST=kong-database" -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" -e "KONG_PROXY_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" -p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 --ip 172.1.1.40 kong:1.3

### This section is for Konga ####
#### 1: Prepare Konga Database ####
##### *With password 
docker run --rm --name konga --network=kong-net pantsel/konga:0.14.1 -c prepare -a postgres -u postgresql://kong@kong-database:5432/konga_db

##### *Without password is not working
docker run --rm --name konga --network=kong-net pantsel/konga:0.14.1 -c prepare -a postgres -u postgresql -w password://kong@kong-database:5432/konga_db

#### 2: Run Konga ####
docker run -d -p 1337:1337 --network kong-net --name konga --restart=always -e "NODE_ENV=development" -e "TOKEN_SECRET=iu7YDcPLiZkozQXzZ9kka3Ee1Vid5ZgQ" -e "DB_ADAPTER=postgres" -e DB_URI=postgresql://kong@kong-database:5432/konga_db pantsel/konga:0.14.1

### This section is for dummy services 
#### 1: Run Alpha
docker run -d --name alpha --restart=always --network=kong-net -p 9001:9001 --ip 172.1.1.11 timpamungkas/alpha:latest

#### 2: Run Beta 
docker run -d --name beta --restart=always --network=kong-net -p 9002:9002 --ip 172.1.1.12 timpamungkas/beta:latest

#### 3: Run Gamma 
docker run -d --name gamma --restart=always --network=kong-net -p 9003:9003 --ip 172.1.1.13 timpamungkas/gamma:latest

#### 1: Run Omega 
docker run -d --name omega --restart=always --network=kong-net -p 9004:9004 --ip 172.1.1.14 timpamungkas/omega:latest