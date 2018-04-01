pragma solidity ^0.4.18;

contract Marriage {

    address public lawyer;
    uint256 public lastRegistryNo;
    uint256 public Fee = 1 ether;
    uint256 public feeCollected;
    uint256 public constant SECURITY = 2 ether;

    enum MarriageStatus { Divorced, Engaged }

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
    function marriage(address _groom, address _bride) public payable returns(uint256) {
        /// check whether Groom and bride has already been married or not
        /// check -- only non married persons voluteer for marriage
        /// check send value should be equal to -> SECURITY + FEE
        feeCollected = feeCollected + Fee;
        lastRegistryNo = lastRegistryNo + 1;
        /// Pass the Marriage Status below to Engaged
        coupleData[lastRegistryNo] = Couple(_groom, _bride, MarriageStatus(1), now);
        isUserMarried[_groom] = true;
        isUserMarried[_bride] = true;
        /** Emit event to know the blockchain node that they get successful marriage */
        return lastRegistryNo;
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


    function withdrawlEther() public returns(bool) {
        if (msg.sender == lawyer) {
            /** transfer the feeCollected to the lawyer */
            feeCollected = 0;
            return true;
        } else {
            /** transfer the Security to the */
        }
    }




}