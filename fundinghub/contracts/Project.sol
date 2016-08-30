//updgrade by peer-to peer.experience. I can´t connect the rng with this.the fundinghub that send //for submission
contract Project {

  struct Campaign{
  uint constant  contributePeriod = 10 days;
  uint constant targetAmount = 100000000 wei;
  address public curator;
  string title;
  uint deadline;
  bytes32 contributionsHash;
}
  address public hub;
  address public benificiary;
  uint public status;
  ProjectInfo public info;
  mapping(address => uint)public allowedRecipientsOfContributions;
  bool public active;
  bool public refundable;
  bool public successful;
  / Prevents methods from perfoming any value transfer
  modifier noEther() { if (msg.value > 0) throw; _}

  modifier isActive() {if(!active)throw; _}

  modifier isRefundable() {if(!refundable) throw;_}

  modifier blankAddress(address _n) { if (_n != 0) throw; _}

  modifier moreThanZero(uint256 _deposit) { if (_deposit <= 0) throw; _}

  modifier beFalse(bool _t) { if (_t) throw; _}

  modifier isHub() {  if(msg.sender != hub) throw;  _}

  struct Contributor {

    uint amount ;
    uint index;
    string Data ;
    string Description;
    bytes32 contributionsHash; // hash, to  validity contribution
  }
  mapping (address => Contributor) contributorInfo;
  address[] public contributors;
  event refundFailed(address contributor);

  function Project(address _curator, string _title,string _contributionsHash, uint _targetAmount, uint _deadline) {
    hub = msg.sender;
    campaign = Campaign(tx.origin, _amount, _deadline, _title);
    curator: _curator,
    title: _title,
  });
}
modifier onlyHub() {  if (msg.sender != hub) throw;  _}
function contributionOf(address a) constant returns(uint) {
    return contributorInfo[a].amount;
  }

  function fund(address source) onlyHub {
    if (now <= info.deadline) {
      if (msg.value > 0) {
        uint amount = info.targetAmount - collectedFunds; // targetAmount is always >= of collectedFunds
        if (msg.value > amount) {
          // returns the change
          if (!source.send(msg.value - amount)) throw;
        } else {
          amount = msg.value;
        }
        collectedFunds += amount;
        Contributor cData = contributorInfo[source];
        if (cData.amount == 0)
          cData.index = contributors.push(source);
        cData.amount += amount;
        // do payout if the target is reached. The check is >= but the collected funds never exceeds the target
        if (collectedFunds >= info.targetAmount) payout();
      }
    } else {
      // fundraising period expired
      if (msg.value > 0) {
        if (!source.send(msg.value)) throw;
      }
      // after the deadline the balance may not be >= of targetAmount, should refund contributors
      if (this.balance > 0) refund();
    }
  }

  function payout() internal{
        if (beneficiary.send(amountRaised)) {
            FundTransfer(beneficiary, amountRaised, false);
        } else {
            //If we fail to send the funds to beneficiary, unlock funders balance
            fundingGoalReached = false;
        }

	}


  // This function sends all individual contributions back to the respective contributor.
  function refund() internal{
    if (status == 0) {
      status = 2;
      uint contributorsCount = contributors.length;
      for (uint i=0; i < contributorsCount; i++) {
        address target = contributors[i];
        Contributor c = contributorInfo[target];
        if (!target.send(c.amount)) {
          // ignore transfer errors because all untrasfered funds will be forwarded
          // to the hub to be handled by the maintainer
          refundFailed(target);
        }
      }
      // forward untrasfered ethers to the hub to be handled by the maintainer
      if (this.balance > 0)
        hub.call.value(this.balance);
    }
  }
  function () {
    throw;
  }
}
