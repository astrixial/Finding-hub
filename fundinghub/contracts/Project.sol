contract PROJECT {



  uint constant  contributePeriod = 100 days;

  contribute[] public contributions;

  address public curator;

  mapping(address = > bool)public allowedRecipientsOfContributions;


  mapping (address => uint) public FINDINGHUBpaidOut;

  mapping

  uint sumOfContributionsDeposits;

  // contract to create a new FINDINGHUB (avoid retrancy bugs,TOD , blocktime dependece.)

  FINDINGHUB_Creator public findighubcreator;


}

  struct contributions {
    address recipient;
    uint amount ;

    string Data ;
    string Description;
    uint  Deadline;
    bytes32 contributionsHash; // hash, to  validity contribution


  }

  function fund()
}









fund()




payout()




refund()
