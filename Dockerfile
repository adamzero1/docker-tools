FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

ARG user
ARG useruid
# Add user stuff
RUN useradd -U -m -u "${useruid}" -G sudo,www-data -d "/home/${user}" "${user}" 

# Postfix Config
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

RUN export TERM=xterm; apt-get update && apt-get install -y --force-yes \
        php7.0-xml \
	php7.0-mysql \
	php7.0-curl \
	php7.0-mcrypt \
	php7.0-gd \
	php7.0-cli \
	php7.0-soap \
	php7.0-mbstring \
	php7.0-intl \
	php7.0-zip \
	git-core \
	mysql-client \
	curl \
	nano \
	postfix \
	rsyslog \
	wget \
	npm \
	--fix-missing
	
RUN apt-get clean

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install require js deploy thing
RUN npm install -g requirejs
RUN ln -s /usr/bin/nodejs /usr/bin/node

# Disable local delivery
RUN sed -i 's/mydestination = .*/mydestination = localhost/' /etc/postfix/main.cf

#RUN usermod -m -d /usr/share/nginx www-data
COPY files/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

# Utils
COPY files/reimport-db /usr/local/bin/reimport-db
RUN chmod a+x /usr/local/bin/reimport-db

# Define mountable directories.
VOLUME [ "/var/www/html", "/home/$user/.ssh", "/mysql-imports" ]

# Define working directory.
WORKDIR /var/www/html

ENTRYPOINT ["/entrypoint.sh"]
