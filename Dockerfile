#Base image
FROM php:8.4

#Work directory
WORKDIR /projet

#Copy laravel project in /project directory
COPY app ./

#install php 8.4.11 et de composer
RUN apt update && apt-get install libfreetype-dev libjpeg62-turbo-dev libpng-dev libpq-dev zip -y \
    &&php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"\
	&&php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"\
	&&php composer-setup.php\
	&&php -r "unlink('composer-setup.php');"\
    && mv composer.phar /usr/local/bin/composer\
    && docker-php-ext-install pdo pgsql pdo_pgsql

#Run 
EXPOSE 8000

RUN adduser www \
	&& usermod -aG www www


#Give [ermission
RUN chmod u+x /projet/entrypoint.sh

#Generated key
RUN composer install && php artisan key:gen

RUN chown -R www:www /projet \
	&& chmod -R 775 /projet/storage

USER www

#Start main project

#ENTRYPOINT ["sleep", "1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"]

ENTRYPOINT ["php", "artisan", "serve", "--host", "0.0.0.0"]
