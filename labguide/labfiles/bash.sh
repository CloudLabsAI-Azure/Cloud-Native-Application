#Get the Username
export SUDOUSER=$1
export HOME=/home/$1
#Install Docker nodejs
sudo apt-get update && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get install curl python-software-properties -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y docker-ce nodejs mongodb-clients
#apt-get update && sudo apt install docker-ce npm mongodb-clients -y
#curl -sL#https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
chmod 777 nodesource_setup.sh

#apt-get install nodejs -y
apt-get upgrade -y
sudo usermod -aG docker $SUDOUSER


sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod a+x /usr/local/bin/docker-compose

sudo npm install -g @angular/cli

sudo npm install -g bower
sudo ln -s /usr/bin/nodejs /usr/bin/node



#Install Azure CLI 2.0

echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
     sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli

#Install Kubectl

cd /usr/local/bin
wget https://storage.googleapis.com/kubernetes-release/release/v1.9.2/bin/linux/amd64/kubectl
sudo chmod a+x ./kubectl
#Add ssh key pair
cd /home/$SUDOUSER/.ssh
wget https://experienceazure.blob.core.windows.net/templates/container-and-devops/files/id_rsa
wget https://experienceazure.blob.core.windows.net/templates/container-and-devops/files/id_rsa.pub
chmod 600 /home/$SUDOUSER/.ssh/id_rsa
chown -R $SUDOUSER:$SUDOUSER /home/$SUDOUSER/.ssh/id_rsa

sleep 180

#For fixing this issue https://blog.hostonnet.com/xfce-4-desktop-error-xfconfd-isnt-running
mv /home/admincontoso/.config /home/admincontoso/.config-old
mv /home/admincontoso/.cache /home/admincontoso/.cache-old
chmod 777 /home/admincontoso/.* -R
cd /home/admincontoso/
git clone https://github.com/CloudLabsAI-Azure/Cloud-Native-Application

cd ~/Cloud-Native-Application/labfiles/src/developer/content-init
docker network create contoso
docker container run --name mongo --net contoso -p 27017:27017 -d mongo:4.0

# Seed the mongo db
cd ~/Cloud-Native-Application/labfiles/src/developer/content-init
npm ci
nodejs server.js

echo "Build agent setup complete!"

#cd /home/$SUDOUSER/
#wget -O labguide.pdf https://experienceazure.blob.core.windows.net/guides/Hands-on-lab-step-by-step-Containers-and-DevOps-Modified-v2.pdf
#sudo chmod a+x labguide.pdf
#sleep 60
exit 0
