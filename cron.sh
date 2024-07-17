cd /opt/app/;

docker-compose exec mautic   php /var/www/html/bin/console mautic:segments:update > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:import > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:campaigns:rebuild > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:campaigns:trigger > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:messages:send > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:emails:send > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:email:fetch > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:social:monitoring > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:webhooks:process > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:broadcasts:send > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:maintenance:cleanup --days-old=365 -n > /var/log/cron.pipe 2>&1

# docker-compose exec mautic   php /var/www/html/bin/console mautic:iplookup:download > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:reports:scheduler > /var/log/cron.pipe 2>&1

docker-compose exec mautic   php /var/www/html/bin/console mautic:unusedip:delete > /var/log/cron.pipe 2>&1
