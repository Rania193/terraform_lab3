#!/bin/bash
apt-get update
apt-get -y install apache2
systemctl start apache2
systemctl enable apache2
echo "Hey There! This is Apache" > /var/www/html/index.html