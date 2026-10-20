# npm

## Variables
```
NODE_OPTIONS="--use-system-ca"
NODE_EXTRA_CA_CERTS="/etc/ssl/certs/ca-bundle.crt"
```

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

## Install
```
# local install
npm install
```

## CI
```
# clean, repeatable install
npm ci
```

## Start
```
npm start # alias for npm run start
```

## Run
```
npm run <package-json.scripts.name>
npm run start
# Angular CLI
npm run ng -- version
npm run ng -- build
npm run ng -- serve [--poll=2000]
```

## npx
```
npx ng version
npx ng build
npx ng serve
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
