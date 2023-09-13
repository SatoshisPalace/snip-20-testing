#! /bin/bash
echo "----Cleaning Build----"
# make clean
echo "----------------------"
echo "----Building----"
make build-mainnet
echo "----------------"
echo "----Setting Up Secret CLI----"
echo "Using Wallet Name: $WALLET_NAME"
echo "Using Wallet Address: $WALLET_ADDRESS"
echo "Using Secret Node: $SECRET_NODE"
echo "Using Chain ID: $CHAIN_ID"
secretcli config node $SECRET_NODE
secretcli config chain-id $CHAIN_ID
secretcli config output json
echo "--------Filling Wallet--------"
curl "http://localhost:5000/faucet?address=$WALLET_ADDRESS"
sleep 5
printf "\n---------Wallet Filled---------\n"
echo "------Deploying Contract------"
secretcli tx compute store contract.wasm.gz --gas 5000000 --from $WALLET_NAME --chain-id $CHAIN_ID -y
sleep 5
echo "--------------------------"
echo "----Instantiating Contract----"
secretcli tx compute instantiate $DEPLOYMENT_NUM '{"name":"USDC","symbol":"USDC","decimals":18,"prng_seed":"VGhpcyBpcyBhIGJhc2UgNjQgZW5jb2RlZCBzdHJpbmcK","config":{"public_total_supply":true,"enable_deposit":true,"enable_redeem":true,"enable_mint":true,"enable_burn":true}}' --label snip20Contract$DEPLOYMENT_NUM --from $WALLET_NAME -y
sleep 5
echo "------------------------------"
secretcli query compute list-contract-by-code $DEPLOYMENT_NUM
echo "Please set your contract address: export SNIP_20_CONTRACT_ADDRESS="
echo "------------------------------"
echo "Code hash:"
secretcli query compute contract-hash-by-id $DEPLOYMENT_NUM
echo "Please set your contract code hash: export SNIP_20_CODE_HASH="
echo "------------------------------"
