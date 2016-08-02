var onTrip = false;
var disturbed = false;
var startTime;
var disturbedDuration = 0;
var lastDisturbed;
var bounty;

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

var StartingTrip = qualityPay.LogStartTrip();
StartingTrip.watch(function(error, result){
    if (!error){
      console.log("*********************************************************************************");
      console.log("Box " + result.args.boxID + "is starting trip with courier " + result.args.courier + "at "+ timeConverter(result.args.timestamp) +"!");
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
      console.log("Box " + result.args.boxID + "with courier " + result.args.courier + "at "+ timeConverter(result.args.timestamp) +" has been disturbed!");
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
      console.log("*********************************************************************************");
      console.log("Box " + result.args.boxID + "with courier " + result.args.courier + "at "+ timeConverter(result.args.timestamp) +" has been fixed!");
      console.log("*********************************************************************************");
      disturbedDuration += result.args.timestamp - lastDisturbed;
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
      console.log("*********************************************************************************");
      console.log("Box " + result.args.boxID + "is ending trip with courier " + result.args.courier + "at "+ timeConverter(result.args.timestamp) +"!");
      console.log("The Box was disturbed for " + disturbedDuration + " seconds out of a trip " + (result.args.timestamp - startTime) + "seconds long.");
      console.log("The couriers payout is " + bounty + " - " + disturbedCost + " for the box disturbances for a total of " + payout);
      console.log("*********************************************************************************");
      // payout to the courier 
      qualityPay.payoutBox(payout, result.args.boxID);

      disturbedDuration = 0;
      onTrip = false;
    }
    else {
      console.log("oops something went wrong...");
    }
});