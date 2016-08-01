/* modifer that creats a contract that is owned by the contract creater and functions to accompany it */
contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract karma {
    /* Public variables of the karma */
    string public standard = 'karma 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public startingSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supply karmas to the creator of the contract */
    function karma(
        uint256 initialSupply,
        string karmaName,
        uint8 decimalUnits,
        string karmaSymbol
        ) {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial karmas
        totalSupply = initialSupply;                        // Update total supply
        name = karmaName;                                   // Set the name for display purposes
        symbol = karmaSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }

    /* Here we set up people by having the first time people interact be a sign
     up and give them a starting amount of karma*/
    function setupAccount() {

    }

    /* Send karma */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }

    /* Allow another contract to spend some karmas in the owner's behalf so */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        karmaRecipient spender = karmaRecipient(_spender);
        spender.receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    /* A contract attempts to get the karma */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
        balanceOf[_from] -= _value;                           // Subtract from the sender
        balanceOf[_to] += _value;                             // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /* This unnamed function is called whenever someone tries to send pure ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}