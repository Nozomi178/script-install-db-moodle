# Script Install Moodle dan Database

## Cara install ▼

### 1. Di Server Databasenya

```bash
sudo apt update && apt upgrade -y
sudo apt install wget -y #karena lu baru fresh install jadi mungkin gak ada git di situ
sudo wget https://raw.githubusercontent.com/Nozomi178/script-install-db-moodle/main/install-moodle-db.sh
sudo chmod +x install-moodle-db.sh
sudo ./install-moodle-db.sh
```

### 2. Di Server Moodlenya

```bash
sudo apt update && apt upgrade -y
sudo apt install wget -y # sama aja kok alasanya kaya di atas
sudo wget https://github.com/Nozomi178/script-install-db-moodle/blob/main/install-moodle-web.sh
sudo chmod +x install-moodle-db.sh
sudo ./install-moodle-db.sh
```


<p align="center">
  <img src="https://github.com/user-attachments/assets/971cb24d-ddc8-418d-ad34-b20ae5dea00d" width="350">
</p>
