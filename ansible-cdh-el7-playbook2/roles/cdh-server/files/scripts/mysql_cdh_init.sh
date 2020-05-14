mysqladmin -u root password '123456'
mysql -uroot -p123456 -e "drop database if exists hive ; create database hive default charset utf8";
mysql -uroot -p123456 -e "drop database if exists oozie; create database oozie default charset utf8";
mysql -uroot -p123456 -e "drop database if exists hue; create database hue default charset utf8";

mysql -uroot -p123456 -e "grant all privileges on *.* to 'scm'@'%' identified by 'scm' with grant option; flush privileges;";
mysql -uroot -p123456 -e "grant all privileges on *.* to 'scm'@\"$(hostname)\" identified by 'scm' with grant option; flush privileges;";
mysql -uroot -p123456 -e "grant all privileges on *.* to 'root'@'localhost' identified by '123456' with grant option; flush privileges;";
mysql -uroot -p123456 -e "grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option; flush privileges;";
mysql -uroot -p123456 -e "grant all privileges on *.* to 'root'@\"$(hostname)\" identified by '123456' with grant option; flush privileges;";

mysql -uroot -p123456 -e "drop database if exists scm";
/opt/cm*/share/cmf/schema/scm_prepare_database.sh mysql  -uroot -p123456  scm scm scm ; touch /tmp/cdh_mysql_init

