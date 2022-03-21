//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "hardhat/console.sol";

contract RoyaltySmartContract is ERC721Royalty, Ownable {

    constructor() ERC721("AviumWorldTestNet", "AW") {
        console.log("RoyaltySmartContract Constructor");
    }
    
}
