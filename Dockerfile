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

COPY --chown=root:root resources/local/.htpasswd /usr/local/apache2/passwd/
COPY --chown=root:root resources/local/upload.php /usr/local/apache2/conf/
COPY --chown=root:root resources/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY --chown=root:root resources/ports.conf resources/apache2.conf /etc/apache2/
COPY --chown=root:root resources/cert/* /etc/apache2/certs/
COPY --chown=root:root resources/lib/libjwt.so.1.7.0 /usr/lib/x86_64-linux-gnu/libjwt.so.1
COPY --chown=root:root resources/modules/mod_authnz_jwt.so /usr/local/apache2/modules/mod_authnz_jwt.so
COPY --chown=root:root resources/mods-enabled/auth_jwt.load /etc/apache2/mods-enabled/auth_jwt.load

RUN chmod 644 /usr/local/apache2/passwd/.htpasswd \
  && chmod 644 /usr/local/apache2/conf/httpd.conf \
  && chmod 644 /usr/lib/x86_64-linux-gnu/libjwt.so.1 \
  && chmod 644 /usr/local/apache2/modules/mod_authnz_jwt.so \
  && touch /usr/local/apache2/htdocs/index.html
CMD if [ -f /etc/apache2/certs/cacert.pem  ]; then cp /etc/apache2/certs/cacert.pem /etc/apache2/certs/truststore.pem; fi \
    && if [ -f /etc/apache2/certs/cert.pem  ]; then cp /etc/apache2/certs/cert.pem /etc/apache2/certs/keystore.pem; fi \
    && /usr/sbin/apache2ctl -D FOREGROUND
