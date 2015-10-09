FROM daocloud.io/ubuntu
MAINTAINER Fang Liang <hustnaive@me.com>

#国内使用163的镜像源以加速
ADD sources.list.trusty /etc/apt/sources.list
RUN apt-get update

#安装nginx,curl,memcached,php5-fpm以及相关的扩展
RUN apt-get install -y nginx
RUN apt-get install -y curl
RUN apt-get install -y memcached
RUN apt-get install -y php5-fpm
RUN apt-get install -y php5-memcache
RUN apt-get install -y php5-mysql
RUN apt-get install -y php5-mysqlnd
RUN apt-get install -y php5-curl

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
# 设置root ssh远程登录密码为123456
RUN echo "root:123456" | chpasswd

#将一些配置初始化
ADD nginx-conf /etc/nginx/nginx.conf
ADD nginx-site /etc/nginx/sites-available/default
WORKDIR /etc/nginx/sites-enabled/
RUN ln -sf /etc/nginx/sites-available/default ./default

#将测试文件拷贝到网站根目录
RUN mkdir /var/www && mkdir /var/www/site
ADD phpinfo.php /var/www/site/phpinfo.php

RUN /etc/init.d/nginx restart
RUN /etc/init.d/php5-fpm restart
RUN /etc/init.d/memcached restart

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Expose Ports
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["/start.sh"]