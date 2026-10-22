# npm

## Variables
```
NODE_OPTIONS="--use-system-ca"
NODE_EXTRA_CA_CERTS="/etc/ssl/certs/ca-bundle.crt"
NPM_CONFIG_REGISTRY=https://nexus.subdomain.com/repository/npm-public/
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

## Config
```
npm config list
npm config get userconfig # $HOME/.npmrc
npm config set registry=https://nexus.subdomain.com/repository/npm-public/ --location=user
npm config get registry
```

## Update
```
# install/update npm
# option 1
sudo npm install npm -g
sudo npm install npm@latest -g
# option 2
sudo npm update npm -g

# update packages
npm update [<name>] --progress=true --loglevel=verbose
```

## Install
```
# local install, updates package-lock.json
npm install
npm install [@<group>/<name>[@^1.0.0]] [--replace-registry-host=always|npmjs(default)|<reg-hostname> --registry=https://nexus.subdomain.com/repository/npm-public/]
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
npx ng update
npx ng lint
npx ng test --no-watch
npx ng build [--configuration production]
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
