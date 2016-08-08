contract qualityPay {
    
    event LogBoxDisturbed(address indexed boxID, address indexed courier, uint timestamp);
    event LogBoxFixed(address indexed boxID, address indexed courier, uint timestamp);
    event LogStartTrip(address indexed boxID, address indexed courier, uint timestamp, uint bounty);
    event LogEndTrip(address indexed boxID, address indexed courier, uint timestamp);
    
    address public commandCenter = msg.sender;
    uint public minShippingCost = 5 ether;
    
    mapping(address => Box) public Boxes;
    
    struct Box{
        uint bounty;
        uint disturbedDuration;
        uint lastDisturbed;
        bool onTrip;
        address currentCourier;
        address sender;
    }

    modifier onlyMovingBoxes {
        if (!Boxes[msg.sender].onTrip)
            throw;
        _
    }
    
    modifier onlycommandCenter {
        if (commandCenter != msg.sender)
            throw;
        _
    }

    // This is the constructor whose code is
    // run only when the contract is created.
    function qualityPay(){
        
    }
    
    function recordBoxDisturbed(address _currentCourier) onlyMovingBoxes {
        LogBoxDisturbed(msg.sender,Boxes[msg.sender].currentCourier, now);
        Boxes[msg.sender].lastDisturbed = now;
    }

    function recordBoxFixed() onlyMovingBoxes {
        LogBoxFixed(msg.sender, Boxes[msg.sender].currentCourier, now);
        Boxes[msg.sender].disturbedDuration += now - Boxes[msg.sender].lastDisturbed;
    }
    
    function startBox(address _boxID, address _currentCourier) {
        if (msg.value < minShippingCost)
            throw;
        Boxes[_boxID].onTrip = true;
        Boxes[_boxID].sender = msg.sender;
        Boxes[_boxID].currentCourier = _currentCourier;
        LogStartTrip(_boxID, Boxes[_boxID].currentCourier, now, msg.value);
        
    }
    
    function endBox(address _boxID) onlycommandCenter{
        LogEndTrip(_boxID, Boxes[_boxID].currentCourier, now);
    }
    
    function payoutBox(uint bPayout, uint cPayout, address _boxID, uint change) onlycommandCenter{
        Boxes[_boxID].onTrip = false;
        if (_boxID.send(bPayout)){
            
        }
        if (Boxes[_boxID].currentCourier.send(cPayout)){
            
        }
        if (Boxes[_boxID].sender.send(change)){
            
        }
    }
}