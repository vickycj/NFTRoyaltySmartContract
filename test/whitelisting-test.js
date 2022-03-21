const { expect } = require("chai");
const { ethers } = require("hardhat");
const { beforeEach } = require("mocha");


describe("Testing Whitelisting", function () {
    it("Should enable disable whitelisting", async function () {

        let royalty;
        let owner;
        let address1, address2, address3, address4;
        const RoyaltySmartFactory = await ethers.getContractFactory("RoyaltySmartContract");
        [owner, address1, address2, address3, address4] = await ethers.getSigners();
        royalty = await RoyaltySmartFactory.deploy();

        beforeEach(async () => {
          
        });


        describe("", function () {
            it("Should enable whitelisting and only owner can mint", async () => {
                await royalty.setOnlyWhitListerAllowed(true);
                await royalty.mintRoyaltyNft({
                    value: royalty.getMintPrice()
                });

                expect(await royalty.totalSupply()).to.equal(1);
            });
        });


        describe("", function () {
            it("Should enable whitelisting check no whitelisted minting", async () => {
                await royalty.setOnlyWhitListerAllowed(true);
                await expect(royalty.connect(address1).mintRoyaltyNft({
                    value: royalty.getMintPrice()
                })).to.be.revertedWith("You are not whitelisted for the sale.");

            });
        });

        describe("", function () {
            it("Should enable whitelisting and update whitelisting", async () => {
                await royalty.setOnlyWhitListerAllowed(true);
                await royalty.addWhiteListers([address1.getAddress(), address2.getAddress()]);
                await royalty.connect(address1).mintRoyaltyNft({
                    value: royalty.getMintPrice()
                });

                expect(await royalty.ownerOf(1)).to.equal(await address1.getAddress());

            });
        });

        describe("", function () {
            it("Should enable whitelisting check no whitelisted minting", async () => {
                await royalty.setOnlyWhitListerAllowed(true);
                await expect(royalty.connect(address3).mintRoyaltyNft({
                    value: royalty.getMintPrice()
                })).to.be.revertedWith("You are not whitelisted for the sale.");

            });
        });

        describe("", function () {
            it("Should disable Whitelisting", async () => {
                await royalty.setOnlyWhitListerAllowed(false);
                await royalty.connect(address4).mintRoyaltyNft({
                    value: royalty.getMintPrice()
                });
                
                expect(await royalty.ownerOf(2)).to.equal(await address4.getAddress());

            });
        });

    });
});
