#!/bin/bash

echo "====================================="
echo "      Moodle Web Auto Installer"
echo "====================================="
echo ""

# ==============================
# INPUT
# ==============================

read -p "Masukkan versi Moodle (contoh: 403 untuk 4.3.x) [403]: " MOODLE_VER
MOODLE_VER=${MOODLE_VER:-403}

read -p "Masukkan IP Server Moodle (untuk info akses): " MOODLE_IP

if [[ -z "$MOODLE_IP" ]]; then
    echo "IP tidak boleh kosong!"
    exit 1
fi

# ==============================
# UPDATE SYSTEM
# ==============================

echo "Updating system..."
apt update && apt upgrade -y

# ==============================
# INSTALL APACHE & PHP
# ==============================

echo "Installing Apache & PHP..."
apt install apache2 php php-common php-mysqli php-xml php-gd php-curl php-zip php-intl php-mbstring php-soap php-xmlrpc php-bcmath -y

# ==============================
# DOWNLOAD MOODLE
# ==============================

cd /var/www/html

echo "Downloading Moodle..."
wget https://download.moodle.org/download.php/direct/stable${MOODLE_VER}/moodle-latest-${MOODLE_VER}.tgz -O moodle.tgz

echo "Extracting Moodle..."
tar -zxvf moodle.tgz
rm moodle.tgz

# ==============================
# CREATE MOODLEDATA
# ==============================

echo "Creating moodledata directory..."
mkdir -p /var/www/moodledata

# ==============================
# SET PERMISSIONS
# ==============================

echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/moodle
chown -R www-data:www-data /var/www/moodledata

chmod -R 755 /var/www/html/moodle
chmod -R 770 /var/www/moodledata

# ==============================
# AUTO CONFIG PHP
# ==============================

PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
PHP_INI="/etc/php/${PHP_VERSION}/apache2/php.ini"

echo "Configuring PHP (${PHP_VERSION})..."

sed -i "s/;max_input_vars = 1000/max_input_vars = 10000/" $PHP_INI
sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 128M/" $PHP_INI
sed -i "s/^post_max_size = .*/post_max_size = 128M/" $PHP_INI
sed -i "s/^memory_limit = .*/memory_limit = 256M/" $PHP_INI

# ==============================
# ENABLE APACHE MOD REWRITE
# ==============================

a2enmod rewrite
systemctl restart apache2

echo ""
echo "====================================="
echo " INSTALLATION COMPLETE"
echo "====================================="
echo "Akses Moodle di:"
echo "http://${MOODLE_IP}/moodle/"
echo "====================================="
