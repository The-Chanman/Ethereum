var BoxDisturbed = qualityPay.LogBoxDisturbed();
BoxDisturbed.watch(function(error, result){
    if (!error){
      console.log("*******************************************************");
      console.log("ID:" + result.args.payee + " paid out: " + result.args.amount);
      console.log("*******************************************************");
    }
    else {
      console.log("oops something went wrong...")
    }
});

var BoxFixed = qualityPay.LogBoxFixed();
BoxFixed.watch(function(error, result){
    if (!error){
      console.log("*******************************************************************************");
      console.log("ID:" + result.args.buyer + " bought: " + result.args.amount + " wei");
      console.log("*********************************************************************************");
    }
    else {
      console.log("oops something went wrong...");
    }
});

var StartingTrip = qualityPay.LogStartTrip();
StartingTrip.watch(function(error, result){
    if (!error){
      console.log("*******************************************************************************");
      console.log("ID:" + result.args.buyer + " bought: " + result.args.amount + " wei");
      console.log("*********************************************************************************");
    }
    else {
      console.log("oops something went wrong...");
    }
});

var EndingTrip = qualityPay.LogEndTrip();
EndingTrip.watch(function(error, result){
    if (!error){
      console.log("*******************************************************************************");
      console.log("ID:" + result.args.buyer + " bought: " + result.args.amount + " wei");
      console.log("*********************************************************************************");
    }
    else {
      console.log("oops something went wrong...");
    }
});