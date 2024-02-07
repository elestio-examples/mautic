# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting for Friendica to be ready..."
sleep 60s;

