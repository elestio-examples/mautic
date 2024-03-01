# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready..."
sleep 120s;


while ! curl -f http://172.17.0.1:7015; do sleep 5; done

sed -i \
 -e "s\.*mailer_host.*\'mailer_host' => '172.17.0.1',\g" \
 -e "s\.*mailer_port.*\'mailer_port' => '25',\g" \
 ./mautic/app/config/local.php


docker-compose exec -T mautic bash -c "php /var/www/html/bin/console mautic:install https://${DOMAIN} --db_driver='pdo_mysql' --db_host='mysql' --db_port='3306' --db_name='${DB_MYSQL_NAME}' --db_user='${DB_MYSQL_USER}' --db_password='${DB_MYSQL_PASSWORD}' --db_backup_tables='false' --admin_email='${ADMIN_EMAIL}' --admin_password='${APP_PASSWORD}' --admin_firstname='admin' --admin_lastname='admin' --admin_username='admin'"
