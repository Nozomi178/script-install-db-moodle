# Script Install Moodle dan Database

## Cara installnya ada di bawah ▼

### 1. Di Server Databasenya

```bash
sudo apt install git -y #karena lu baru fresh install jadi mungkin gak ada git di situ
sudo wget https://github.com/Nozomi178/script-install-db-moodle/blob/main/install-moodle-db.sh
sudo chmod +x install-moodle-db.sh
sudo ./install-moodle-db.sh
```

### 2. Di Server Moodlenya

```bash
sudo apt install git -y # sama aja kok alasanya kaya di atas
sudo wget https://github.com/Nozomi178/script-install-db-moodle/blob/main/install-moodle-web.sh
sudo chmod +x install-moodle-db.sh
sudo ./install-moodle-db.sh
```
