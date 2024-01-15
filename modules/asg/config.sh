#!/bin/bash
# ===========================SettingUp Envirnment for Application============================================

# Updating the bash
sudo apt update
sudo apt upgrade

#Installing latest nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

nvm install 18.18.0
# ===========================Deploying Application============================================
#installing nginx 

sudo apt install nginx -y
#Getting the Ip of currect server
IP=$(curl -s ifconfig.me)

mkdir /var/www/$IP

sudo chmod 755 -R /var/www/$IP/
sudo chown -R ubuntu:www-data /var/www/$IP

#making the configuration file for nginx
sudo touch /etc/nginx/sites-available/$IP 
# Set the file path and content for the Nginx configuration
FILE_PATH="/etc/nginx/sites-available/$IP"
CONFIG_CONTENT=$(cat <<EOL
server {
    listen 80;
    listen [::]:80;
    root /var/www/$IP;
    index index.html;
    location /api/ {
        proxy_pass http://${private_Ip}:3001;
    }
}
EOL
)
# Create and write the Nginx configuration file
echo "$CONFIG_CONTENT" | sudo tee "$FILE_PATH" > /dev/null


#unlinking the default conf file 
sudo unlink /etc/nginx/sites-enabled/default
#linking the new file
sudo ln -s /etc/nginx/sites-available/$IP /etc/nginx/sites-enabled/ 
#restarting nginx
sudo systemctl restart nginx

#installing git 
sudo apt install git

#cloning build from git 
git clone https://github.com/hammadmalik956/DevOpsBuild.git

#moving build files to destination /var/www/$IP
sudo cp -r DevOpsBuild/* /var/www/$IP/

#removing the build files 
sudo rm -rf DevOpsBuild


