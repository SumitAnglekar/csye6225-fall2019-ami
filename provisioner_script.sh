#!/bin/bash -e
aws_region=$1
sudo yum -y update
sudo yum -y install java-1.8.0-openjdk
sudo yum -y install wget
cd /tmp
wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz
sudo mkdir /opt/tomcat
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
sudo tar xvf apache-tomcat-8.5.47.tar.gz -C /opt/tomcat --strip-components=1
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf
sudo chmod -R g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/ bin/
cd /usr/lib/systemd/system
sudo touch tomcat.service
sudo chmod 777 tomcat.service
echo '[Unit]' > tomcat.service
echo 'Description=Apache Tomcat Web Application Container' >> tomcat.service
echo 'After=syslog.target network.target' >> tomcat.service
echo '[Service]' >> tomcat.service
echo 'Type=forking' >> tomcat.service
echo 'Environment=JAVA_HOME=/usr/lib/jvm/jre' >> tomcat.service
echo 'Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid' >> tomcat.service
echo 'Environment=CATALINA_HOME=/opt/tomcat' >> tomcat.service
echo 'Environment=CATALINA_BASE=/opt/tomcat' >> tomcat.service
echo 'Environment=\"CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC\"' >> tomcat.service
echo 'Environment=\"JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true\"' >> tomcat.service
echo 'ExecStart=/opt/tomcat/bin/startup.sh' >> tomcat.service
echo 'ExecStop=/bin/kill -15 $MAINPID' >> tomcat.service
echo 'User=tomcat' >> tomcat.service
echo 'Group=tomcat' >> tomcat.service
echo 'UMask=0007' >> tomcat.service
echo 'RestartSec=10' >> tomcat.service
echo 'Restart=always' >> tomcat.service
echo '[Install]' >> tomcat.service
echo 'WantedBy=multi-user.target' >> tomcat.service
cd /opt/tomcat
sudo chmod -R 777 .
sudo systemctl daemon-reload
sudo systemctl start tomcat.service
sudo systemctl enable tomcat.service
sudo systemctl status tomcat.service
sudo yum -y install postgresql-server postgresql-contrib
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo adduser cloud
sudo -u postgres createdb recipe
sudo -u postgres createuser --createrole cloud --superuser
sudo systemctl restart postgresql
sudo yum -y install ruby
cd /home/centos
wget https://aws-codedeploy-${aws_region}.s3.${aws_region}.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
wget https://s3.amazonaws.com/amazoncloudwatch-agent/centos/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
sudo cp /tmp/cloudwatch_config.json /opt/cloudwatch_config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/cloudwatch_config.json -s
cd /opt
sudo wget https://s3.amazonaws.com/configfileforcloudwatch/amazon-cloudwatch-agent.service
sudo cp amazon-cloudwatch-agent.service /usr/lib/systemd/system/
sudo systemctl enable amazon-cloudwatch-agent.service
sudo systemctl start amazon-cloudwatch-agent.service
echo 'successfully started cloudwatch agent'