# npm

## Install
```
apt list --installed nodejs*
apt list --installed npm
sudo apt-get install nodejs
sudo apt-get install npm
node -v
npm -v
```

## Update
```
# option 1
sudo npm install npm -g
sudo npm install npm@latest -g
# option 2
sudo npm update npm -g
```

## nvm
```
command -v nvm
source ~/.bashrc
nvm ls-remote

## install
nvm install node # "node" is an alias for the latest version
nvm install 14.7.0 # or 16.3.0, 12.22.1, etc

## use
### in other new shell
nvm use node
nvm use v16.13.1

## run
nvm run node --version

node -v
npm -v
```
