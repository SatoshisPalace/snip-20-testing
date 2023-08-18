echo "----Setting Environment Variables----"
export WALLET_NAME=myWallet
export WALLET_ADDRESS=secret1nlfhwjhsx9hf6akmcep9p85w9k62vvzvaxemct
export CHAIN_ID=secretdev-1
export SECRET_NODE=http://localhost:26657

###### Do not edit beyond this point! ######
if [[ -z "${DEPLOYMENT_NUM}" ]]; then #DNE
  	export SNIP_20_DEPLOYMENT_NUM=1
else # EXISTS
  	export SNIP_20_DEPLOYMENT_NUM=$((DEPLOYMENT_NUM + 1)) 
fi
echo "------Environment Variables Set------"
