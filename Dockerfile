FROM ubuntu:16.04

RUN apt-get update && apt-get install -y wget curl aptitude

# Install Apache
RUN apt-get install -y apache2
RUN rm -r /var/www/html
RUN a2enmod rewrite
RUN echo "Listen 8080" > /etc/apache2/ports.conf
# Get rid of annoying log entry about empty server name
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Install PHP
RUN apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-curl php7.0-mbstring php7.0-xml

# Install Wordpress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && mv wordpress /var/www/html && \
    rm -rf latest.tar.gz

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    aptitude install -y npm && \
    npm install mocha chai ts-node gulp-cli -g

RUN apt-get install -y libyaml-dev php-pear php7.0-dev && \
    pecl install yaml-2.0.0 && \
    echo "extension=yaml.so" >> /etc/php/7.0/apache2/php.ini

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

COPY ./htaccess.txt /htaccess.txt
COPY ./etc/apache2/sites-enabled /etc/apache2/sites-enabled

RUN mkdir -p /var/lock/apache2
RUN cat /htaccess.txt > /var/www/html/.htaccess
RUN chown www-data:www-data -R /var/www/html

EXPOSE 8080