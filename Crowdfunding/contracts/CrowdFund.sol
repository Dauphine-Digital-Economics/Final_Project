// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Importing OpenZeppelin's SafeMath Implementation
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdfund {
  using SafeMath for uint256; 

  // List all the projects 
  Project[] private projects; 

  // event for when new project starts
  event ProjectStarted(
    address contractAddress,
    address projectCreator,
    string creatorName,
    string title,
    string description, 
    string imageLink,  
    uint256 fundRaisingDeadline,
    uint256 goalAmount
  ); 

  function startProject(
    IERC20 cUSDToken,
    string memory creatorName,
    string memory title,
    string memory description,
    string memory imageLink, 
    uint durationInDays, 
    uint amountToRaise
  ) external {
    uint raiseUntil = block.timestamp.add(durationInDays.mul(1 days)); 
    Project newProject = new Project (cUSDToken, payable(msg.sender), creatorName, title, description, imageLink, raiseUntil, amountToRaise); 
    projects.push(newProject); 
    emit ProjectStarted(
      address(newProject),
      msg.sender, 
      creatorName,
      title,
      description, 
      imageLink, 
      raiseUntil, 
      amountToRaise
    );
  }

  function returnProjects() public view returns(Project[] memory) {
    return projects; 
  }
}

contract Project {
  using SafeMath for uint256;

  enum ProjectState {
    Fundraising, 
    Expired, 
    Successful
  }
  IERC20 private cUSDToken;

  address payable public creator; 
  uint public goalAmount; 
  uint256 public totalRaised; 
  uint256 public currentBalance; 
  uint public raisingDeadline; 
  string public creatorName;
  string public title;
  string public description; 
  string public imageLink;

  ProjectState public state = ProjectState.Fundraising; // start with fundraising 
  mapping (address => uint) public contributions;
  
  // Event when funding is received
  event ReceivedFunding(address contributor, uint amount, uint currentTotal);

  // Event for when the project creator has received their funds
  event CreatorPaid(address recipient); 

  modifier theState(ProjectState _state) {
    require(state == _state);
    _; 
  }

  constructor
  (
    IERC20 token,
    address payable projectCreator, 
    string memory projectCreatorName,
    string memory projectTitle,
    string memory projectDescription,
    string memory projectImageLink, 
    uint fundRaisingDeadline,
    uint projectGoalAmount
  ) {
    cUSDToken = token; 
    creatorName = projectCreatorName;
    creator = projectCreator; 
    title = projectTitle; 
    description = projectDescription;
    imageLink = projectImageLink;
    goalAmount = projectGoalAmount;
    raisingDeadline = fundRaisingDeadline;
    currentBalance = 0; 
  }

  // Fund a certain project
  function contribute(uint256 amount) external payable {
    require(!checkIfFundingExpired(), "Deadline has passed");
    require(amount >= 5, "Amount is below minimum required");

    cUSDToken.transferFrom(msg.sender, address(this), amount);

    contributions[msg.sender] = contributions[msg.sender].add(amount);
    currentBalance = currentBalance.add(amount);
    emit ReceivedFunding(msg.sender, amount, currentBalance);
  }


  // check project state
  function checkIfFundingExpired() private returns(bool) {
    if (block.timestamp > raisingDeadline) {
      state = ProjectState.Expired;
      return true;
    }

    return false;
  }

  function payOut() external returns (bool result) {
    require(checkIfFundingExpired(), "Fundraising not yet closed"); 

    totalRaised = currentBalance; 
    currentBalance = 0; 

    if (cUSDToken.transfer(creator, totalRaised)) {
        emit CreatorPaid(creator);
        state = ProjectState.Successful;
        return true; 
    } else { 
        return false;
    }
  }


  function getDetails() public view returns 
  (
    address payable projectCreator, 
    string memory projectCreatorName,
    string memory projectTitle,
    string memory projectDescription,
    string memory projectImageLink, 
    uint fundRaisingDeadline,
    ProjectState currentState, 
    uint256 projectGoalAmount,
    uint256 currentAmount, 
    uint256 projectTotalRaised
  ) {
    projectCreator = creator;
    projectCreatorName = creatorName;  
    projectTitle = title;
    projectDescription = description;
    projectImageLink = imageLink; 
    fundRaisingDeadline = raisingDeadline;
    currentState = state; 
    projectGoalAmount = goalAmount; 
    currentAmount = currentBalance; 
    projectTotalRaised = totalRaised; 
  }
}
