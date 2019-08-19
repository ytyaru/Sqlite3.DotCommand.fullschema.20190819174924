SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd "$SCRIPT_DIR"

echo "create table users(id primary key, name text, class text);
insert into users(name, class) values('Yamada','A');
insert into users(name, class) values('Suzuki','B');
insert into users(name, class) values('Tanaka','A');
" > create_0.sql

sqlite3 :memory: \
".read create_0.sql" \
".fullschema"

# .stats
sqlite3 :memory: \
".read create_0.sql" \
".stats on" \
".fullschema"

# dbstat
echo "create table users(id primary key, name text, class text);
CREATE VIRTUAL TABLE temp.stat USING dbstat(main);
insert into users(name, class) values('Yamada','A');
insert into users(name, class) values('Suzuki','B');
insert into users(name, class) values('Tanaka','A');
" > create_1.sql

# .stats on
sqlite3 :memory: \
".read create_1.sql" \
".stats on" \
".fullschema"

# .stats off
sqlite3 :memory: \
".read create_1.sql" \
".stats off" \
".fullschema"

# `main`スキーマ内にある`users`テーブルが使うページ数を取得する
sqlite3 :memory: \
".read create_1.sql" \
"SELECT count(*) FROM dbstat WHERE name='users';"

