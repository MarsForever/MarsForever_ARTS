1. For logstash configuration, download pipeline.conf
2. Put pipeline.conf into some folder (example : C:/logstash/pipeline or /usr/home/user/logstash/pipeline)
3. Adjust the docker script for logstash (2nd script)

docker run -d --name logstash ... -v d:/development/api-management/logstash/pipeline:/usr/share/logstash/pipeline/ ...

4. Change the d:/development/api-management/logstash/pipeline into the location where you put pipeline.conf, so for example it become like this :

docker run -d --name logstash ... -v c:/logstash/pipeline:/usr/share/logstash/pipeline/ ...

or

docker run -d --name logstash ... -v /usr/home/user/logstash/pipeline:/usr/share/logstash/pipeline/ ...

5. Run the script to create docker


NOTE : For Windows, enable shared folder from docker settings