#!/bin/bash
# ===========================SettingUp Envirnment for Application============================================

# Updating the bash
cd /home/ubuntu 
sudo apt update -y
sudo dpkg --configure -a
sudo apt upgrade -y

#Installing latest nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install 18.18.0
#installing git 
sudo apt install git

#downloading the code 
git clone https://github.com/hammadmalik956/DevOpsBackend.git
cd DevOpsBackend

sudo apt install awscli -y

DATABASE_PASSWORD=$(aws secretsmanager get-secret-value --secret-id MongoDBPass --query 'SecretString' --output text | grep -oP '"password"\s*:\s*"\K[^"]+')          
sed -i 's|i0klpTNHXz1aDYcX|${DATABASE_PASSWORD}|' config.env
npm install
          
echo "EC2Instance4PrivateIP is:  ${private_Ip} "  >> /tmp/debug.log
sed -i 's|mongodb://here:27017/VeetranMeet|mongodb+srv//hammad:${DATABASE_PASSWORD}@${private_Ip}:27017/VeetranMeet|' config.env
npm install pm2 -g 
pm2 start server.js 