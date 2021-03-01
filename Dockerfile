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

COPY --chown=root:root target/ /

RUN chmod 644 /usr/local/apache2/passwd/.htpasswd \
  && chmod 644 /usr/local/apache2/conf/httpd.conf \
  && chmod 644 /usr/lib/x86_64-linux-gnu/libjwt.so.1 \
  && chmod 644 /usr/local/apache2/modules/mod_authnz_jwt.so \
  && touch /usr/local/apache2/htdocs/index.html
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
