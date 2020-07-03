FROM phpdockerio/php56-fpm:latest

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive
ARG APPDIR=/application

ARG LANGUAGE=fr_FR
ARG CHARSET=UTF-8
ARG LC_LOCALE="$LANGUAGE.$CHARSET"

ENV LANG=$LANGUAGE.$CHARSET
ENV LANGUAGE=$LANGUAGE
ENV LC_ALL="$LANGUAGE.$CHARSET"
ENV LC_LOCALE="$LANGUAGE.$CHARSET"
ENV LC_CTYPE="$LANGUAGE.$CHARSET"
ENV LC_NUMERIC="$LANGUAGE.$CHARSET"
ENV LC_TIME="$LANGUAGE.$CHARSET"
ENV LC_COLLATE="$LANGUAGE.$CHARSET"
ENV LC_MONETARY="$LANGUAGE.$CHARSET"
ENV LC_MESSAGES="$LANGUAGE.$CHARSET"
ENV LC_PAPER="$LANGUAGE.$CHARSET"
ENV LC_NAME="$LANGUAGE.$CHARSET"
ENV LC_ADDRESS="$LANGUAGE.$CHARSET"
ENV LC_TELEPHONE="$LANGUAGE.$CHARSET"
ENV LC_MEASUREMENT="$LANGUAGE.$CHARSET"
ENV LC_IDENTIFICATION="$LANGUAGE.$CHARSET"

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install curl wget git sudo locales locales-all \
    && locale-gen $LOCALE && update-locale \
    && echo 'Europe/Paris' > /etc/timezone && rm /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && usermod -u 33 www-data && groupmod -g 33 www-data \
    && mkdir -p $APPDIR && chown www-data:www-data $APPDIR

RUN cd /tmp && wget https://deb.nodesource.com/setup_12.x && chmod +x setup_12.x && ./setup_12.x && \
cd /tmp && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
apt update && apt install -y nodejs yarn

RUN apt-get update \
    && apt-get -y --no-install-recommends install php-memcached php5-mysql php5-pgsql php5-sqlite php5-intl php-gd php-mbstring php-yaml php5-curl php-json php-redis composer

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY ./ini/php-ini-overrides.ini /etc/php5/fpm/conf.d/99-overrides.ini

EXPOSE 9000
VOLUME [ $APPDIR ]
WORKDIR $APPDIR
# USER 33:33
