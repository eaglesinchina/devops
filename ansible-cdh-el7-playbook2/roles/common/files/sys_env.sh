#消除警告
#=====临时修改swappiness
sysctl -w vm.swappiness=10
#====永久修改swappiness
echo "vm.swappiness=10" >> /etc/sysctl.conf

#页面压缩
chmod +x  /etc/rc.d/rc.local
echo  'echo never > /sys/kernel/mm/transparent_hugepage/defrag ' >>/etc/rc.d/rc.local
echo  'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >>/etc/rc.d/rc.local

echo never >  /sys/kernel/mm/transparent_hugepage/enabled
echo never >  /sys/kernel/mm/transparent_hugepage/defrag

#任务标志文件
touch /tmp/cdh_sys_env

