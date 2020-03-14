#!/usr/bin/env bash

WEB_ROOT=~/web-root

echo "==> Debugging NAT gateway :("
ping -c 5 google.com

echo "==> Installing python..."
apt-get install -y python

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

echo "==> Starting web server..."
sudo python -m SimpleHTTPServer 80 &
