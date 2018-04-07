pragma solidity ^0.4.18;

contract Marriage {

    address public lawyer;
    uint256 public lastRegistryNo;
    uint256 public Fee = 1 ether;
    uint256 public feeCollected;

    enum MarriageStatus { Divorced, Married, MarriagePending, DivorcedPending }

    struct Couple {
        address groom;
        address bride;
        MarriageStatus status; 
        uint256 timestamp; 
    }

    /// @notice Marriage recognized by the registry no i.e uin256
    /// It is confidential data, shouldn't be seen by everyone. 
    
    /* Fix_1(2): Put restrict the access of the data */
    mapping(uint256 => Couple) private coupleData;
    
    /// @notice true refers to user get married, False refers to opposite
    mapping(address => bool) public isUserMarried;

    event LogJustMarried(address _groom, address _bride, uint256 _registry, uint256 _timestamp);
    event LogDivorced(uint256 _registry, uint256 _timestamp);

    function Marriage() public {
        /* Fix_2(3):Set the lawyer which publish this contract */
        lawyer = msg.sender;
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
        
        /* Fix_3(3): check that Groom & Bride both are unmarried, otherwise throw */
        require(!isUserMarried);
        
        /* Fix_4(3): check that sent Ether value is equal to the FEE required, otherwise throw */
        require(coupleData.feeCollected == Fee);
        
        feeCollected = feeCollected + Fee;
        lastRegistryNo = lastRegistryNo + 1;
        /// Pass the Marriage Status below to Pending
        coupleData[lastRegistryNo] = Couple(_groom, _bride, MarriageStatus(2), now);
        isUserMarried[_groom] = true;
        isUserMarried[_bride] = true;
        
        /* Fix_5(3): Emit event related to successful marriage */
        emit LogJustMarried(_groom, _bride, lastRegistryNo, now);
        return lastRegistryNo;
    }

    modifier islawyer {
        require(msg.sender == lawyer);
        _;
    }
    /**
     * @dev Use to approve the request of the bride or groom
     * @param _registryNo No. of regsitry provided to identify the marriage status
     */
     function approvedRequest(uint256 _registryNo) islawyer public {
     /* Fix_6(5): Write a modifier to check that certain function can only be called by lawyer and associate with this function*/
        
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
     modifier candivorce {
        require(coupleData[_registry].status == MarriageStatus(1));
        require(coupleData[_registry].status == MarriageStatus(3));
        _;
    }
    function divorced(uint256 _registry) candivorce public {
        /* Fix_7(8): Asociate right modifier and set the couple status to  Divorced */
        coupleData[_registry].status = MarriageStatus(0);
        /* Fix_8(3): Emit the right event related to successful Divorced */
        emit LogDivorced(_registry, now);
    }

    /// @notice only be called by the lawyer
    function withdrawEther() public islawyer returns(bool) {
        /* Fix_9(10): Associate the right modifier and write logic to transfer all collected ether to the lawyer and return result*/
        
        
    }

    /* Fix_10(10): Add the fallback function which should prevent transfer of any accidental ether to the contract*/
    function fallback   {
        revert();
    }
    }

}
