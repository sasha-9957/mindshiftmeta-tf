#cloud-config

write_files:
  - content: |
      <VirtualHost *:80>
        ServerName landingdev.mindshiftmeta.net
        ServerAlias www.landingdev.mindshiftmeta.net
        DocumentRoot /var/www/html

        ErrorLog /var/log/httpd/error_log
        CustomLog /var/log/httpd/access_log combined

        <FilesMatch \.php$>
          SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost/"
        </FilesMatch>

        <Directory /var/www/html>
          Options +FollowSymLinks -Indexes
          AllowOverride All
          Require all granted
        </Directory>

        <IfModule mod_headers.c>
          Header set X-Content-Type-Options nosniff
          Header set X-Frame-Options SAMEORIGIN
          Header set X-XSS-Protection "1; mode=block"
          SetEnvIf X-Forwarded-Proto "https" HTTPS=on
        </IfModule>

        <IfModule mod_headers.c>
            <FilesMatch "\.(ttf|ttc|otf|eot|woff|woff2)$">
              Header set Access-Control-Allow-Origin "*"
            </FilesMatch>
        </IfModule>

        <FilesMatch "(/wp-content/themes/.+|/wp-content/plugins/.+)/.+\.(php|html|css|js)">
          Require all denied
        </FilesMatch>

        <LocationMatch "(?i:(?:wp-config\\.bak|\\.wp-config\\.php\\.swp|(?:readme|license|changelog|-config|-sample)\\.(?:php|md|txt|htm|html)))">
          Require all denied
        </LocationMatch>


        <FilesMatch "(/wp-content/themes/.+|/wp-content/plugins/.+)/.+\.(php|html|css|js)">
          Require all denied
        </FilesMatch>

        <LocationMatch "(?i:(?:wp-config\\.bak|\\.wp-config\\.php\\.swp|(?:readme|license|changelog|-config|-sample)\\.(?:php|md|txt|htm|html)))">
          Require all denied
        </LocationMatch>

        <LocationMatch "(?i:.*/cache/.*\\.ph(?:p[345]?|t|tml))">
          Require all denied
        </LocationMatch>

        Protocols h2 h2c http/1.1

        <Files wp-config.php>
          Require all denied
        </Files>

        <Files .htaccess>
          Require all denied
        </Files>

        <Files xmlrpc.php>
          Require all denied
        </Files>
      </VirtualHost>
    path: /etc/httpd/conf.d/mindshiftmeta.conf

runcmd:
  - sudo dnf update
  - sudo dnf install -y wget unzip net-tools nano mc httpd mod_ssl htop telnet nc ImageMagick ImageMagick-devel
  - sudo dnf install -y php8.2-fpm php8.2-cli php-common php8.2-gd php8.2-intl php-json php8.2-mbstring php8.2-mysqlnd php8.2-opcache php8.2-pdo php-pear php8.2-process php8.2-soap php8.2-sodium php8.2-xml php8.2-zip php-devel
  - yes "" | sudo pecl install imagick
  - echo "extension=imagick.so" | sudo tee -a /etc/php.ini
  - sudo sed -i 's/memory_limit = .*/memory_limit = 256M/' /etc/php.ini
  - sudo sed -i 's/max_execution_time = .*/max_execution_time = 300/' /etc/php.ini
  - sudo sed -i 's/max_input_time = .*/max_input_time = 300/' /etc/php.ini
  - sudo sed -i 's/upload_max_filesize = .*/upload_max_filesize = 64M/' /etc/php.ini
  - sudo sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php.ini
  - sudo sed -i 's/max_file_uploads =.*/max_file_uploads = 20/' /etc/php.ini
  - sudo sed -i 's/;opcache.max_accelerated_files=.*'/opcache.max_accelerated_files=20000/  /etc/php.d/10-opcache.ini
  - sudo sed -i 's/;opcache.memory_consumption=.*'/opcache.memory_consumption=1024/  /etc/php.d/10-opcache.ini
  - sudo sed -i 's/;opcache.revalidate_freq=.*'/opcache.revalidate_freq=90/  /etc/php.d/10-opcache.ini
  - sudo systemctl enable httpd
  - sudo systemctl enable php-fpm
  - sudo systemctl start httpd
  - sudo systemctl start php-fpm
  - cd /tmp
  - curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  - chmod +x wp-cli.phar
  - sudo mv wp-cli.phar /usr/local/bin/wp
