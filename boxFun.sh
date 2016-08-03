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
if [ $1 == "disturbed" ]; then
  #statements
  echo "BOX DISTURBED"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0xf73e48ec5261942464421fa2a66a17e3ae86bcde",  "gas": "0x76c2", "data":"0xeea23c4f0000000000000000000000000171d54c207ccf841352f3ea6c1f07750ee8cdec"}],"id":8}' http://localhost:8545

elif [ $1 == "fixed" ]; then
  #statements
  echo "BOX FIXED"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0xf73e48ec5261942464421fa2a66a17e3ae86bcde",  "gas": "0x70fc", "data":"0xd19eaac6"}],"id":8}' http://localhost:3000

fi