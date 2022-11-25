#!/bin/sh
test -z $DB_HOST && DB_HOST="127.0.0.1"
test -z $DB_NAME && DB_NAME="drupal"
test -z $DB_USER && DB_USER="root"
test -z $DB_PASSWORD && DB_PASSWORD=""
test -z $DRUPAL_ADMIN && DRUPAL_ADMIN="admin"
test -z $DRUPAL_ADMIN_PASS && DRUPAL_ADMIN_PASS="admin"
test -z $DRUPAL_ADMIN_EMAIL && DRUPAL_ADMIN_EMAIL="admin@example.com"
test -z "$DRUPAL_SITE_NAME" && DRUPAL_SITE_NAME="Docker DRUPAL"

# ....

# default entrypoint
/usr/local/bin/docker-php-entrypoint -D FOREGROUND