git clone https://github.com/mautic/docker-mautic.git docker
rm -f ./docker/README.md
mv ./docker/* .
mv ./fpm/Dockerfile ./Dockerfile

mkdir -p ./mautic-docroot
chown -R 1000:1000 ./mautic-docroot
mkdir -p ./mautic/config
chown -R 1000:1000 ./mautic/config


docker buildx build . --output type=docker,name=elestio4test/mautic:latest | docker load