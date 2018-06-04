#/bin/bash
sudo docker stop nginx
sudo docker rm nginx
sudo docker image rm imxseraph/muxin-io:nginx
sudo docker run --name nginx --restart always -p 80:80 -p 443:443 -v /etc/letsencrypt:/etc/letsencrypt -d imxseraph/muxin-io:nginx
