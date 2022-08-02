#! /bin/sh
#
# start.sh
#
# Created by ruibin.chow on 2017/08/03.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
#


# Ubuntu开机之后会执行/etc/rc.local文件中的脚本， 
# 所以我们可以直接在/etc/rc.local中添加启动脚本。 
# 当然要添加到语句：exit 0 前面才行。
# 在centos7中，/etc/rc.d/rc.local的权限被降低了，所以需要执行如下命令赋予其可执行权限
# chmod +x /etc/rc.d/rc.local


/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
#service mysql start
systemctl start mariadb
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/redis/redis-server /usr/local/redis/redis.conf
#ps -ef | grep supervisord | grep -v grep | cut -c 9-15 | xargs kill -s 9 
/home/creactism/env/bin/supervisord -c /home/creactism/supervisor.conf
