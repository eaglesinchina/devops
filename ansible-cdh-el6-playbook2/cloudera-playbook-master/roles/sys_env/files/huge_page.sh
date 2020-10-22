#!/bin/bash
#页面压缩
chmod +x  /etc/rc.d/rc.local
echo  'echo never > /sys/kernel/mm/transparent_hugepage/defrag ' >>/etc/rc.d/rc.local
echo  'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >>/etc/rc.d/rc.local

echo never >  /sys/kernel/mm/transparent_hugepage/enabled
echo never >  /sys/kernel/mm/transparent_hugepage/defrag

#make finish flag
touch /tmp/huge_page
