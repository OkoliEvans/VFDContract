//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

/// @title This is a voting contract.
/// @notice Three candidates are to be voted for at any instance.
/// @notice MasterAdmin is the Owner 
contract VotingDAO {

///     state variables     ///
    uint256 private decimal;
    uint256 private totalContenders;
    uint256 public TotalVotes;

///     Token variables   ///
    uint256 public totalSupply;
    string private _name;
    string private _symbol;

    address public MasterAdmin;
    
   
    enum VoteTimer {
        start,
        end
    }

    VoteTimer voteTimer;

    constructor(string memory tokenName, string memory symbol) {
        _name = tokenName;
        _symbol = symbol;
        decimal = 1e18;
        MasterAdmin = msg.sender;
    }

    struct ContendersData {
        address candidate;
        uint votes;
    }

/// @notice balances maps token balance to accounts
    mapping (address => uint256) private _balances;
    //mapping(uint8 => ContendersData) public id;
    mapping(address => bool) public Voted;
    mapping (address => bool) public IsRegistered;
    mapping (address => uint256) public Votees;

    address[] public votedAccounts;

    event VotingStatus(string message);
    event Transfer(address owner,address receiver,uint256 amount);


    function mint(uint quantity) public {
        require(msg.sender == MasterAdmin, "Not Authorized");
        totalSupply += (quantity * decimal);
    }

     function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
     }

        function transfer(address sender,address receiver, uint256 amount) public returns (bool sent) {
        require(receiver != address(0), "Invalid Address");
        _transfer(sender, receiver, amount);
        sent = true;
    }

    function _transfer(address owner, address receiver, uint256 amount) private  {
        require(owner != address(0), "ERC20: transfer from the zero address");
        uint256 fromBalance = _balances[owner];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        emit Transfer(owner, receiver, amount);
    }

    function buyToken(uint amount) public payable returns(bool success)  {
        (bool sent,) = address(this).call{value: msg.value}("");
        require(sent, "Transaction fail");
        uint n = msg.value * amount;
        totalSupply -= n;
        _balances[msg.sender] += n;
        success = true;
    }

    function withdraw(uint amount, address payable _to) public payable onlyOwner returns(bool success) {
        require(_to != address(0), "Invalid address");
        (bool sent, ) = _to.call{value: amount}("");
        require(sent, "Transaction failed");
        success = true; 
    }



///////////////////////////////////////////////////////////////////////////

    modifier onlyOwner() {
        require(MasterAdmin == msg.sender, "Unauthorized operation");
        _;
    }

/// @notice start voting process
    function setNumOfContenders() public {
        totalContenders = 3;
    }

    function startVoting() private onlyOwner{
        require(totalContenders == 3, "Must be minimum of 3 contenders");
        voteTimer = VoteTimer.start;
        emit VotingStatus("Voting has started.");
    }

    function endVoting() public onlyOwner {
        voteTimer = VoteTimer.end;
        emit VotingStatus("Voting has ended");
    }

    function registerContender(address _contender) public onlyOwner {
        require(address(_contender) != address(0));
        require(address(_contender).balance >= 10);
        require(!IsRegistered[_contender], "Already registered");
        IsRegistered[_contender] = true;
        emit VotingStatus("Account added as contender.");
    }


    function _castVote(
        address _voter,
        address _candidateA,
        address _candidateB,
        address _candidateC
        ) internal {
        require(voteTimer == VoteTimer.start, "Voting Closed");
        require(address(_voter).balance >= 10);
        require(!Voted[_voter], "Only ONE vote is allowed");
        require(IsRegistered[_candidateA] && IsRegistered[_candidateB] && IsRegistered[_candidateC], "Candidate not among contenders");
        startVoting();
        Voted[_voter] = true;
        Votees[_candidateA] += 3;
        Votees[_candidateB] += 2;
        Votees[_candidateC] += 1;
        TotalVotes = TotalVotes + 6;
    }

    function winner() public view returns(address winner) {
        
    }

    function returnVoteDetails() public view returns(uint256[] memory, address[] memory) {
   
    }




    receive() external payable{}
    fallback() external payable {}

}

