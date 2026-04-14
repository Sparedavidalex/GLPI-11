#!/bin/bash

 1  sudo apt uptade && sudo upgrade -y
    2  sudo apt update && sudo upgrade -y
    3  sudo apt install apache2 mariadb-server php libapache2-mod-php php-curl php-gd php-mbstring php-xml php-mysql php-bz2 php-zip php-intl php-ldap php-apcu -y
    4  cd /tmp
    5  wget https://github.com/glpi-project/glpi/releases/download/11.0.6/glpi-11.0.6.tgz
    6  tar -xvzf glpi-11.0.6.tgz
    7  sudo mv glpi /var/www/html/
    8  sudo chown -R www-data:www-data /var/www/html/glpi
    9  cd /var/www/html
   10  sudo wget https://github.com/glpi-project/glpi/releases/download/11.0.6/glpi-11.0.6.tgz
   11  sudo tar -xvzf glpi-11.0.6.tgz
   12  sudo rm glpi-11.0.6.tgz
   13  sudo chown -R www-data:www-data /var/www/html/glpi
   14  sudo chmod -R 755 /var/www/html/glpi
   15  sudo nano /etc/apache2/sites-available/glpi.conf
   16  sudo a2enmod rewrite
   17  sudo a2ensite glpi.conf
   18  sudo a2dissite 000-default.conf
   19  sudo systemctl restart apache2
   20  sudo nano /etc/php/8.x/apache2/php.ini
   21  sudo nano /etc/php/$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")/apache2/php.ini
   22  sudo systemctl restart apache2
   23  sudo apt update
   24  sudo apt install php-bcmath php-sodium php-opcache -y~sudo apt update
   25  sudo apt install php-bcmath php-sodium php-opcache -y
   26  sudo systemctl restart apache2
   27  sudo apt install php-apcu -y
   28  sudo systemctl restart apache2
   29  php -v
   30  sudo apt update
   31  sudo apt install php8.3-bcmath -y
   32  sudo phpenmod bcmath
   33  sudo systemctl restart apache2
   34  sudo apt update
   35  sudo apt install mariadb-server -y
   36  sudo mysql -u root
   37  mysql -u glpi_user -p
   38  sudo mysql -u root
   39  mysql -u glpi_user -p
   40  sudo apt update
   41  sudo apt install certbot python3-certbot-apache -y
   42  sudo certbot --apache
   43  sudo apt update
   44  sudo nano /etc/apache2/sites-available/glpi.conf
   45  sudo systemctl reload apache2
