function qualityPayListener(myContract){
  var onTrip = false;
  var disturbed = false;
  var startTime;
  var disturbedDuration = 0;
  var lastDisturbed;
  var bounty;
  var leeway = 60;

  console.log("Starting contract Listeners");

  var StartingTrip = qualityPay.LogStartTrip();
  StartingTrip.watch(function(error, result){
      if (!error){
        console.log("*********************************************************************************");
        console.log("Box " + result.args.boxID + " is starting trip with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +"!");
        console.log("*********************************************************************************");
        onTrip = true;
        startTime = result.args.timestamp;
        bounty = result.args.bounty;
      }
      else {
        console.log("oops something went wrong...");
      }
  });

  var BoxDisturbed = qualityPay.LogBoxDisturbed();
  BoxDisturbed.watch(function(error, result){
      if (!error && onTrip){
        console.log("*********************************************************************************");
        console.log("Box " + result.args.boxID + " with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +" has been disturbed with " + result.args.disturbType + "!");
        console.log("*********************************************************************************");
        // addToEventTable(result.args.boxID, result.args.courier, result.args.disturbType, "Start", result.args.timestamp);
        lastDisturbed = result.args.timestamp;
        disturbed = true;
      }
      else {
        console.log("oops something went wrong...");
      }
  });

  var BoxFixed = qualityPay.LogBoxFixed();
  BoxFixed.watch(function(error, result){
    console.log(error + " " + onTrip + " " + disturbed);
      if (!error){
        if (onTrip){
          if (disturbed){
            disturbedDuration += result.args.timestamp - lastDisturbed;
            console.log("*********************************************************************************");
            console.log("Box " + result.args.boxID + " with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +" has been fixed!");
            console.log("Box has been disturbed for a total of " + disturbedDuration + " seconds on this trip.");
            console.log("*********************************************************************************");
            disturbed = false;
            // addToEventTable(result.args.boxID, result.args.courier, result.args.disturbType, "Ended after " + secondsToMinutes(result.args.timestamp - lastDisturbed) + " minutes", result.args.timestamp);
          } else {
            console.log("Failed because disturbed == false");
          }
        } else {
          console.log("Failed because onTrip == false");
        }
      } else {
        console.log("oops something went wrong...");
        console.log(error + " IS BAD!!!!");
      }
  });

  var EndingTrip = qualityPay.LogEndTrip();
  EndingTrip.watch(function(error, result){
      if (!error && onTrip){
        var disturbedCost = disturbedDuration * 1000000000000000;
        var payout = bounty - disturbedCost;
        var bPayout = .1 * payout;
        var cPayout = .9 * payout;
        console.log("*********************************************************************************");
        console.log("Box " + result.args.boxID + " is ending trip with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +"!");
        console.log("The Box was disturbed for " + disturbedDuration + " seconds out of a trip " + (result.args.timestamp - startTime) + " seconds long.");
        console.log("The original services payout is " + web3.fromWei(bounty) + " - " + web3.fromWei(disturbedCost) + " for the box disturbances for a total of " + web3.fromWei(payout));
        console.log("10% goes to the box to cover transaction fees, refunds, maintenance. 90% goes to the courier.");
        console.log("So " + web3.fromWei(bPayout) + " goes to the box to cover transaction fees, refunds, maintenance. " + web3.fromWei(cPayout) + " goes to the courier.");
        console.log("*********************************************************************************");
        // payout to the courier 
        // estimatedGasCost = eth.estimateGas({from:eth.coinbase,to:qualitypay.address,data:qualitypay.payoutBox.getData(payout,eth.accounts[1])});
        qualityPay.payoutBox(bPayout, cPayout, result.args.boxID, disturbedCost, {from: eth.coinbase, gas: 3423232});

        disturbedDuration = 0;
        onTrip = false;
      }
      else {
        console.log("oops something went wrong...");
      }
  });
}