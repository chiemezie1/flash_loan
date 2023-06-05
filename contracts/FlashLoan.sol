// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {FlashLoanSimpleReceiverBase} from "https://github.com/aave/aave-v3-core/...";
import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/...";
import {IERC20} from "https://github.com/aave/aave-v3-core/...";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;
    constructor (address _addressProvider) FlashLoanSimpleReceiverBabe(IPoolAddressesProvider (_addressProvider)) {
        owerner = payable(msg.sender);
    }
    

     // paying back the loan with the ERC20 approve function

     function executeOperation(
    address asset,
    uint256 amount,
    uint256 premium,
    address initiator,
    bytes calldata params
  ) external override returns (bool){

    uint amountOwened = (amount + premium);
    IERC20(asset).approve(address(POOL), amountOwened);  
    return true;
  }

    // this is the function that requestFlashLoad

  function requestFlashLoad(address _token, uint256 _amount) public {
    address receiverAddress = address(this);
    address asset = _token;
    uint256 amount = _amount;
    bytes memory params ="";
    uint16 referralCode = 0;

    POOL.FlashLoanSimple(
        receiverAddress,
        asset,
        amount,
        params,
        referralCode
        );
  }


  function getBalanceOf(address _tokenAddress) external view returns(uint265){
    return IERC20(_tokenAddress).balanceOf(address(this));
  }

  function withdrawToken(address _tokenAddress) external onlyOwner {
    address token = IERC20(_tokenAddress);
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

  modifier onlyOwner{
    require(msg.sender == owner, 'Only owner can withdraw token');
    _;
  }
  receive () external payable {}
}
