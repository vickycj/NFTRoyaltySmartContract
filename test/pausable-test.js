const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Testing Pause/Unpause Function", function () {
    it("Should pause/unpause successfully", async function () {
        const RoyaltySmartContract = await ethers.getContractFactory("RoyaltySmartContract");
        const royalty = await RoyaltySmartContract.deploy();
        await royalty.deployed();

        await royalty.pause()

        await expect(royalty.mintRoyaltyNft()).to.be.revertedWith('Pausable: paused');

        await royalty.unpause()

        await royalty.mintRoyaltyNft({
            value: royalty.getMintPrice()
        });

        expect(royalty.totalSupply() > 0);

    });
});