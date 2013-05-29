# association_across_databases
This is a small example project which handles two different DBs and the association of them.

This project supposes that there is an application DB (Sqlite3) and an external logging DB (MySQL) that is also used by other systems.

## Try it
You can try this project as below.

1. Edit `log_db_development` section in `config/database.ymls/database.yml.development` to adjust it to your MySQL

2. Create `config/database.yml` as a symbolic link
```sh
$ cp config/database.ymls/database.yml.development config/database.yml
```
3. Create database on Sqlite3
```sh
$ rake db:create
$ rake db:migrate
==  CreateUsers: migrating ====================================================
-- create_table(:users)
   -> 0.0015s
==  CreateUsers: migrated (0.0016s) ===========================================
```

4. Create database on MySQL
```sh
rake db:create RAILS_ENV=log_db_development
```

5. Create a table on MySQL
```mysql
mysql> use log_db_development;
mysql> create table user_actions (id int not null primary key auto_increment, user_id int not null, action varchar(128));
Query OK, 0 rows affected (0.01 sec)
```

6. Try creating, showing, confirming associations with `rails console`.
```ruby
$ rails console
 [1] pry(main)> u = User.create name: "Johnny"
    (0.1ms)  begin transaction
   SQL (5.6ms)  INSERT INTO "users" ("created_at", "name", "updated_at") VALUES (?, ?, ?)  [["created_at", Thu, 16 May 2013 13:24:41 UTC +00:00], ["name", "Johnny"], ["updated_at", Thu, 16 May 2013 13:24:41 UTC +00:00]]
    (1.1ms)  commit transaction
 => #<User id: 1, name: "Johnny", created_at: "2013-05-16 13:24:41", updated_at: "2013-05-16 13:24:41">
 
 [2] pry(main)> u.user_actions.create action: "user's action #1"
   User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
    (0.2ms)  BEGIN
   SQL (0.4ms)  INSERT INTO `user_actions` (`action`, `user_id`) VALUES ('user\'s action #1', 1)
    (0.8ms)  COMMIT
 => #<UserAction id: 1, user_id: 1, action: "user's action #1">
 
 [3] pry(main)> u.user_actions.create action: "user's action #2"
   User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
    (0.2ms)  BEGIN
   SQL (0.3ms)  INSERT INTO `user_actions` (`action`, `user_id`) VALUES ('user\'s action #2', 1)
    (0.8ms)  COMMIT
 => #<UserAction id: 2, user_id: 1, action: "user's action #2">
 
 [4] pry(main)> u.user_actions
   User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
   UserAction Load (0.4ms)  SELECT `user_actions`.* FROM `user_actions` WHERE `user_actions`.`user_id` = 1
 => [#<UserAction id: 1, user_id: 1, action: "user's action #1">,
  #<UserAction id: 2, user_id: 1, action: "user's action #2">]
```

## Description
This project includes two models. One is `User` model and is used for managing users. It corresponds to `users` table on the application DB (Sqlite3). The other model is `UserAction` model and is used for logging each user's action. It corresponds to `user_actions` table on the logging DB (MySQL). `User` associates with `UserAction` in `has_many` relationship. ActiveRecord can handle associations across different databases.

This project includes a migration file for `users` table on the application DB (Sqlite3), but doesn't include the migration file for `user_actions` table on logging DB (MySQL), because this project supposes the logging DB is also used by other systems and isn't managed by Rails.

In `app/models/user_action.rb #2`, `establish_connection :log_db` means  `UserAction` model corresponds to `user_action` table on the database which is specified on `log_db_development` section in `config/database.ymls/database.yml.development`.




