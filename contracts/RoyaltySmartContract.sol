//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "hardhat/console.sol";
import "./WhiteListing.sol";

contract RoyaltySmartContract is  WhiteListing,
    ERC721Royalty,
    ERC721Enumerable,
    Pausable,
    Ownable
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /** Custom event to be triggered for each new mints */
    event RoyaltykNftMinted(address sender, uint256 tokenId);

    /** Royalty fee expressed in basis point, defaults to 2 % of the sale price */
    uint96 ROYALTY_FEE_DEFAULT = 20;

    
    uint16 public constant MAX_SUPPLY = 1000;
    uint256 public constant MINT_PRICE = 0.5 ether;
    uint8 public constant MAX_PER_ADDRESS = 5;
    string constant BASE_URL =
        "ipfs://QmQzyFHWKcKS8YxyQ12Sy71LAo4Atc9yYkp96DpnXcegVT";


    /** Intialiser to set the default values and the base Uri */
    constructor() ERC721("AviumWorldTestNet", "AWW") {
        console.log("RoyaltySmartContract Constructor");
        _setDefaultRoyalty(_msgSender(), ROYALTY_FEE_DEFAULT);
    }

    /** Update Royalty Fee */
    function updateRoyaltyFee(uint96 royaltyFee) public onlyOwner {
        _setDefaultRoyalty(owner(), royaltyFee);
    }

  
    /** Withdraw money to the owner address */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ether left to withdraw");

        (bool success, ) = (owner()).call{value: balance}("");
        require(success, "Transfer failed.");
    }

    /** Change the state of whitelist minting  */
    function setOnlyWhitListerAllowed(bool _state) public onlyOwner {
        _setOnlyWhitelisted(_state);
    }

    /** Set the list of whitelisters, clears the previous values */
     function addWhiteListers(address[] calldata _users) public onlyOwner {
        _whitelistUsers(_users);
    }

    /** Do validations and mint NFT if all conditions matches */
    function mintRoyaltyNft() public payable whenNotPaused {
        require(totalSupply() <= MAX_SUPPLY, "NFTs Sold Out.");
        require(msg.value >= MINT_PRICE, "Not enough ether to purchase NFT.");
        require(
            balanceOf(_msgSender()) <= MAX_PER_ADDRESS,
            "Already Exceeded max alowed Tokens."
        );
        if(_isOnlyWhitelisted() == true) {
            require(isWhitelisted(_msgSender()), "You are not whitelisted for the sale.");
            _mintNft();
        } else {
            _mintNft();
        }
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
        return BASE_URL;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return _baseURI();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }
}
