//update of project by peertopeer

import 'Project.sol';

contract FundingHub {
  address public maintainer;
  mapping (address => bool) public inHub;
  address[] public projects;

  event NewProject(address indexed owner, address project);

  function FundingHub() {
    maintainer = msg.sender;
  }

  modifier noValue() {
    if (msg.value > 0) throw;
    _
  }

  modifier restricted() {
    if (msg.sender != maintainer) throw;
    _
  }

  function() {
    if (!inHub[msg.sender]) throw;
  }

  function createProject(string _name, string _description, string _url, uint _targetAmount, uint _deadline)
    noValue
    returns (address)
  {
    Project p = new Project(msg.sender, _name, _description, _url, _targetAmount, _deadline);
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

  function withdraw() restricted {
    if (this.balance > 0) {
      if (!maintainer.call(this.balance)) throw;
    }
  }

  function getProjects() constant returns(address[]) {
    return projects;
  }

}
