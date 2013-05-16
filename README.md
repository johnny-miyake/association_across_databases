```mysql
mysql> create table user_actions (id int not null primary key auto_increment, user_id int not null, action varchar(1024));
```

```ruby
[1] pry(main)> User.create name: "Johnny"
   (0.1ms)  begin transaction
  SQL (5.6ms)  INSERT INTO "users" ("created_at", "name", "updated_at") VALUES (?, ?, ?)  [["created_at", Thu, 16 May 2013 13:24:41 UTC +00:00], ["name", "Johnny"], ["updated_at", Thu, 16 May 2013 13:24:41 UTC +00:00]]
   (1.1ms)  commit transaction
=> #<User id: 1, name: "Johnny", created_at: "2013-05-16 13:24:41", updated_at: "2013-05-16 13:24:41">

[2] pry(main)> User.last.user_action.create action: "user's action #1"
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
   (0.2ms)  BEGIN
  SQL (0.4ms)  INSERT INTO `user_actions` (`action`, `user_id`) VALUES ('user\'s action #1', 1)
   (0.8ms)  COMMIT
=> #<UserAction id: 1, user_id: 1, action: "user's action #1">

[3] pry(main)> User.last.user_action.create action: "user's action #2"
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
   (0.2ms)  BEGIN
  SQL (0.3ms)  INSERT INTO `user_actions` (`action`, `user_id`) VALUES ('user\'s action #2', 1)
   (0.8ms)  COMMIT
=> #<UserAction id: 2, user_id: 1, action: "user's action #2">

[4] pry(main)> User.last.user_action
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" DESC LIMIT 1
  UserAction Load (0.4ms)  SELECT `user_actions`.* FROM `user_actions` WHERE `user_actions`.`user_id` = 1
=> [#<UserAction id: 1, user_id: 1, action: "user's action #1">,
 #<UserAction id: 2, user_id: 1, action: "user's action #2">]
```
hoge
