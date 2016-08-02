var balances = function() {
    decimalPlaces=2;
  console.log("eth.accounts[0]: " + web3.fromWei(eth.getBalance(eth.accounts[0])).toFixed(decimalPlaces) );
  console.log("eth.accounts[1]: " + web3.fromWei(eth.getBalance(eth.accounts[1])).toFixed(decimalPlaces) );
  console.log("eth.accounts[2]: " + web3.fromWei(eth.getBalance(eth.accounts[2])).toFixed(decimalPlaces) );
  console.log("eth.accounts[3]: " + web3.fromWei(eth.getBalance(eth.accounts[3])).toFixed(decimalPlaces) );
  // console.log("eth.accounts[4]: " + web3.fromWei(eth.getBalance(eth.accounts[4])).toFixed(decimalPlaces) );
  // console.log("eth.accounts[5]: " + web3.fromWei(eth.getBalance(eth.accounts[5])).toFixed(decimalPlaces) );
  // console.log("eth.accounts[6]: " + web3.fromWei(eth.getBalance(eth.accounts[6])).toFixed(decimalPlaces) );
  // console.log("eth.accounts[7]: " + web3.fromWei(eth.getBalance(eth.accounts[7])).toFixed(decimalPlaces) );
}

// var unlock = function() {
//   personal.unlockAccount(eth.accounts[0],"joe123",900000);
//   personal.unlockAccount(eth.accounts[1],"joe123",900000);
//   personal.unlockAccount(eth.accounts[2],"Liberty",900000);
//   personal.unlockAccount(eth.accounts[3],"Progressive",900000)
//   personal.unlockAccount(eth.accounts[4],"crash",900000);
//   personal.unlockAccount(eth.accounts[5],"joe123",900000);
//   personal.unlockAccount(eth.accounts[6],"joe123",900000);
//   personal.unlockAccount(eth.accounts[7],"joe123",900000);
// }

function distributeEth(address){
  eth.sendTransaction({from:eth.coinbase, to:address, value:web3.toWei(100)})
}


function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp * 1000);
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}

function resetAccountBalances() {
    leftover = 5000420000000000000;
    for (i = 2; i < web3.eth.accounts.length; i++) {
        fromAddress = web3.eth.accounts[i];
        fromBalance = web3.eth.getBalance(fromAddress);
        if (fromBalance > leftover){
            console.log(i);
            web3.eth.sendTransaction({from:fromAddress, to:eth.coinbase, value:(fromBalance-leftover)});
        }
    }
}