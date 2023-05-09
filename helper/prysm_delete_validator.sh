#!/bin/bash

source functions.sh

sudo docker stop delete_valdator && sudo docker container prune -f  > /dev/null 2>&1
echo "We will have to stop the validator coontainer first..."
sleep 1
sudo docker stop validator && sudo docker container prune -f  > /dev/null 2>&1
echo "Done. proceeding to Account-Deletion.."
echo ""
read -e -p "Please enter your installation folder (default: /blockchain): " INSTALL_PATH

# Set the default installation path if the user didn't enter a value
if [ -z "$ISNTALL_PATH" ]; then
    INSTALL_PATH="/blockchain"
fi

if [ -f "${INSTALL_PATH}/wallet/direct/accounts/all-accounts.keystore.json" ]; then
        sudo chmod -R 0600 "${INSTALL_PATH}/wallet/direct/accounts/all-accounts.keystore.json"
    fi
    
sudo -u prysm docker run -it \
--name="delete_valdator" \
-v "${INSTALL_PATH}/wallet":/wallet \
registry.gitlab.com/pulsechaincom/prysm-pulse/validator:latest \
accounts delete --"${PRYSM_NETWORK_FLAG}" \
--wallet-dir=/wallet --wallet-password-file=/wallet/pw.txt

echo "Now restarting the Validator Container..."
${INSTALL_PATH}/start_validator.sh > /dev/null 2>&1
sudo docker stop delete_validator && sudo docker container prune -f > /dev/null 2>&1
echo "Done..."
echo ""
read -p "Press enter to continue..."
