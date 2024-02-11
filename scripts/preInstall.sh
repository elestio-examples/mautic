set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./mautic-docroot
chown -R 1000:1000 ./mautic-docroot
mkdir -p ./mautic/config
chown -R 1000:1000 ./mautic/config

cat << EOT >> ./mautic/config/local.php
<?php
\$_SERVER['HTTPS'] = 'on';
\$parameters = array(
	'db_driver' => 'pdo_mysql',
	'db_host' => '${MAUTIC_DB_HOST}',
	'db_port' => '${MAUTIC_DB_PORT}',
	'db_name' => '${MAUTIC_DB_DATABASE}',
	'db_user' => '${MAUTIC_DB_USER}',
	'db_password' => '${MAUTIC_DB_PASSWORD}',
	'db_table_prefix' => null,
	'db_backup_tables' => 1,
	'db_backup_prefix' => 'bak_',
	'mailer_from_name' => 'Mautic',
	'mailer_from_email' => '${SMTP_FROM}',
	'mailer_reply_to_email' => null,
	'mailer_return_path' => null,
	'mailer_append_tracking_pixel' => 1,
	'mailer_convert_embed_images' => 0,
	'mailer_custom_headers' => array(

	),
	'mailer_dsn' => 'smtp://${SMTP}:${SMTP_PORT}',
);

EOT

cat << EOT >> ./.mautic_env
MAUTIC_DB_HOST="${MAUTIC_DB_HOST}"
MAUTIC_DB_PORT="${MAUTIC_DB_PORT}"
MAUTIC_DB_DATABASE="${MAUTIC_DB_DATABASE}"
MAUTIC_DB_USER="${MAUTIC_DB_USER}"
MAUTIC_DB_PASSWORD="${MAUTIC_DB_PASSWORD}"

EOT