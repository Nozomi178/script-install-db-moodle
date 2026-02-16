# Script Install Moodle dan Database

## Cara install ▼

### 1. Di Server Databasenya

```bash
sudo apt update && apt upgrade -y
sudo wget https://raw.githubusercontent.com/Nozomi178/script-install-db-moodle/main/install-moodle-db.sh
sudo chmod +x install-moodle-db.sh
sudo ./install-moodle-db.sh
```

### 2. Di Server Moodlenya

```bash
sudo apt update && apt upgrade -y
sudo wget https://raw.githubusercontent.com/Nozomi178/script-install-db-moodle/refs/heads/main/install-moodle-web.sh
sudo chmod +x install-moodle-web.sh
sudo ./install-moodle-web.sh
```


<p align="center">
  <img src="https://github.com/user-attachments/assets/971cb24d-ddc8-418d-ad34-b20ae5dea00d" width="350">
  <br>
  This Installation Script was created by me and other contributors.
</p>

