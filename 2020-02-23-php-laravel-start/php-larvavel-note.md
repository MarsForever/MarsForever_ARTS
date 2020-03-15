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

##### windows
setting > appearance & Behavior \
Theme:darcula \
Editor > Color Scheme \
Monokai \
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
127.0.0.1       cms.test
127.0.0.1       todoapp.test
```
C:\xampp\apache\conf\extra\httpd-vhosts.conf
```
<VirtualHost *:3000>
    DocumentRoot "C:/xampp/htdocs/"
    ServerName localhost
</VirtualHost>
<VirtualHost *:3000>
    DocumentRoot "C:/xampp/htdocs/cms/public"
    ServerName cms.test
</VirtualHost>
<VirtualHost *:3000>
    DocumentRoot "C:/xampp/htdocs/apptodo/public"
    ServerName apptodo.test
</VirtualHost>
```
and restart xampp apache

#### Use PhpStorm
open project
C:\xampp\htdocs\cms

#### Section 4:Lravel Fundamentals - Routes
https://laravel.com/docs/5.2/routing
app/config/app.php \
class provider \

app/config/database.php \
database setting \
env => .env file \

app/config/mail.php \
mail configrations \

app/database/factories/ModelFactory.php \
create contents,post information \
app/database/factories/migrations \
create tables \

storage \
package you will use \

##### Routes part
C:\xampp\htdocs\cms
app/Http/routes.php \

```php
<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

Route::get('', function () {
    return view('welcome');
});

Route::get('/about', function () {
    return "Hi about page";
});

Route::get('/contact', function () {
    return "welcome to contact me";
});

Route::get('/post/{id}/{name}',function($id, $name){
    return "This is post number ". $id . " ". $name;
});

Route::get('admin/posts/example', array('as'=>'admin.home' ,function(){
    $url = route('admin.home');

    return "This url is " . $url;
}));
```
###### show url and route
git command prompt
/c/xampp/htdocs/cms
php artisan route:list

#### Section 5: Laravel Fundamentals - Controllers

###### create controller

php artisan make:controller $name
###### create controller and with some methods
php artisan make:controller --resource $name

####### Example1
routes.php
```php
Route::get('/post','PostsController@index');
```
PostsController.php
```php
   public function index()
    {
        //
        return "its working the number is ";
    }
```
####### Example2
routes.php
```php
Route::get('/post/{id}','PostsController@index');
```
PostsController.php
```php
   public function index($id)
    {
        //
        return "its working the number is " . $id;
    }
```
https://laravel.com/docs/5.2/controllers

####### Example3
routes.php
```php
Route::resource('posts', 'PostsController');
```
PostsController.php
```php
    public function show($id)
    {
        //
        return "this is the show method mars " . $id;
    }
```

#### Section 8:Lravel Fundamentals - Database

config file \

config/database.php



https://github.com/vlucas/phpdotenv



##### Create database

cms.test:3000/phpmyadmin

click database

create table which name laravel_cms(Collation)



.env (default setting)

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_cms
DB_USERNAME=root
DB_PASSWORD=
```

C:\xampp\htdocs\cms> php artisan migrate --no-ansi

```
Migrated: 2014_10_12_000000_create_users_table
Migrated: 2014_10_12_100000_create_password_resets_table
```

You can check there is 3 tables in the following url

cms.test:3000/phpmyadmin

##### Create table and drop it

php artisan make:migration create_posts_table --create="posts" \

it will create a file under database/migrations/xxx_create_posts_table.php \

php artisan migrate \

it will create the table on the database \

php artisan migrate:rollback \

It will rollback the operation

##### Adding columns to existing tables (don't recommend in prodcution environment)
php artisan make:migration add_is_admin_column_to_posts_tables --table="posts" --no-ansi

edit 2020_03_14_150640_add_is_admin_column_to_posts_tables.php
```php
<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class AddIsAdminColumnToPostsTables extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('posts', function (Blueprint $table) {
            //

            $table->string('is_admin')->unsinged();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('posts', function (Blueprint $table) {
            //

            $table->dropColumn('is_admin');
        });
    }
}

```
php artisan migrate
```
Migrated: 2020_03_14_150640_add_is_admin_column_to_posts_tables
```
Check cms.test:3000/phpmyadmin database laravel_cms's post table

[migrate 5.2  documentation](https://laravel.com/docs/5.2/migrations)



###### all rollback

php artisan migrate:reset

###### all migrate

php artisan migrate

###### Reset and re-run all migrations

php artisan migrate:refresh

######  Show the status of each migration

php artisan migrate:status --no-ansi



#### Section9: Laravel Fundamentals - Raw SQL Queries

1. Inserting data

   

2. Reading data

   

3. Updating data

   

4. Deleting data





