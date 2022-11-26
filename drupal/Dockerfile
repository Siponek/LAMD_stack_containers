# ...
ARG DRUPAL_VERSION=8.9.1
ARG COMPOSER_VERSION=2.4.4

FROM php:7.4-apache
LABEL author="Drupal Docker Team"

ARG DRUPAL_VERSION
ARG COMPOSER_VERSION

# ENV DB_HOST=$ENV_DB_HOST
# ENV DB_NAME=$ENV_DB_NAME
# ENV DB_USER=$ENV_DB_USER
# ENV DB_PASSWORD=$ENV_DB_PASSWORD
# ENV DRUPAL_ADMIN=$ENV_DRUPAL_ADMIN
# ENV DRUPAL_ADMIN_PASS=$ENV_DRUPAL_ADMIN_PASS
# ENV DRUPAL_ADMIN_EMAIL=$ENV_DRUPAL_ADMIN_EMAIL
# ENV DRUPAL_SITE_NAME=$ENV_DRUPAL_SITE_NAME

RUN apt update \
    && apt -y install iputils-ping iproute2 default-mysql-client \
    && apt -y install zlib1g-dev libpng-dev zip git \
    && docker-php-ext-install gd pdo pdo_mysql \
    && docker-php-ext-enable gd pdo pdo_mysql

RUN curl -o /usr/local/bin/composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar
RUN chmod a+x /usr/local/bin/composer \
    && composer create-project drupal/recommended-project:${DRUPAL_VERSION} /usr/local/drupal

#? changing the working directory to /usr/local/drupal
WORKDIR /usr/local/drupal
# Installing Drupal Shell
RUN composer require drush/drush \
    && composer update

#Make a backup of HTML folder
RUN mv /var/www/html /var/www/html_OLD \
    && ln -s /usr/local/drupal/web /var/www/html

# # Running DruSh commands
# RUN vendor/drush/drush/drush si standard --yes \
#     --db-url=mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME \
#     --account-name=$DRUPAL_ADMIN --account-pass=$DRUPAL_ADMIN_PASS \
#     --account-mail=$DRUPAL_ADMIN_EMAIL \
#     --site-name=$DRUPAL_SITE_NAME

# Change the ownership and group of the files  to www-data
ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chown -R www-data:www-data /var/www/html \
    && chmod a+x /usr/local/bin/entrypoint.sh


ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "" ]