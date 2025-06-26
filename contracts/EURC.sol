// SPDX-License-Identifier: MIT

// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";


contract EURC is ERC20, Ownable {

    

    // MEV bot protection: Set a minimum time interval between transactions for each address

    mapping(address => uint256) public lastTransactionTime;

    uint256 public constant MIN_TIME_BETWEEN_TRANSFERS = 3 minutes;


    constructor(address initialOwner)

        ERC20("EURC", "EURC")

        Ownable(initialOwner)

    {

        _mint(msg.sender, 10000000000 * 10 ** decimals());

    }


    /**

     * @dev Modifier to prevent frequent transfers (anti-MEV bot protection).

     * Ensures that a user can only transfer once every `MIN_TIME_BETWEEN_TRANSFERS` period.

     */

    modifier antiMEV(address from) {

        require(

            block.timestamp >= lastTransactionTime[from] + MIN_TIME_BETWEEN_TRANSFERS,

            "Transfer too soon, please wait."

        );

        _;

        lastTransactionTime[from] = block.timestamp;

    }


    /**

     * @dev Mint function allows the contract owner to create new tokens.

     * @param to The address to mint tokens to.

     * @param amount The number of tokens to mint.

     * @notice This function can only be called by the contract owner.

     */

    function mint(address to, uint256 amount) public onlyOwner {

        _mint(to, amount);

    }


    /**

     * @dev Override transfer function to include MEV protection.

     * Users cannot transfer within the `MIN_TIME_BETWEEN_TRANSFERS`.

     */

    function transfer(address recipient, uint256 amount) public override antiMEV(msg.sender) returns (bool) {

        return super.transfer(recipient, amount);

    }


    /**

     * @dev Override transferFrom function to include MEV protection.

     * Users cannot transfer within the `MIN_TIME_BETWEEN_TRANSFERS`.

     */

    function transferFrom(address sender, address recipient, uint256 amount) public override antiMEV(sender) returns (bool) {

        return super.transferFrom(sender, recipient, amount);

    }

}
