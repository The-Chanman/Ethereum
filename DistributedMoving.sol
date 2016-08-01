contract DistributedMoving {
	
	event logHandOff(address dropper, address pickerupper, uint lat, uint long, uint timestamp);
    event delivered( uint lat, uint long, uint timestamp);

    uint public currentLat;
    uint public currentLong;
    
    struct Trip{
        uint dropoffLat;
        uint dropoffLong;
        bool boxVirgin;  // been opened or not
        uint[] handOffsLat; // list of handoffs
        uint[] handOffsLong; // list of handoffs
        uint price;
        address handler;
        uint numHandoff;
        address box;
    }
    
    Trip public currentTrip;
    bool public onTrip;
    
    modifier onlyHandler {
        if (currentTrip.handler!=msg.sender)
            throw;
        _
    }
    modifier onlyBox {
        if (currentTrip.box!=msg.sender)
            throw;
        _
    }
    
    function calculatePrice(uint pickupLat, uint pickupLong, uint dropoffLat, uint dropoffLong) returns (uint){
        //Algorithm to calculate price
        //WIF
        uint Price = (pickupLat - dropoffLat) * (pickupLong - dropoffLong);
        return Price;
    }
    
    function calculatePercentComplete() returns (uint){
        // calculate the percentage of the journey completed
        // WIF
        uint Percentage = (currentTrip.handOffsLat[currentTrip.numHandoff] - currentTrip.dropoffLat) * (currentTrip.handOffsLong[currentTrip.numHandoff] - currentTrip.dropoffLong) / (currentLat - currentLong);
        return Percentage;
    }
    
    function createNewTrip(uint dropoffLat, uint dropoffLong, address courier, address box){
        currentTrip.price = calculatePrice(currentLat, currentLong, dropoffLat, dropoffLong);
        currentTrip.box = box;
        currentTrip.dropoffLat = dropoffLat;
        currentTrip.dropoffLong = dropoffLong;
        currentTrip.numHandoff = 0;
        currentTrip.handOffsLat[currentTrip.numHandoff] = currentLat;
        currentTrip.handOffsLong[currentTrip.numHandoff] = currentLong;
        bool certified = true;
        if(certified){
            currentTrip.boxVirgin = true; //if successfully certified
        }
        currentTrip.handler = courier;
    }
    function handOff(address newHandler) onlyHandler{
        // given handoff occurs at the current location of the box
        uint payout = calculatePercentComplete() * currentTrip.price;
        currentTrip.handler.send(payout);
        currentTrip.handler = newHandler;
        currentTrip.handOffsLat.length += 1;
        currentTrip.handOffsLong.length += 1;
        currentTrip.handOffsLat[currentTrip.numHandoff] = currentLat;
        currentTrip.handOffsLong[currentTrip.numHandoff] = currentLong;
        currentTrip.numHandoff += 1;
        logHandOff(currentTrip.handler, newHandler, currentLat, currentLong, now);
    }
    function deliverySuccess() onlyHandler{
        // given handoff occurs at the current location of the box
        uint payout = calculatePercentComplete() * currentTrip.price;
        currentTrip.handler.send(payout);
        delivered(currentLat, currentLong, now);
    }
    function tampered() onlyBox{
        currentTrip.boxVirgin = false;
    }
}