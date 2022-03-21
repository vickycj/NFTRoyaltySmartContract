const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Testing Mint Function", function () {
  it("Should mint nft successfully", async function () {
    const RoyaltySmartContract = await ethers.getContractFactory("RoyaltySmartContract");
    const royalty = await RoyaltySmartContract.deploy();
    await royalty.deployed();

    await royalty.mintRoyaltyNft({
        value : royalty.getMintPrice()
    });

    expect(await royalty.totalSupply()).to.equal(1);
    
  });
});
