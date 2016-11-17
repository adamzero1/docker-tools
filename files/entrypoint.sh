#!/bin/sh
# Start services
service rsyslog start
service postfix start

# Add user stuff
useradd -U -m -u ${DEFAULT_USER_UID} -G sudo,www-data -d /home/${DEFAULT_USER} ${DEFAULT_USER}

# User specifics
echo "" >> /home/${DEFAULT_USER}/.bashrc
echo "#Zero1 - Additions" >> /home/${DEFAULT_USER}/.bashrc
echo "export TERM=xterm" >> /home/${DEFAULT_USER}/.bashrc
echo "[client]" >> /home/${DEFAULT_USER}/.my.cnf
echo "host=${MYSQL_HOST_ALIAS}" >> /home/${DEFAULT_USER}/.my.cnf
echo "user=${MYSQL_USER}" >> /home/${DEFAULT_USER}/.my.cnf
echo "password=${MYSQL_PASSWORD}" >> /home/${DEFAULT_USER}/.my.cnf
echo "database=${MYSQL_DATABASE}" >> /home/${DEFAULT_USER}/.my.cnf

# Git Config
git config user.email "${GIT_EMAIL}"
git config user.name "${GIT_NAME}"

chown -R ${DEFAULT_USER}:${DEFAULT_USER} /home/${DEFAULT_USER}

# PHP Cli
sed -i "s/^;zend.multibyte = Off/zend.multibyte = On/g" /etc/php/7.0/cli/php.ini

tail -f -n0 /etc/hosts

su --login www-data --shell=/bin/bash
cd /usr/share/nginx/html
