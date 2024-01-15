 #!/bin/bash
 # ===========================SettingUp Envirnment for Application============================================

# Updating the bash
cd /home/ubuntu 

sudo apt update -y
sudo dpkg --configure -a
sudo apt upgrade -y

sudo apt-get install gnupg curl

curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg  --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update -y 


sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

#locating the configuration file 
conf_file="/etc/mongod.conf" 
#replacing 
DATABASE_PASSWORD=$(aws secretsmanager get-secret-value --secret-id MongoDBPass --query 'SecretString' --output text | jq -r . | grep -o '"password": "[^"]*' | awk -F'"' '{print $4}')

sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' "$conf_file"

#restarting
sudo systemctl restart mongod