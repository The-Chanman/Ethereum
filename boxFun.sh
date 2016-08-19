#!/bin/bash

#############################################################################################
## NOTE: You'll have to edit the "from" value to an unlocked account on your node and the  ##
## "to" should point at the contract address...if you didnt modify the contract            ##
## the data field should still work fine as is                                             ##
##                                                                                         ##
## be sure to chmod 755 this script before attempting to run                               ##
## Example usage:                                                                          ##
##                 ./gunShell.sh shot                                                      ##
#############################################################################################

echo $1
if [ $1 == "disturbedlight" ]; then
  #statements
  echo "BOX DISTURBED BY LIGHT"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x0783d75bb148c06be4ec02ec36d8bb01448dfb3f",  "gas": "0x343c00", "data":"0xf754c1d3000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000056c69676874000000000000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

elif [ $1 == "fixedlight" ]; then
  #statements
  echo "BOX FIXED FROM LIGHT"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x0783d75bb148c06be4ec02ec36d8bb01448dfb3f",  "gas": "0x343c00", "data":"0x1dd3cd67000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000056c69676874000000000000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

# elif [ $1 == "disturbedvibration" ]; then
#   #statements
#   echo "BOX DISTURBED BY VIBRATION"
#   curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x0783d75bb148c06be4ec02ec36d8bb01448dfb3f",  "gas": "0x343c00", "data":"0xf754c1d300000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000009766962726174696f6e0000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

# elif [ $1 == "fixedvibration" ]; then
#   #statements
#   echo "BOX FIXED FROM VIBRATION"
#   curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x0783d75bb148c06be4ec02ec36d8bb01448dfb3f",  "gas": "0x343c00", "data":"0x1dd3cd6700000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000009766962726174696f6e0000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

fi