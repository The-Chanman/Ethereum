

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


function qualityPayListener(myContract){
  var onTrip = false;
  var disturbed = false;
  var startTime;
  var disturbedDuration = 0;
  var lastDisturbed;
  var bounty;

  console.log("Setting contract Listeners")

  var StartingTrip = qualityPay.LogStartTrip();
  StartingTrip.watch(function(error, result){
      if (!error){
        console.log("*********************************************************************************");
        console.log("Box " + result.args.boxID + "is starting trip with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +"!");
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
        console.log("Box " + result.args.boxID + "with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +" has been disturbed!");
        console.log("*********************************************************************************");
        lastDisturbed = result.args.timestamp;
        disturbed = false;
      }
      else {
        console.log("oops something went wrong...")
      }
  });

  var BoxFixed = qualityPay.LogBoxFixed();
  BoxFixed.watch(function(error, result){
      if (!error && onTrip && disturbed){
        disturbedDuration += result.args.timestamp - lastDisturbed;
        console.log("*********************************************************************************");
        console.log("Box " + result.args.boxID + "with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +" has been fixed!");
        console.log("Box has been disturbed for a total of " + disturbedDuration + "on this trip.");
        console.log("*********************************************************************************");
        disturbed = false;
      }
      else {
        console.log("oops something went wrong...");
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
        console.log("Box " + result.args.boxID + "is ending trip with courier " + result.args.courier + " at "+ timeConverter(result.args.timestamp) +"!");
        console.log("The Box was disturbed for " + disturbedDuration + " seconds out of a trip " + (result.args.timestamp - startTime) + "seconds long.");
        console.log("The original services payout is " + bounty + " - " + disturbedCost + " for the box disturbances for a total of " + payout);
        console.log("10% goes to the box to cover transaction fees, refunds, maintenance. 90% goes to the courier.");
        console.log("*********************************************************************************");
        // payout to the courier 

        // estimatedGasCost = eth.estimateGas({from:eth.coinbase,to:qualitypay.address,data:qualitypay.payoutBox.getData(payout,eth.accounts[1])});
        qualityPay.payoutBox(cPayout, result.args.boxID, disturbedCost);

        disturbedDuration = 0;
        onTrip = false;
      }
      else {
        console.log("oops something went wrong...");
      }
  });
}