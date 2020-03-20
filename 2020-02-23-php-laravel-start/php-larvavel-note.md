### Section2 Windows - Local Environment Setup
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

### Section 4:Lravel Fundamentals - Routes
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

#### Routes part
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

### Section 5: Laravel Fundamentals - Controllers

##### create controller

php artisan make:controller $name
###### create controller and with some methods
php artisan make:controller --resource $name

###### Example1
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
###### Example2
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

###### Example3
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

### Section 8:Lravel Fundamentals - Database
config file \
config/database.php \

https://github.com/vlucas/phpdotenv


#### Create database
cms.test:3000/phpmyadmin \
click database \
create table which name laravel_cms(Collation) \
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
You can check there is 3 tables in the following url \
cms.test:3000/phpmyadmin
#### Create table and drop it
php artisan make:migration create_posts_table --create="posts" \
it will create a file under database/migrations/xxx_create_posts_table.php \
php artisan migrate \
it will create the table on the database \
php artisan migrate:rollback \
It will rollback the operation \
#### Adding columns to existing tables (don't recommend in prodcution environment)
php artisan make:migration add_is_admin_column_to_posts_tables --table="posts" --no-ansi \
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
Check cms.test:3000/phpmyadmin database laravel_cms's post table \
[migrate 5.2  documentation](https://laravel.com/docs/5.2/migrations)

###### all rollback
php artisan migrate:reset

###### all migrate
php artisan migrate

###### Reset and re-run all migrations
php artisan migrate:refresh

######  Show the status of each migration
php artisan migrate:status --no-ansi

### Section9: Laravel Fundamentals - Raw SQL Queries
add stuff at $/app/Http/routes.php

1. Inserting data

   ```php
   Route::get('/insert',function(){
       DB::insert('insert into posts(title,content) value(?,?)',['PHP with Laravel','Laravel is the best thing that has happened to PHP']);
       DB::insert('insert into posts(title,content) value(?,?)',['php 2 ','php content']);
   });
   ```

   access cms.test:3000/insert \
   check database laravel_cms's table posts has been added two data

2. Reading data
   ```php
   //Reading data
   Route::get('/read',function(){
       $results = DB::select('select * from posts where id = ?', [1]);
   //output array in details
       return var_dump($results);
   //get first data of posts
       return $results;
   //get first data of posts's title
       foreach($results as $post){
           return $post->title;
       }
   });
   ```

3. Updating data
   ```php
   //Updating data
   Route::get('/update',function(){
      $updated = DB::update('update posts set title = "update title" where id= ?', [1]);
      return $updated;
   });
   ```

4. Deleting data
```php
//Deleting data
Route::get('/delete',function(){
    $delete = DB::delete('delete from posts where id = ?',[1]);
    return $delete;
});
```
[Database Raw SQL Queries 5.2](https://laravel.com/docs/5.2/database)

### Section10: Laravel Fundamentals - Database - Eloquent/ ORM

1. Reading Data

   - Create a model,it will crate Post.php under app folder.

   php artisan make:model Post

   add following code in routes.php

   ```
   use App\Post;
   /*
   |-------------------------------------------------------------------
   | ELOQUENT
   |-------------------------------------------------------------------
    */
   
   Route::get('/read',function(){
   //    get the first record's title
       $posts = Post::all();
       foreach( $posts as $post){
           echo $post->title . " <br>";
       }
   });
   
   
   Route::get('/find',function(){
      $post = Post::find(1);
      echo $post->title;
   });
   ```

   

2. Reading / Finding with Constraints

   ```
   // Reading / Finding with Constraints
   Route::get('/findwhere',function(){
       $posts = Post::where('id',2)->orderBy('id','desc')->take(2)->get();
       return $posts;
   });
   ```

   

3. More way to retrieve data

   ```php
   // More ways to retrieve data
   Route::get('/findmore',function(){
      // example 1
       $posts = Post::findOrFail(1);
      // example 2
      // $posts = Post::where('users_count','<',50)->firstOrFail();
      return $posts;
   });
   ```

   

4. Inserting /Saving Data

   ```php
   // Inserting / Saving Data
   // example 1
   Route::get('/basicinsert',function(){
       $post = new Post;
       $post->title = 'New Eloquent title insert';
       $post->content = 'Wow eloquent is very cool, look a t this content';
       $post->save();
   });
   // example 2
   Route::get('/basicinsert2',function(){
       $post = Post::find(2);
       $post->title = 'title 2';
       $post->content = 'content2';
       $post->save();
   });
   ```

   

5. Creating data and configuring mass assignment

   routes.php

   ```php
   Route::get('/create',function(){
       Post::create(['title'=>'the create method', 'content'=>'I am learning about php']);
   });
   ```

   Post.php

   ```php
   class Post extends Model
   {
   //    protected $table = 'posts';
   //    protected $primaryKey = 'post_id';
       protected $fillable = [
           'title',
           'content'
       ];
   }
   ```

   

6. Updating with Eloquent

   ```php
   Route::get('/update',function(){
       Post::where('id',2)->where('is_admin',0)->update(['title'=>'New php title','content'=>'I love you']);
   });
   ```

   

7. Deleting Data

   ```php
   //example 1
   Route::get('delete',function(){
       $post = Post::find(8);
       $post->delete();
   });
   //example 2
   Route::get('delete2',function(){
   // delete id 2   
       Post::destroy(2);
   // delete id from 1 to 2    
       Post::destroy(1,2);
   // delete data which is_admin is 0    
       Post::where('is_admin', 0)->delete();
   });
   ```

   

8. Soft Deleting / Trashing(Logical delete)

   command operation

   ```cmd
   php artisan make:migration add_deleted_at_colum_to_pots_tables --table=posts --no-ansi
   php artisan migrate
   ```

   Post.php

   ```php
   <?php
   
   namespace App;
   
   use Illuminate\Database\Eloquent\Model;
   use Illuminate\Database\Eloquent\SoftDeletes;
   
   class Post extends Model
   {
       use SoftDeletes;
   //    protected $table = 'posts';
   //    protected $primaryKey = 'post_id';
   
       protected $data = ['deleted_at'];
       protected $fillable = [
           'title',
           'content'
       ];
   }
   ```

   yyyy_mm_dd_xxxxxx_add_deleted_at_colum_to_pots_tables.php

   ```php
   <?php
   
   use Illuminate\Database\Schema\Blueprint;
   use Illuminate\Database\Migrations\Migration;
   
   class AddDeletedAtColumnToPostsTables extends Migration
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
               $table->softDeletes();
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
               $table->dropColumn('deleted_at');
               //
           });
       }
   }
   ```

   routes.php

   ```php
   Route::get('/softdelete',function(){
       Post::find(11)->delete();
   
   });
   ```

9. Retrieving deleted / trashed records

   routes.php

   ```php
   Route::get('/readsoftdelete',function(){
   //    $post = Post::find(9);
   //    return $post;
       // example 1
       // show all data include logically  deleted data
       $post = Post::Trashed()->where('is_admin', 0)->get();
       return $post;
       // example 2
       // only show data which is logically deleted data
       $post = Post::onlyTrashed()->where('is_admin', 0)->get();
       return $post;
   });
   ```

10. Restoring deleted / trashed records

    ```php
    Route::get('/restore',function(){
        Post::withTrashed()->where('is_admin', 0)->restore();
    });
    ```

11. Deleting a record permanently

    ```php
    // example 1 delete with trashed
    Route::get('forcedelete',function(){
        Post::withTrashed()->where('is_admin', 0)->forceDelete();
    });
    // example 2 delete only trashed
    Route::get('forcedelete2',function(){
        Post::onlyTrashed()->where('is_admin', 0)->forceDelete();
    });
    ```

[Docs - Eloquent 5.2](https://laravel.com/docs/5.2/eloquent)

### Section12:Laravel Fundamentals - Database - Tinker

1. One to One relationship

   add new field user_id to posts table

   ```php
       public function up()
       {
           Schema::create('posts', function (Blueprint $table) {
               $table->increments('id');
               $table->integer('user_id')->ungsigned();
               $table->string('title');
               $table->string('content');
               $table->timestamps();
           });
       }
   
   ```

   refresh database

    ```cmd
 php artisan migrate:refresh
    ```
   
    add some data to table user and table post

    users table

    ```sql
 name,email,password,created_at,updated_at
    ```
   
    post table

    ```sql
 title,content,user_id=1created_at,updated_at,is_admin,
    ```
   
    routes.php

    ```php
 Route::get('/user/{id}/post',function($id){
        // show one record
        return User::find($id)->post;
        // show one field
        return User::find($id)->post->content;
    });
    ```
   
    add function post to User.php

    ```php
 <?php
   
    namespace App;

    use Illuminate\Foundation\Auth\User as Authenticatable;

    class User extends Authenticatable
 {
        /**
         * The attributes that are mass assignable.
         *
         * @var array
         */
        protected $fillable = [
            'name', 'email', 'password',
        ];
   
        /**
      * The attributes that should be hidden for arrays.
         *
         * @var array
         */
        protected $hidden = [
            'password', 'remember_token',
        ];
        public function post(){
            return $this->hasOne('App\Post');
        }
    }
    ```

2. The inverse relation

   routes.php

   ```php
   Route::get('/post/{id}/user',function($id){
       return Post::find($id)->user->name;
   });
   ```

   add the following to Post.php

   ```
       public function user(){
           return $this->belongsTo('App\User');
       }
   ```

   http://cms.test:3000/post/$id/user

   $id equals to posts table which user_id equals to table user which user_id is same

3. One to many relationship

   ```
   Route::get('/posts',function(){
       $user = User::find(1);
       foreach($user->posts as $post){
           echo $post->title . "<br>";
       }
   });
   ```

   

   

4. Many to many relations part 1

   Create new model Role and new table role_user

   ```cmd
   php artisan make:model Role -m
   php artisan make:migration create_users_roles_table --create=role_user
   php artisan migrate
   ```

   add one field name to role table on file 

   2020_03_19_235659_create_roles_table.php

   ```
       public function up()
       {
           Schema::create('roles', function (Blueprint $table) {
               $table->increments('id');
               $talbe->string('name');
               $table->timestamps();
           });
       }
   ```

   

   add two field(user_id,role_id) to role_user table on file 2020_03_20_000015_create_users_roles_table.php

   ```php
   Schema::create('role_user', function (Blueprint $table) {
               $table->increments('id');
               $table->integer('user_id');
               $table->integer('role_id');
               $table->timestamps();
           });
   ```

5. Many to many relations part 2

   add new record to users,roles,users_roles table (setting name and email field)

   ```sql
   users
   two records
   required field name email 
   id:1,2
   
   roles
   two records
   name:adminstrator,subscriber
   id:1,2
   
   users_roles
   two records
   user_id,role_id:1,1;2,2
   id:1,2
   ```

   add new public function to User.php

   ```php
       public function roles(){
           return $this->belongsToMany('App\Role');
       }
   ```

   add new url to routes.php

   ```php
   Route::get('/user/{id}/role',function($id){
       // example 1
       $user = User::find($id);
       foreach( $user->roles as $role ){
           echo $role->name;
       }
       // example 2
       $user = User::find($id)->roles()->orderBy('id','desc')->get();
       return $user;
   });
   ```

   

6. Querying intermediate table

7. Has many through relation part 1

8. Has many through relation part 2

9. Polymorphic relation the inverse

10. Polymorphic relation many to many part 1

11. Polymorphic relation many to many part 2

12. Polymorphic relation many to many - retrieving

13. Polymorphic relation may to many - retrieving owner

### Section13:Laravel Fundamentals - Database - One to One Relationship CRUD

### Section14:Laravel Fundamentals - Database - Eloquent One to Many Relationship CRUD

### Section15:Laravel Fundamentals - Database - Eloquent Many to Many Relationship CRUD

