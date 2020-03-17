#!/usr/bin/env bash

WEB_ROOT=~/web-root

function psql_alias() { PGPASSWORD=postgres psql -h db.demo.nicholaslaw.com.au -p 5432 -U postgres "$@"; }

echo "==> Adding postgres apt repository..."
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
apt-get update -y

echo "==> Installing python and psql..."
apt-get install -y python postgresql-client-11
echo "==> psql installed: $(psql --version)"

echo "==> Checking DB connection..."
DB_CONNECTION=$(psql_alias -tAc "SELECT 1")
echo "DB_CONNECTION: $${DB_CONNECTION}"

echo "==> Creating root web directory..."
mkdir -p $${WEB_ROOT}
cd $${WEB_ROOT}

echo "==> Creating index.html..."
echo "<!DOCTYPE html>"          >> index.html
echo "<html lang=\"en\">"       >> index.html
echo "<head>"                   >> index.html
echo "    <title>Demo</title>"  >> index.html
echo "</head>"                  >> index.html
echo "<body>"                   >> index.html
echo "    <p>Hello :)</p>"      >> index.html
echo "</body>"                  >> index.html
echo "</html>"                  >> index.html

echo "==> Starting web server in the background..."
sudo python -m SimpleHTTPServer 80 &
