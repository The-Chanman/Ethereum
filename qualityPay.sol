contract qualityPay {
    
    event LogBoxDisturbed(address indexed boxID, address indexed courier, uint timestamp);
    event LogBoxFixed(address indexed boxID, address indexed courier, uint timestamp);
    event LogStartTrip(address indexed boxID, address indexed courier, uint timestamp);
    event LogEndTrip(address indexed boxID, address indexed courier, uint timestamp);
    
    address public commandCenter = msg.sender;
    
    mapping(address => Box) Boxes;
    
    struct Box{
        bool onTrip;
        bool isTilted; //if not tilted then we assume its flat
        address currentCourier;
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
    
    function recordBoxDisturbed(address _drawer, uint _lat, uint _long) onlyMovingBoxes {
        LogBoxDisturbed(msg.sender,Boxes[msg.sender].currentCourier, now);
        Boxes[msg.sender].isTilted = true;
    }

    function recordBoxFixed() onlyMovingBoxes {
        LogBoxFixed(msg.sender, Boxes[msg.sender].currentCourier, now);
        Boxes[msg.sender].isTilted = false;
    }
    
    function startBox(address _boxID, address _currentCourier) {
        Boxes[_boxID].onTrip = true;
        Boxes[_boxID].currentCourier = _currentCourier;
        LogStartTrip(_boxID, Boxes[_boxID].currentCourier, now);
        
    }
    
    function payoutBox(uint payout, address _boxID) onlycommandCenter{
        LogEndTrip(_boxID, Boxes[_boxID].currentCourier, now);
        if (Boxes[_boxID].currentCourier.send(payout)){
            
        }
        
    }
}