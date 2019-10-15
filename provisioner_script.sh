#!/bin/bash -e
db_user_password=$1
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
sudo chown -R tomcat webapps/ work/ temp/ logs/
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
sudo systemctl daemon-reload
sudo systemctl start tomcat.service
sudo systemctl enable tomcat.service
sudo systemctl status tomcat.service
cd /tmp
wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
sudo yum -y install pgdg-centos96-9.6-3.noarch.rpm epel-release
sudo yum -y update
sudo yum -y install postgresql96-server postgresql96-contrib
sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl start postgresql-9.6
sudo systemctl enable postgresql-9.6
sudo adduser cloud
sudo usermod -a -G wheel centos
sudo usermod -a -G wheel,centos root
sudo usermod -a -G wheel,centos cloud
sudo usermod -a -G wheel,centos postgres
sudo -u postgres bash -c "psql -c \"CREATE USER cloud WITH PASSWORD '{$db_user_password}';\""
sudo -u postgres createdb recipe