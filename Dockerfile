FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
        apache2 \
        libapache2-mod-php5 \
        php5-gd \
        php5-apcu \
        php5-imagick \
        php5-curl \
        php5-mysql \
        php5-mcrypt \
        php5-intl \
        curl \
        supervisor \
        ssmtp \
        mailutils \
	git \
	&& apt-get clean

RUN echo 'date.timezone = "Europe/Berlin"' >> /etc/php5/cli/php.ini
RUN echo 'date.timezone = "Europe/Berlin"' >> /etc/php5/apache2/php.ini

RUN php5enmod mcrypt

RUN a2dissite 000-default
COPY assets/vhost.conf /etc/apache2/sites-available/vhost.conf
RUN a2ensite vhost

RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN mkdir /var/www/htdocs && cd /var/www/htdocs/ && git clone https://github.com/obi12341/passbin_flow.git . && /usr/local/bin/composer install

COPY assets/ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY assets/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY run.sh /run.sh

EXPOSE 80
CMD ["/run.sh"]

