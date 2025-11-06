#Base image
FROM php:8.4

#Work directory
WORKDIR /projet

#Copy laravel project in /project directory
COPY app ./

#install php 8.4.11 et de composer
RUN apt update && apt-get install libfreetype-dev libjpeg62-turbo-dev libpng-dev libpq-dev zip -y \
    &&php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"\
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
