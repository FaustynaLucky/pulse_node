#!/bin/bash

source functions.sh

sudo docker stop delete_valdator && sudo docker container prune -f 

echo "Deleting Prysm Validator Account"
echo ""
read -e -p "Please enter your installation folder (default: /blockchain): " INSTALL_PATH

# Set the default installation path if the user didn't enter a value
if [ -z "$ISNTALL_PATH" ]; then
    INSTALL_PATH="/blockchain"
fi

sudo -u prysm docker run -it \
--name="delete_valdator" \
-v "${INSTALL_PATH}/wallet":/wallet \
registry.gitlab.com/pulsechaincom/prysm-pulse/validator:latest \
accounts delete --"${PRYSM_NETWORK_FLAG}" \
--wallet-dir=/wallet --wallet-password-file=/wallet/pw.txt


sudo docker stop delete_validator && sudo docker container prune -f

echo "account(s) deleted"
echo ""
read -p "Press enter to continue..."
