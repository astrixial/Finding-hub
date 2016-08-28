
 /* the project.sol on further code can make all the functions , the propasal of code is for avoid RNG issue , 
 */public data that should not have been public , I sended  a b9lab , Project.sol and geth  tests.
import 'Project.sol';

contract FundingHub {
  address public Curator;
  mapping (address => bool) public inHub;
  address[] public projects;

  event NewProject(address indexed owner, address project);

  function FundingHub() {
    Curator = msg.sender;
  }

  modifier noValue() {
    if (msg.value > 0) throw;
    _
  }

  modifier restricted() {
    if (msg.sender != Curator) throw;
    _
  }

  function() {
    if (!inHub[msg.sender]) throw;
  }
 
 function createProject(uint _amount, uint _deadline, string _title) returns (Project createdProject){
    Project newProject = newProject(_amount, _deadline, _title);
    activeProjects.push(newProject);
    return newProject;
  {
    Project p = newProject(msg.sender, _name, _description, _url, _targetAmount, _deadline);
    projects.push(p);
    inHub[p] = true;
    NewProject(msg.sender, p);
    return p;
  }

  function contribute(address proj) {
    if (inHub[proj]) {
      Project(proj).fund.value(msg.value)(msg.sender);
    } else {
      throw;
    }
    }
  function getProjects() constant returns(address[]) {
    return projects;
  }
}
