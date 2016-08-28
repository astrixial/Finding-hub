contract Project{
  struct contributor {

    // RNG ISSUE , a bug find on Ethereum
    //Public data that should not have been public: the public RNG seed casino, cheatable RPS (bug)
    //http://martin.swende.se/blog/Breaking_the_house.html
    //just a noob code.astrxial(inheritance plays)need study more 
      uint256   secret;
      bytes32   commitment;
      uint256   refund;
      bool      revealed;
      bool      rewarded;
      //constat of goalAmount
      uint constant goalAmount == 100000000 wei;
  }

  

  struct Project {
      uint32    bnum;
      uint96    deposit;
      uint16    commitDeadline;
      uint256   random;
      bool      settled;
      uint256   bountypot;
      uint32    commitNum;
      uint32    revealsNum;

      mapping (address => participants) participants;
      mapping (address => contributors) contributors;
      mapping (address => consumers) consumers; // maybe on the future needs
  }

  uint256 public numProjects;
  Projects[] public Projects;
  address public owner;

  // Prevents methods from perfoming any value transfer
  modifier noEther() { if (msg.value > 0) throw; _}

  modifier blankAddress(address _n) { if (_n != 0) throw; _}

  modifier moreThanZero(uint256 _deposit) { if (_deposit <= 0) throw; _}
  
  modifier beFalse(bool _t) { if (_t) throw; _}

  function fund() {
      owner = msg.sender;
  }

  event LogProjectAdded(uint256 indexed ProjectID,
                         address indexed from,
                         uint32 indexed bnum,
                         uint96 deposit,
                         uint16 commitBalkline,
                         uint16 commitDeadline,
                         uint256 bountypot);

  modifier timeLineCheck(uint32 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
      if (block.number >= _bnum) throw;
      if (_commitBalkline <= 0) throw;
      if (_commitDeadline <= 0) throw;
      if (_commitDeadline >= _commitBalkline) throw;
      if (block.number >= _bnum - _commitBalkline) throw;
      _
  }

  function newProject(
      uint32 _bnum,
      uint96 _deposit,
      uint16 _commitBalkline,
      uint16 _commitDeadline
  ) timeLineCheck(_bnum, _commitBalkline, _commitDeadline)
    moreThanZero(_deposit) external returns (uint256 _ProjectID) {
      _ProjectId = Projects.length++;
      Project c = Projects[_ProjectID];
      numProjects++;
      c.bnum = _bnum;
      c.deposit = _deposit;
      c.commitBalkline = _commitBalkline;
      c.commitDeadline = _commitDeadline;
      c.bountypot = msg.value;
      
  }

  event LogFollow(uint256 indexed ProjectId, address indexed from, uint256 bountypot);

  
  
  function commit(uint256 _ProjectID, bytes32 _hs) notBeBlank(_hs) external {
      Project c = Projects[_ProjectId];
      commitmentProject(_ProjectId, _hs, c);
  }

  modifier checkDeposit(uint256 _deposit) { if (msg.value != _deposit) throw; _}

  modifier checkCommitPhase(uint256 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
      if (block.number < _bnum - _commitBalkline) throw;
      if (block.number > _bnum - _commitDeadline) throw;
      _
  }
  //fucntion contribute , I´m agnostic of create a real findinghub secure

  function commitmentProject(
      uint256 _ProjectID,
      bytes32 _hs,
      Campaign storage c
  ) checkDeposit(c.deposit)
    checkCommitPhase(c.bnum, c.commitBalkline, c.commitDeadline)
    beBlank(c.participants[msg.sender].commitment) internal {
      c.contributors[msg.sender] = contributor(0, _hs, 0, false, false);
      c.commitNum++;
      LogCommit(_ProjectID, msg.sender, _hs);
  }

  // For test
  function getCommitment(uint256 _ProjectID) noEther external constant returns (bytes32) {
      Project c = [_ProjectID];
      Participant p = c.participants[msg.sender];
      return p.commitment;
  }

  function shaCommit(uint256 _s) returns (bytes32) {
      return sha3(_s);
  }

  event LogReveal(uint256 indexed ProjectId, address indexed from, uint256 secret);

  

  

  // The commiter get his bounty and deposit, there are three situations
  // 1.  succeeds.Every contributer gets his deposit and the bounty.
  // 2. Someone revels, but some does not,fails.
  // The revealer can get the deposit and the fines are distributed.
  // 3. Nobody , fails.Every commiter can get his deposit.
  function getMyBounty(uint256 _ProjectID) noEther external {
      Project c = Projects[_ProjectID];
      Participant p = c.participants[msg.sender];
      transferBounty(c, p);
  }

  function transferBounty(
      Project storage c,
      Participant storage p
    ) bountyPhase(c.bnum)
      beFalse(p.rewarded) internal {
      if (c.revealsNum > 0) {
          if (p.revealed) {
              uint256 share = calculateShare(c);
              returnReward(share, c, p);
          }
      // Nobody reveals
      } else {
          returnReward(0, c, p);
      }
  }

  function calculateShare(Project c) internal returns (uint256 _share) {
      // Someone does not reveal. fails.
      if (c.commitNum > c.revealsNum) {
          _share = fines(c) / c.revealsNum;
      // succeeds.
      } else {
          _share = c.bountypot / c.revealsNum;
      }
  }
 // pay out function has issue maybe a better design is a return reward with conditions.
 //function pay out   
  function returnReward(
      uint256 _share,
      Project storage c,
      Participant storage p
  ) internal {
      p.reward = _share;
      p.rewarded = true;
      if (!msg.sender.send(_share + c.deposit)) {
          p.reward = 0;
          p.rewarded = false;
      }
  }

  function fines(Project c) internal returns (uint256) {
      return (c.commitNum - c.revealsNum) * c.deposit;
  }

  // If  fails, the contributor can get back the refund or refundBounty (paidout)
  function refundBounty(uint256 _campaignID) noEther external {
      Project c = Projects[_ProjectID]; // refund 
      returnBounty(_ProjectID, c);
  }

  modifier ProjectFailed(uint32 _commitNum, uint32 _revealsNum) {
      if (_commitNum == _revealsNum && _commitNum != 0) throw;
      _
  }

  }

  function returnBounty(uint256 _ProjectId, Project storage c)
    bountyPhase(c.bnum)
    Failed(c.commitNum,)
    beConsumer(c.consumers[msg.sender].caddr) internal {
      uint256 bountypot = c.contributors[msg.sender].bountypot;
      c.contributors[msg.sender].bountypot = 0;
      if (!msg.sender.send(bountypot)) {
          c.contributors[msg.sender].bountypot = bountypot;
      }
  }
}
