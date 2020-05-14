pid=$(ss -nltp|grep 19001 |awk '{print $3}')
[ x$pid != x ] && kill $pid
echo
