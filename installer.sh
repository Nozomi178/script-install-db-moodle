#!/bin/bash

set -e

clear
echo "========================================="
echo "        Moodle Stack Installer          "
echo "              Debian 12                 "
echo "========================================="
echo ""
echo "PERINGATAN:"
echo "Script ini hanya berjalan di Cloud VPS."
echo "Tidak direkomendasikan untuk shared hosting,"
echo "PC lokal, atau server di belakang NAT tanpa IP publik."
echo ""
echo "Kamu mau install yang mana?"
echo "1) Server Database (MariaDB)"
echo "2) Server Moodle"
echo ""
read -p "Pilih (1/2): " OPTION

############################################
# OPTION 1 - DATABASE SERVER
############################################
if [ "$OPTION" = "1" ]; then

    echo ""
    echo "[INFO] Installing MariaDB Server..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install mariadb-server -y

    sudo sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
    sudo systemctl restart mariadb

    echo ""
    echo "[INFO] Secure MariaDB Configuration"

    read -s -p "Set root MariaDB password: " ROOT_PASS
    echo ""
    read -s -p "Confirm root password: " ROOT_PASS_CONFIRM
    echo ""

    if [ "$ROOT_PASS" != "$ROOT_PASS_CONFIRM" ]; then
        echo "Password tidak sama!"
        exit 1
    fi

    sudo mariadb <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_PASS';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host!='localhost';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
EOF

    echo ""
    echo "[INFO] Konfigurasi Database Moodle"

    read -p "Nama database: " DB_NAME
    read -p "Username database: " DB_USER
    read -p "IP server moodlenya: " DB_HOST
    read -s -p "Password database: " DB_PASS
    echo ""
    read -s -p "Confirm password: " DB_PASS_CONFIRM
    echo ""

    if [ "$DB_PASS" != "$DB_PASS_CONFIRM" ]; then
        echo "Password tidak sama!"
        exit 1
    fi

    sudo mariadb -u root -p"$ROOT_PASS" <<EOF
CREATE DATABASE \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'$DB_HOST';
FLUSH PRIVILEGES;
EOF

    echo ""
    echo "[DONE] Database Server selesai dikonfigurasi."
fi


############################################
# OPTION 2 - MOODLE SERVER
############################################
if [ "$OPTION" = "2" ]; then

    echo ""
    echo "[INFO] Installing Moodle Server..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install apache2 php php-common php-mysqli php-xml php-gd php-curl php-zip php-intl php-mbstring php-soap php-xmlrpc php-bcmath curl wget tar -y

    cd /var/www/html
    sudo wget https://download.moodle.org/download.php/direct/stable403/moodle-latest-403.tgz
    sudo tar -zxvf moodle-latest-403.tgz

    sudo mkdir -p /var/www/moodledata

    sudo chown -R www-data:www-data /var/www/html/moodle
    sudo chown -R www-data:www-data /var/www/moodledata

    sudo chmod -R 755 /var/www/html/moodle
    sudo chmod -R 770 /var/www/moodledata

    ############################################
    # DETEKSI VERSI PHP OTOMATIS
    ############################################
    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")

    if [ -z "$PHP_VERSION" ]; then
        echo "PHP tidak terdeteksi!"
        exit 1
    fi

    PHP_INI="/etc/php/$PHP_VERSION/apache2/php.ini"

    if [ ! -f "$PHP_INI" ]; then
        echo "File php.ini tidak ditemukan di $PHP_INI"
        exit 1
    fi

    sudo sed -i "s/^;max_input_vars = 1000/max_input_vars = 10000/" "$PHP_INI"
    sudo sed -i "s/^max_input_vars = .*/max_input_vars = 10000/" "$PHP_INI"

    sudo systemctl restart apache2

    SERVER_IP=$(curl -s ip.me)

    echo ""
    echo "[OK] Akses Moodle lewat:"
    echo "http://$SERVER_IP/moodle/"
fi


############################################
# INVALID OPTION
############################################
if [[ "$OPTION" != "1" && "$OPTION" != "2" ]]; then
    echo "[ERROR] Pilihan tidak valid."
fi
