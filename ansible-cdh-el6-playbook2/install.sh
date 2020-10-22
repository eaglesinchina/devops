echo "#1,免密登录"
#cdh_hosts=(
#  192.168.56.201
#  192.168.56.202
#)
cdh_hosts=(
 192.168.56.201
 192.168.56.202
)

[ -f ~/.ssh/id_rsa ] || ssh-keygen  -t rsa -P '' -f ~/.ssh/id_rsa > /dev/null
sed 's/^#[[:space:]]*StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config -i


echo "#2, 安装ansible rpm packs"
yum -y localinstall ansible-packs/*.rpm > /dev/null
for host in ${cdh_hosts[*]}
do
 echo $host
 ssh-copy-id $host
 scp  -r ansible-packs $host:/tmp/ > /dev/null
 ssh $host "yum -y localinstall /tmp/ansible-packs/*.rpm > /dev/null  "
done




echo "
#3, 使用ansible 安装cloudera manager
# a, 进入目录  cloudera-playbook-master
# b, 修改文件  hosts
# c, 运行命令: ansible-playbook -i hosts site.yml"
