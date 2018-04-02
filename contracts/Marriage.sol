pragma solidity ^0.4.18;

contract Marriage {

    address public lawyer;
    uint256 public lastRegistryNo;
    uint256 public Fee = 1 ether;
    uint256 public feeCollected;

    enum MarriageStatus { Divorced, Engaged, MarriagePending, DivorcedPending }

    struct Couple {
        address groom;
        address bride;
        MarriageStatus status; 
        uint256 timestamp; 
    }

    /// @notice Marriage recognized by the registry no i.e uin256
    /// It is confidential data doesn't seem by everyone. It only seen by the lawyer
    /// Put restrict the access of the data
    mapping(uint256 => Couple) public coupleData;
    /// @notice true refers to user get married, False refers to not
    mapping(address => bool) public isUserMarried;

    event LogJustMarried(address _groom, address _bride, uint256 _registry, uint256 _timestamp);
    event LogDivorced(uint256 _registry, uint256 _timestamp);

    function Marriage() public {
        /* Set the lawyer which publish the this contract */
    }

    /**
     * @notice Marriage only get validated if only if it is approved by the lawyer
     * @dev Function used for wedding of two person
     * @param _groom Ethereum Address of the groom
     * @param _bride Ethereum Address of the bride
     * @return registry no.
     */
    function wedding(address _groom, address _bride) public payable returns(uint256) {
        require(msg.sender == _groom || msg.sender == _bride);
        /// check whether Groom and bride has already been married or not
        /// check -- only non-married persons voluteer for marriage
        /// check send value should be equal to -> FEE otherwise marriage doesn't happened
        feeCollected = feeCollected + Fee;
        lastRegistryNo = lastRegistryNo + 1;
        /// Pass the Marriage Status below to Pending
        coupleData[lastRegistryNo] = Couple(_groom, _bride, MarriageStatus(2), now);
        isUserMarried[_groom] = true;
        isUserMarried[_bride] = true;
        /** Emit event to know the blockchain node that they get successful marriage */
        return lastRegistryNo;
    }


    /**
     * @dev Use to approve the request of the bride or groom
     * @param _registryNo No. of regsitry provided to identify the marriage status
     * /// Only be called by the lawyer
     */
     function approvedRequest(uint256 _registryNo) public {
         if (coupleData[_registryNo].status == MarriageStatus(2)) {
             coupleData[_registryNo].status = MarriageStatus(1);
         } 
         else
            coupleData[_registryNo].status = MarriageStatus(0);
     }

    /**
     * @notice Divorced only get validated if only if it is approved by the lawyer
     * @dev Function used for divorced of two person
     * @param _registry Registry no. of marriage
     */
    function divorced(uint256 _registry) public {
        /* set the couple status to  Divorced */
        /** Emit the event to know the blockchain node that they get successful Divorced */
    }

    /// @notice only be called by the lawyer
    function withdrawlEther() public returns(bool) {
        // transfer all collected ether to the lawyer
    }

    function () {
        revert();
    }


}