# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready..."
sleep 120s;



docker-compose exec -T mautic_web bash -c "php /var/www/html/bin/console mautic:install https://${CI_CD_DOMAIN} --db_driver='pdo_mysql' --db_host='${MYSQL_HOST}' --db_port='${MYSQL_PORT}' --db_name='${MYSQL_DATABASE}' --db_user='${MYSQL_USER}' --db_password='${MYSQL_PASSWORD}' --db_backup_tables='false' --admin_email='${ADMIN_EMAIL}' --admin_password='${ADMIN_PASSWORD}' --admin_firstname='admin' --admin_lastname='admin' --admin_username='admin'"


docker-compose down;


sed -i "s~# - MAUTIC_MESSENGER_DSN_EMAIL=doctrine://default~- MAUTIC_MESSENGER_DSN_EMAIL=doctrine://default~g" ./docker-compose.yml
sed -i "s~# - MAUTIC_MESSENGER_DSN_HIT=doctrine://default~- MAUTIC_MESSENGER_DSN_HIT=doctrine://default~g" ./docker-compose.yml

insert_line='$_SERVER['\''HTTPS'\''] = '\''on'\'';'
sed -i "1 s|\(<?php\)|\1\n$insert_line|" "./mautic/config/local.php"


docker-compose up -d