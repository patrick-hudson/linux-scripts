#!/bin/bash

while read domains; do
        touch /var/log/httpd/$domains-access_log
        touch /var/log/httpd/$domains-error_log
        cp /etc/httpd/testvhosts/template /etc/httpd/testvhosts/$domains.conf
        sed -i 's/<domain>/'$domains'/g' /etc/httpd/testvhosts/$domains.conf
        domain=${domains%.*}
        tld=${domains#*.}
        printf '%s\n%s%s\n%s%s%s\n\n' "#Redirect $domains to www.$domains" "RewriteCond %{HTTP_HOST} ^$domain\.$tld" '$' "RewriteRule (.*) http://www.$domains" '$1' " [R=301,L]" >> /etc/httpd/testvhosts/htaccess.txt
        echo "created vhost for $domains"
done </root/domains.txt
