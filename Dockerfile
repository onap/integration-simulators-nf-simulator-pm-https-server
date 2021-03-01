FROM httpd:2.4

RUN apt-get update \
  && apt-get -y install vim libapache2-mod-php php php-curl \
  && rm -rf /var/lib/apt/lists/* \
  && a2enmod mpm_prefork \
  && a2dismod mpm_event \
  && a2enmod rewrite \
  && a2enmod ssl


ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

ADD target/resources.tar /
