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
if [ $1 == "disturbed light" ]; then
  #statements
  echo "BOX DISTURBED"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x2842bace040a5647616046655f00b820c14dddfd",  "gas": "0x343c00", "data":"0xf754c1d3000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000056c69676874000000000000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

elif [ $1 == "fixed light" ]; then
  #statements
  echo "BOX FIXED"
  curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0x0171d54c207ccf841352f3ea6c1f07750ee8cdec","to": "0x2842bace040a5647616046655f00b820c14dddfd",  "gas": "0x343c00", "data":"0x1dd3cd67000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000056c69676874000000000000000000000000000000000000000000000000000000"}],"id":8}' http://localhost:8545

fi