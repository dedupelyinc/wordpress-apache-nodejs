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
RUN apt-get install -y php libapache2-mod-php php-mcrypt php-mysql php-curl

# Install Wordpress
RUN wget https://wordpress.org/wordpress-4.9.6.tar.gz && \
    tar -xzvf wordpress-4.9.6.tar.gz && mv wordpress /var/www/html && \
    rm -rf wordpress-4.9.6.tar.gz

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs && \
    aptitude install -y npm && \
    npm install mocha chai ts-node gulp-cli -g

# Install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz && \
    tar -C /usr/local/bin -xvzf dockerize-linux-amd64-v0.6.1.tar.gz

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN mkdir -p /var/lock/apache2
RUN chown www-data:www-data -R /var/www/html

EXPOSE 8080