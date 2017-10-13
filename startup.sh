#!/bin/sh
mkdir -p /var/www/rainloop/data/_data_/_default_/configs
/usr/local/bin/ParseConfig /app/application.ini /var/www/rainloop/data/_data_/_default_/configs/application.ini
chown -R apache:apache ${RAINLOOP_HOME}
sh -c "find . -type d -exec chmod 755 {} \;"
sh -c "find . -type f -exec chmod 644 {} \;"

/usr/sbin/httpd -D FOREGROUND
