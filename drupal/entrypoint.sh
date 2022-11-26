#!/bin/sh
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"
echo_green() {
  echo "${GREEN}$1${ENDCOLOR}"
}
echo_red() {
  echo "${RED}$1${ENDCOLOR}"
}
echo_blue() {
  echo "${BLUE}$1${ENDCOLOR}"
}



test -z $DB_HOST && DB_HOST="127.0.0.1"
test -z $DB_NAME && DB_NAME="drupal"
test -z $DB_USER && DB_USER="root"
test -z $DB_PASSWORD && DB_PASSWORD=""
test -z $DRUPAL_ADMIN && DRUPAL_ADMIN="admin"
test -z $DRUPAL_ADMIN_PASS && DRUPAL_ADMIN_PASS="admin"
test -z $DRUPAL_ADMIN_EMAIL && DRUPAL_ADMIN_EMAIL="admin@example.com"
test -z "$DRUPAL_SITE_NAME" && DRUPAL_SITE_NAME="Docker DRUPAL"
# test -z "$DRUPAL_SITE_NAME" && DRUPAL_SITE_NAME="Docker DRUPAL"

pwd
# Create a backup if the --backup or -b option is used
if ([ "$1" = "--backup" ] || [ "$1" = "-b" ]) && [ -d /backup]; then
    echo_blue "Creating a backup of the current Drupal installation..."
    ln -s /config/settings.php web/sites/default/settings.php
    vendor/drush/drush/drush --show-passwords sql-conf
    # view the result of the command
    # vendor/drush/drush/drush --show-passwords sql-conf
    DB_HOST= vendor/drush/drush/drush --show-passwords sql-conf | grep "Host" | awk '{print $2}'
    DB_NAME= vendor/drush/drush/drush --show-passwords sql-conf | grep "Database" | awk '{print $2}'
    DB_USER= vendor/drush/drush/drush --show-passwords sql-conf | grep "Username" | awk '{print $2}'
    DB_PASSWORD= vendor/drush/drush/drush --show-passwords sql-conf | grep "Password" | awk '{print $2}'
    echo_blue "Backing up the database..."
    mysqldump --host=$DB_HOST --user=$DB_USER --password=$DB_PASSWORD $DB_NAME > /backup/backup.sql
    cat /backup/backup.sql
    echo_green "Backup finished"
    if [ $? -eq 0]; then
        echo_green "Backup finished"
    else
        echo_red "Backup failed"
    fi
    exit
fi


# Check if there is drupal already installed
# settings.php is the file that contains database connection info - exists if drupal is installed
echo_blue "Waiting for mysql (mariaDB) to start..."
# echo -e -n "${BLUE}Waiting for mysql (mariaDB) to start...${ENDCOLOR}"
# while ! mysqladmin ping -h"$DB_HOST" --silent; do
#     echo -n "."
#     sleep 1
# done
until mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST -e "select 1" > /dev/null 2>&1; do
    echo -n "."
    sleep 5
done

echo_blue "Checking if drupal is already installed..."
# echo -e "${BLUE}Checking if drupal is already installed...${ENDCOLOR}"
if [ ! -f /config/settings.php ]; then
    echo_blue "Installing Drupal..."
    vendor/drush/drush/drush si standard --yes \
    --db-url=mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME \
    --account-name=$DRUPAL_ADMIN --account-pass=$DRUPAL_ADMIN_PASS \
    --account-mail=$DRUPAL_ADMIN_EMAIL \
    --site-name=$DRUPAL_SITE_NAME
    if [ $? -eq 0 ]; then
        chown -R www-data.www-data web
        # clearing cache
        vendor/drush/drush/drush cache:rebuild
        mv web/sites/default/settings.php /config/settings.php
        ln -s /config/settings.php web/sites/default/settings.php
        echo_green "Instalation SUCCESSFUL"
        # echo "${GREEN}Instalation SUCCESSFUL${ENDCOLOR}"
    else
        echo_red "Instalation FAILED"
        # echo -e "${RED}Instalation FAILED${ENDCOLOR}"
        exit 1
    fi
fi

# default entrypoint
/usr/local/bin/docker-php-entrypoint -D FOREGROUND