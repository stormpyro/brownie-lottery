// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }
    LOTTERY_STATE public lottery_state;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 50 * (10**18); // 18 decimals
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function enter() public payable {
        // $50 minimum
        require(lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value >= getEntranceFee(), "Not Enough ETH!");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        // Segun chainlink esto solo retorna 8 decimales.
        //  Es el precio de 1 ETH en USD * 10 ^ 8
        //  Se debe aumentar solo 10 ^ 10
        (, int256 price, , , ) = ethUsdPriceFeed.latestRoundData();
        // Precio  en USD de 1 ETH
        uint256 adjustedPrice = uint256(price) * 10**10;
        // Get entrance Fee in Wei
        // ((usdEntryFee * 10**18) / adjustedPrice)
        uint256 costToEnter = ((usdEntryFee * 10**18) / adjustedPrice);
        return costToEnter;
    }

    function convertFromETHtoWei() private pure returns (uint256) {}

    // Importante: Need a view function to convert from ETH to Wei

    function startLottery() external onlyOwner {
        require(
            lottery_state == LOTTERY_STATE.CLOSED,
            "Can't start a new lottery yet!"
        );
        lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        
    }
}
