//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "hardhat/console.sol";

contract RoyaltySmartContract is ERC721Royalty, ERC721Enumerable, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /** Custom event to be triggered for each new mints */
    event RoyaltykNftMinted(address sender, uint256 tokenId);

    /** Royalty fee expressed in basis point, defaults to 2 % of the sale price */
    uint96 ROYALTY_FEE_DEFAULT = 20;

    bool public isSaleActive = true;
    uint16 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.5 ether;
    uint8 public constant MAX_PER_ADDRESS= 5;

    
    /** Intialiser to set the default values and the base Uri */
    constructor() ERC721("AviumWorldTestNet", "AWW") {
        console.log("RoyaltySmartContract Constructor");
        _setDefaultRoyalty(_msgSender(), ROYALTY_FEE_DEFAULT);
    }


    /** Update Royalty Fee */
    function updateRoyaltyFee(uint96 royaltyFee) public onlyOwner {
        _setDefaultRoyalty(owner(), royaltyFee);
    }

    /** Update sale status : stop or start*/
    function updateSaleStatus() public onlyOwner {
        isSaleActive = !isSaleActive;
    }

     /** Withdraw money to the owner address */
    function withdraw() public onlyOwner {
       uint balance = address(this).balance;
       require(balance > 0, "No ether left to withdraw");

       (bool success,) = (owner()).call{value: balance}("");
       require(success, "Transfer failed.");
    }

     /** Do basic validations and mint NFT if all conditions matches */
    function mintRoyaltyNft() public payable {
        require(isSaleActive, "Sale is not active.");
        require(totalSupply() <= MAX_SUPPLY, "NFTs Sold Out.");
        require(msg.value >= MINT_PRICE, "Not enough ether to purchase NFT.");
        require(balanceOf(_msgSender()) <= MAX_PER_ADDRESS, "Already Exceeded max alowed Tokens.");
        _mintNft();
    }

   
    function _mintNft() internal {
        uint256 newItemId = _tokenIds.current();
        _safeMint(_msgSender(), newItemId);
        _tokenIds.increment();
        console.log("RoyaltySmartContract NFT minted", newItemId, _msgSender());
        emit RoyaltykNftMinted(_msgSender(), newItemId);
    }


     function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://foo.com/token/";
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }

    
}
