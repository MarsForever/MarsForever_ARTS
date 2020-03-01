#### download
Apache + MariaDB + PHP + Perl
https://www.apachefriends.org/index.html

xampp-win32-7.0.4-0-VC14-installer.exe
#### setting
apache-> config -> 
hhtpd.conf => $port like 3000
hhtpd-ssl.conf => $port like 1443
The $port must be not be used by other applications

config=> Service and Port Settings
the port must same to apache settings

#### IDE phpstorm
https://www.jetbrains.com/phpstorm/

#### composer
https://getcomposer.org/
download
https://getcomposer.org/Composer-Setup.exe

Search package for composer
https://packagist.org/


#### Create new composer
new start cmd
type composer

or start git command prompt
cd xampp/htdocs/

version 5.2.29
composer create-project --prefer-dist laravel/laravel cms 5.2.29
latest
composer create-project --prefer-dist laravel/laravel cms

Create new project on git command prompt
cd xampp/htdocs/
composer create-project --prefer-dist laravel/laravel todoapp 5.2.29
edit host file
C:\Windows\System32\drivers\etc\host
```
127.0.0.1       localhost
127.0.0.1       cms.dev
127.0.0.1       todoapp.dev
```
C:\xampp\apache\conf\extra\httpd-vhosts.conf
```
<VirtualHost *:80>
    DocumentRoot "C:/xampp/htdocs/"
    ServerName localhost
</VirtualHost>
<VirtualHost *:80>
    DocumentRoot "C:/xampp/htdocs/cms/public"
    ServerName cms.dev
</VirtualHost>
<VirtualHost *:80>
    DocumentRoot "C:/xampp/htdocs/apptodo/public"
    ServerName apptodo.dev
</VirtualHost>
```
and restart xampp apache



