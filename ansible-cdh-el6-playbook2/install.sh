#!/bin/bash
dir=$(dirname $(readlink $0 -f )   )
cd $dir

echo "0, 检查主机名映射:/etc/hosts"
hosts=$(awk '{print $1}' /etc/hosts |grep -Ev '^#|^127.0.0.1|::1|localhost')
[ $? -ne 0 ] && echo '/etc/hosts is not configured !!! ' && exit 1


echo "#1,免密登录"
[ -f ~/.ssh/id_rsa ] || ssh-keygen  -t rsa -P '' -f ~/.ssh/id_rsa > /dev/null
sed 's/^#[[:space:]]*StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config -i


echo "#2, 安装ansible rpm packs"
hosts2=$( echo $hosts |xargs -n1 |grep -v $(hostname -i) )
res=$?
#a, cluster mode
if [ $res -eq 0 ] ;then
    echo "---cluster mode------"
    #hosts=(  192.168.56.201  192.168.56.202 )
    for host in ${hosts2[*]}
    do
      echo ">>>>>> $host >>>>"
      ssh-copy-id $host
      #sync /etc/hosts to other hosts
      scp /etc/hosts $host:/etc/
      #sync ansible packs to other hosts
      scp  -r ansible-packs $host:/tmp/ > /dev/null
      ssh $host "yum -y localinstall /tmp/ansible-packs/*.rpm > /dev/null  "
    done
else
#b, standalone mode
    echo "---standalone mode------"
    yum -y localinstall ansible-packs/*.rpm > /dev/null
fi


echo "#3, 使用ansible 安装cloudera manager
# a, 进入目录  cloudera-playbook-master
# b, 修改文件  hosts
# c, 运行命令: ansible-playbook -i hosts site.yml"
