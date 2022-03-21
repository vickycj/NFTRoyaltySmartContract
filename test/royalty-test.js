const { expect } = require("chai");
const { ethers } = require("hardhat");
const { beforeEach } = require("mocha");
const chai = require('chai');
const BN = require('bn.js');
chai.use(require('chai-bn')(BN));

describe("Testing Royalty Info", function () {
  it("Should test royalty info", async function () {

    let royaltyContract;
    let owner;
    let address1;
    const RoyaltySmartFactory = await ethers.getContractFactory("RoyaltySmartContract");
    [owner, address1] = await ethers.getSigners();
    royalty = await RoyaltySmartFactory.deploy();

    await royalty.mintRoyaltyNft({
        value: royalty.getMintPrice()
    });

    await royalty.mintRoyaltyNft({
        value: royalty.getMintPrice()
    });

    await royalty.mintRoyaltyNft({
        value: royalty.getMintPrice()
    });


    beforeEach(async () => {
     
    });

    describe("", function () {
      it("Should get the default royalty info to the owner", async () => {
        let data = await royalty.royaltyInfo(0,100000);
        expect(data[0]).to.equal(await royalty.owner());
      });
    });

  /**   describe("", function () {
        it("Should get the default royalty info to the owner", async () => {
          let data = await royalty.royaltyInfo(0,100);
          expect(new BN(data[1])).to.be.bignumber.equal(new BN("2"));
        });
      });
 */
  });
});
