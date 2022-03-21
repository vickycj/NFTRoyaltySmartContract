const { expect } = require("chai");
const { ethers } = require("hardhat");
const { beforeEach } = require("mocha");


describe("Testing Compilation/Deployment", function () {
  it("Should compile successfully and deploy without errors", async function () {

    let royaltyContract;
    let owner;
    let address1;


    beforeEach(async () => {
      const RoyaltySmartFactory = await ethers.getContractFactory("RoyaltySmartContract");
      [owner, address1] = await ethers.getSigners();
      royaltyContract = await RoyaltySmartFactory.deploy();
    });

    describe("", function () {
      it("Should initialize the contract", async () => {
        expect(await royaltyContract.totalSupply()).to.equal(0);
      });
    });

    describe("", function () {
      it("Should set the right owner", async () => {
        expect(await royaltyContract.owner()).to.equal(await owner.address);
      });
    });

  });
});
