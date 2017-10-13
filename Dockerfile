FROM alpine:latest
MAINTAINER jckimble <jckimble@thorbis.com>

ENV RAINLOOP_VERSION 1.10.5.192
ENV RAINLOOP_BUILD="/etc/rainloop" \
    RAINLOOP_HOME="/var/www/rainloop" \
    RAINLOOP_CLONE_URL="https://github.com/RainLoop/rainloop-webmail.git"
RUN \
	apk add --no-cache apache2 php7 php7-apache2 php7-openssl php7-json php7-pdo_mysql php7-curl php7-xml php7-iconv php7-dom php7-zlib && \
	mkdir -p /run/apache2 && \
	rm -rf /var/cache/apk/* && \
	rm -rf /usr/bin/php

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories  && \
    apk add -U git nodejs nodejs-npm findutils && \
    npm install gulp -g && \
    git clone -q -b v${RAINLOOP_VERSION} --depth 1  ${RAINLOOP_CLONE_URL} ${RAINLOOP_BUILD}  && \
    cd ${RAINLOOP_BUILD} && \
    npm install && \
    gulp rainloop:start && \
    mv build/dist/releases/webmail/${RAINLOOP_VERSION}/src ${RAINLOOP_HOME} && \
    npm uninstall -g gulp && \
    apk del --purge git nodejs nodejs-npm && \
    rm -fr ${RAINLOOP_BUILD} /root/.npm /tmp/* /var/cache/apk/*

ADD https://github.com/thorbis-hosting/ParseConfig/releases/download/v0.1/ParseConfig /usr/local/bin/
RUN chmod +x /usr/local/bin/ParseConfig

ADD files/application.ini /app/application.ini
ADD files/autodiscover.php /var/www/rainloop/autodiscover.php
ADD files/default.ini /var/www/rainloop/data/_data_/_default_/domains/default.ini
RUN echo "outlook.com,qq.com,yahoo.com,gmail.com" > /var/www/rainloop/data/_data_/_default_/domains/disabled
ADD httpd.conf /etc/apache2/httpd.conf

WORKDIR $RAINLOOP_HOME

EXPOSE 80

ADD startup.sh /
ENTRYPOINT ["/startup.sh"]
