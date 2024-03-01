# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for software to be ready..."
sleep 120s;


while ! curl -f http://172.17.0.1:7015; do sleep 5; done

sed -i \
 -e "s\.*mailer_host.*\'mailer_host' => '172.17.0.1',\g" \
 -e "s\.*mailer_port.*\'mailer_port' => '25',\g" \
 ./mautic/app/config/local.php
