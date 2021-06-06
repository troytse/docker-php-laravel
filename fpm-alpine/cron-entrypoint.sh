#!/bin/sh
if [ `expr match "$SET_CRONTAB" "[O|o][N|n]$"` -ne 0 ]; then
    /bin/sh -c "/usr/local/bin/php /var/www/html/artisan schedule:run >> /dev/null 2>&1"
fi
