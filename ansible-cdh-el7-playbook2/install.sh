#!/bin/bash
#1, 控制机(本机)安装ansible
rpm -qa |grep ansible -i >/dev/null
if [ $? -ne 0 ] ;then
  tar -xf ansible*.tar
  rpm -Uvh ansible-packs/*.rpm --force && rm -rf ansible-packs
fi

#2, 复制ansible-selinux 的rpm包远程主机/tmp/, 并安装
#cdh_hosts=$(cat hosts-cdh |awk '{print $1}' |egrep -v `hostname -I |xargs -n1 |xargs |sed -r 's/\s+/|/g'` |grep -v "127.0.0.1")
cdh_hosts=$(cat hosts-cdh |awk '{print $1}' |grep -v "127.0.0.1")
tmpfile1=/tmp/h1.txt
tmpfile2=/tmp/h2.txt
> $tmpfile1

#3 生成密钥，免密码登录其他主机 , 设置不提示接收主机指纹
[ ! -f ~/.ssh/id_rsa ] && ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa  #&& cat ~/.ssh/id_rsa.pub  >> ~/.ssh/authorized_keys && chmod 600  ~/.ssh/authorized_keys
sed  -i '/#   StrictHostKeyChecking/aStrictHostKeyChecking no' /etc/ssh/ssh_config


for i in $cdh_hosts
do
	#2，获取主机的user,pass
	while read line 
	do
	    echo $line |grep $i |awk 'NF==5{print}' >>$tmpfile1
	done< hosts
done

#4, 汇总所有host,去重
cat $tmpfile1 |sort |uniq > $tmpfile2
while read str  
do
	echo $str |awk '{print "\n============"$2"=============="}'
	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"ssh-copy-id",   $7"@"$3 }' 
	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"ssh-copy-id",   $7"@"$3 }' |bash
 	#echo -e 'yes\nvagrant\n' |ssh-copy-id test-c7

	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"scp selinux-py-packs/*.rpm",$7"@"$3":/tmp/"}' 
	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"scp selinux-py-packs/*.rpm",$7"@"$3":/tmp/"}' |bash
	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"ssh",            $7"@"$3," \"rpm -Uvh /tmp/libse*.rpm\""}' 
	echo $str | awk -F'[ =]' '{print "sshpass -p"$9,"ssh",            $7"@"$3," \"rpm -Uvh /tmp/libse*.rpm --force 2>/dev/null \""}' |bash
	#sshpass -p vagrant scp selinux-py-packs/*.rpm root@$ip:/tmp/
	#sshpass -p vagrant ssh root@$ip "rpm -Uvh /tmp/*.rpm"
done < $tmpfile2


#5, 使用ansible安装cdh
ansible-playbook -i hosts site.yml

