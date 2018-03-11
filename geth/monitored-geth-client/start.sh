#!/bin/sh
set -e
cd /root/eth-net-intelligence-api
# sed -ie "s/HOSTNAME_ENV/$(hostname)/g" app.json
sed -ie "s/HOSTNAME_ENV/$(hostname)-$(node -e "require('http').get('http://ip.taobao.com/service/getIpInfo.php?ip=myip',(res)=>{res.setEncoding('utf8');data='';res.on('data',(chunk)=>data+=chunk);res.on('end',()=>{console.log(JSON.parse(data).data.ip)})})")/g" app.json
sed -ie "s/WS_SERVER_ENV/$(echo $WS_SERVER|sed -e 's/[]\/$*.^|[]/\\&/g')/g" app.json
sed -ie "s/WS_SECRET_ENV/$(echo $WS_SECRET|sed -e 's/[]\/$*.^|[]/\\&/g')/g" app.json
/usr/local/bin/pm2 start ./app.json
sleep 3

/usr/bin/geth --datadir "/root/.ethereum" init /root/genesis.json

/usr/bin/geth --networkid=23333 --datadir "/root/.ethereum" \
--rpc --rpccorsdomain="*" --rpcaddr '0.0.0.0' --wsaddr '0.0.0.0' --rpcapi "admin,db,personal,eth,net,web3,miner,txpool" \
--bootnodes="$NODES"
