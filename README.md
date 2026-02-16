# Script Install Moodle dan Database

## Cara install ▼

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


![tohka](https://github.com/user-attachments/assets/aed41fd6-0966-438d-a871-69e26d4723ea)

