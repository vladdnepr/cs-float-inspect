#!/bin/bash

if [ ! -d /config/steam_data ]; then
    mkdir /config/steam_data
fi

rm -f /config/config.js
cp /usr/src/csgofloat/config.js.prototype /config/config.js

sed -i -r "s/DATABASE_NAME/${DATABASE_NAME}/g" /config/config.js
sed -i -r "s/DATABASE_USER/${DATABASE_USER}/g" /config/config.js
sed -i -r "s/DATABASE_PASSWORD/${DATABASE_PASSWORD}/g" /config/config.js
sed -i -r "s/DATABASE_HOST/${DATABASE_HOST}/g" /config/config.js
sed -i -r "s/DATABASE_PORT/${DATABASE_PORT}/g" /config/config.js
STEAM_PROXY_ESCAPED=`echo $STEAM_PROXY | sed 's/\//\\\\\//g'`
sed -i -r "s/STEAM_PROXY/${STEAM_PROXY_ESCAPED}/g" /config/config.js

sed -e "s/}, 5000);/}, 30000);/" /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js > /tmp/09.js && cat /tmp/09.js > /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js
sed -e "s/Protos\.CMsgClientHello, {}/Protos\.CMsgClientHello, {version: 2000000}/" /usr/src/csgofloat/node_modules/globaloffensive/index.js > /tmp/cs.js && cat /tmp/cs.js > /usr/src/csgofloat/node_modules/globaloffensive/index.js
sed -e "s/throw new Error('Already logged on, cannot log on again')/throw new Error('Already logged on, cannot log on again for ' + this.accountInfo.name)/" /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js > /tmp/09.js && cat /tmp/09.js > /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js
sed -e "s/logOn(details) {/logOn(details)  { if (this.steamID) {console.trace(this.accountInfo.name)}/" /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js > /tmp/09.js && cat /tmp/09.js > /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js
sed -e "s/this._logonMsgTimeout =/console.trace('_logonMsgTimeout ' + this._name); this._logonMsgTimeout  =/" /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js > /tmp/09.js && cat /tmp/09.js > /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js
sed -e "s/clearTimeout(this._logonMsgTimeout);/console.trace('clear _logonMsgTimeout ' + this._name); clearTimeout( this._logonMsgTimeout);/" /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js > /tmp/09.js && cat /tmp/09.js > /usr/src/csgofloat/node_modules/steam-user/components/09-logon.js
sed -e "s/bindEventHandlers() {/bindEventHandlers()  { this.steamClient.on('debug', (err, r) => {winston.debug(this.username + ': ' + err);});/" /usr/src/csgofloat/lib/bot.js > /tmp/bot.js && cat /tmp/bot.js > /usr/src/csgofloat/lib/bot.js
sed -e "s/let refreshToken = this.getSavedRefreshToken();/let refreshToken = this.getSavedRefreshToken(); this.steamClient._name = this.username;/" /usr/src/csgofloat/lib/bot.js > /tmp/bot.js && cat /tmp/bot.js > /usr/src/csgofloat/lib/bot.js

echo "Docker: starting"

NODE_OPTIONS=--max-old-space-size=16384 node --trace-uncaught --trace-warnings --report-on-fatalerror --report-uncaught-exception --report-directory=/config/steam_data index.js -c /config/config.js -s /config/steam_data

echo "Docker: exit with code $?"