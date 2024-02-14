<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Mautic, verified and packaged by Elestio

[Mautic](https://mautic.io/): Open Source Marketing Automation Software.

<img src="https://raw.githubusercontent.com/elestio-examples/mautic/main/mautic.png" alt="mautic" width="800">

[![deploy](https://github.com/elestio-examples/mautic/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/mautic)

Deploy a <a target="_blank" href="https://elest.io/open-source/mautic">fully managed Mautic</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/mautic.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command
./scripts/preInstall.sh
docker-compose up -d
./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:7015`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3"

    x-mautic-volumes: &mautic-volumes
    - ./mautic/config:/var/www/html/config:z
    - ./mautic/logs:/var/www/html/var/logs:z
    - ./mautic/media/files:/var/www/html/docroot/media/files:z
    - ./mautic/media/images:/var/www/html/docroot/media/images:z
    - ./cron:/opt/mautic/cron:z
    - mautic-docroot:/var/www/html/docroot:z

    services:
    db:
        image: elestio/mysql:8.0
        restart: always
        environment:
            - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
            - MYSQL_DATABASE=${MYSQL_DATABASE}
            - MYSQL_USER=${MYSQL_USER}
            - MYSQL_PASSWORD=${MYSQL_PASSWORD}
        volumes:
            - ./mysql-data:/var/lib/mysql
        healthcheck:
            test: mysqladmin --user=$$MYSQL_USER --password=$$MYSQL_PASSWORD ping
            start_period: 5s
            interval: 5s
            timeout: 5s
            retries: 10

    nginx:
        image: nginx
        restart: always
        volumes:
            - ./nginx.conf:/etc/nginx/conf.d/default.conf
            - mautic-docroot:/var/www/html/docroot:z
        depends_on:
            - mautic_web
        ports:
            - 172.17.0.1:7015:80

    mautic_web:
        image: mautic/mautic:${SOFTWARE_VERSION_TAG}
        restart: always
        links:
            - db:db
        volumes: *mautic-volumes
        environment:
            - DOCKER_MAUTIC_LOAD_TEST_DATA=${DOCKER_MAUTIC_LOAD_TEST_DATA}
            - DOCKER_MAUTIC_RUN_MIGRATIONS=${DOCKER_MAUTIC_RUN_MIGRATIONS}
            # - MAUTIC_MESSENGER_DSN_EMAIL=doctrine://default
            # - MAUTIC_MESSENGER_DSN_HIT=doctrine://default
        env_file:
            - .mautic_env
        healthcheck:
            test: cgi-fcgi -bind -connect 127.0.0.1:9000
            start_period: 5s
            interval: 5s
            timeout: 5s
            retries: 100
        depends_on:
            db:
                condition: service_healthy

    mautic_cron:
        image: mautic/mautic:${SOFTWARE_VERSION_TAG}
        restart: always
        links:
            - db:db
        volumes: *mautic-volumes
        environment:
            - DOCKER_MAUTIC_ROLE=mautic_cron
        depends_on:
            mautic_web:
                condition: service_healthy

    mautic_worker:
        image: mautic/mautic:${SOFTWARE_VERSION_TAG}
        restart: always
        links:
            - db:db
        volumes: *mautic-volumes
        environment:
            - DOCKER_MAUTIC_ROLE=mautic_worker
            - DOCKER_MAUTIC_LOAD_TEST_DATA=${DOCKER_MAUTIC_LOAD_TEST_DATA}
            - DOCKER_MAUTIC_RUN_MIGRATIONS=${DOCKER_MAUTIC_RUN_MIGRATIONS}
            # - MAUTIC_MESSENGER_DSN_EMAIL=doctrine://default
            # - MAUTIC_MESSENGER_DSN_HIT=doctrine://default
        depends_on:
            mautic_web:
                condition: service_healthy

    volumes:
    mautic-docroot:
        driver: local
        driver_opts:
        type: none
        device: ${PWD}/mautic-docroot
        o: bind

### Environment variables

|           Variable           |   Value (example)   |
| :--------------------------: | :-----------------: |
|     SOFTWARE_VERSION_TAG     |       latest        |
|         ADMIN_EMAIL          |   your@email.com    |
|        ADMIN_PASSWORD        |    your-password    |
|     MYSQL_ROOT_PASSWORD      |    your-password    |
|        MYSQL_PASSWORD        |    your-password    |
|          MYSQL_USER          |   mautic_db_user    |
|             SMTP             |   your.smtp.host    |
|          SMTP_PORT           |   your.smtp.port    |
|          SMTP_FROM           |   from@email.com    |
|         CI_CD_DOMAIN         |     your.domain     |
|          MYSQL_HOST          |         db          |
|          MYSQL_PORT          |        3306         |
|        MYSQL_DATABASE        |      mautic_db      |
| DOCKER_MAUTIC_RUN_MIGRATIONS |        false        |
| DOCKER_MAUTIC_LOAD_TEST_DATA |        false        |
|        MAUTIC_DB_HOST        |         db          |
|        MAUTIC_DB_PORT        |        3306         |
|      MAUTIC_DB_DATABASE      |      mautic_db      |
|        MAUTIC_DB_USER        |   mautic_db_user    |
|      MAUTIC_DB_PASSWORD      |    your-password    |
|  MAUTIC_MESSENGER_DSN_EMAIL  | doctrine://default  |
|   MAUTIC_MESSENGER_DSN_HIT   | doctrine://default  |
|          MAUTIC_URL          | https://your.domain |
|      MAUTIC_ADMIN_EMAIL      |   your@email.com    |
|    MAUTIC_ADMIN_USERNAME     |        admin        |
|    MAUTIC_ADMIN_PASSWORD     |    your-password    |

# Maintenance

## Logging

The Elestio Mautic Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://docs.mautic.org/en/5.x/">Mautic documentation</a>

- <a target="_blank" href="https://github.com/mautic/mautic">Mautic Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/mautic">Elestio/Mautic Github repository</a>
