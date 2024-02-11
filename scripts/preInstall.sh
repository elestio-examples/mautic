set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./mautic-docroot
chown -R 1000:1000 ./mautic-docroot
mkdir -p ./mautic/config
chown -R 1000:1000 ./mautic/config

cat << EOT >> ./mautic/config/local.php
<?php
\$parameters = array(
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
MAUTIC_MESSENGER_DSN_EMAIL="doctrine://default"
MAUTIC_MESSENGER_DSN_HIT="doctrine://default"

EOT