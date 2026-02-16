#!/bin/bash

echo "====================================="
echo "   Moodle Database Auto Installer"
echo "====================================="
echo ""

# ==============================
# INPUT SECTION (INTERACTIVE)
# ==============================

read -p "Enter Database Name [moodle]: " DB_NAME
DB_NAME=${DB_NAME:-moodle}

read -p "Enter Database User [moodleuser]: " DB_USER
DB_USER=${DB_USER:-moodleuser}

read -s -p "Enter Database Password: " DB_PASS
echo ""

read -p "Enter Moodle Server IP: " MOODLE_SERVER_IP

if [[ -z "$DB_PASS" || -z "$MOODLE_SERVER_IP" ]]; then
    echo "Password dan Moodle Server IP tidak boleh kosong!"
    exit 1
fi

# ==============================
# UPDATE SYSTEM
# ==============================

echo "Updating system..."
apt update && apt upgrade -y

# ==============================
# INSTALL MARIADB
# ==============================

echo "Installing MariaDB..."
apt install mariadb-server -y

# ==============================
# CONFIGURE BIND ADDRESS
# ==============================

echo "Configuring MariaDB bind address..."
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

systemctl restart mariadb

# ==============================
# BASIC SECURE CLEANUP
# ==============================

echo "Applying basic security cleanup..."

mariadb -e "DELETE FROM mysql.user WHERE User='';"
mariadb -e "DROP DATABASE IF EXISTS test;"
mariadb -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mariadb -e "FLUSH PRIVILEGES;"

# ==============================
# CREATE DATABASE & USER
# ==============================

echo "Creating database and user..."

mariadb <<EOF
CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '${DB_USER}'@'${MOODLE_SERVER_IP}' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${MOODLE_SERVER_IP}';
FLUSH PRIVILEGES;
EOF

echo ""
echo "====================================="
echo " INSTALLATION COMPLETE"
echo "====================================="
echo "Database Name : $DB_NAME"
echo "Database User : $DB_USER"
echo "Allowed IP    : $MOODLE_SERVER_IP"
echo "====================================="
