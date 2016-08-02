var payoutEvent = qualityPay.LogBoxDisturbed();
payoutEvent.watch(function(error, result){
    if (!error){
      console.log("*******************************************************");
      console.log("ID:" + result.args.payee + " paid out: " + result.args.amount);
      console.log("*******************************************************");
    }
    else {
      console.log("oops something went wrong...")
    }
});

var buyEvent = qualityPay.LogBoxFixed();
buyEvent.watch(function(error, result){
    if (!error){
      console.log("*******************************************************************************");
      console.log("ID:" + result.args.buyer + " bought: " + result.args.amount + " wei");
      console.log("*********************************************************************************");
    }
    else {
      console.log("oops something went wrong...");
    }
});