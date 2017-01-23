FROM debian:jessie

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
	apt-get -y install wget git

RUN wget https://www.dotdeb.org/dotdeb.gpg && \
	apt-key add dotdeb.gpg && \
	rm -f dotdeb.gpg

RUN echo "deb http://packages.dotdeb.org jessie all" >>/etc/apt/sources.list.d/dotdeb.list && \
	apt-get -y update && \
	apt-get -y install \
		libmemcached11 \
		libmemcachedutil2 \
		php7.0-cli \
		php7.0-apcu \
		php7.0-apcu-bc \
		php7.0-bcmath \
		php7.0-cli \
		php7.0-curl \
		php7.0-gd \
		php7.0-geoip \
		php7.0-gmp \
		php7.0-imagick \
		php7.0-intl \
		php7.0-mbstring \
		php7.0-mcrypt \
		php7.0-mysql \
		php7.0-redis \
		php7.0-soap \
		php7.0-xml \
		php7.0-xsl && \
		apt-get -y clean

COPY mailparse.so /usr/lib/php/20151012/
COPY memcached.so /usr/lib/php/20151012/

RUN echo "extension=mailparse.so" >/etc/php/7.0/cli/conf.d/20-mailparse.ini
RUN echo "extension=memcached.so" >/etc/php/7.0/cli/conf.d/20-memcached.ini

# Force build to fail if the modules can't be loaded
RUN php -m | grep mailparse >/dev/null
RUN php -m | grep memcached >/dev/null

RUN wget https://getcomposer.org/composer.phar && \
  chmod 0755 composer.phar && \
	mv composer.phar /usr/local/bin && \
	ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
