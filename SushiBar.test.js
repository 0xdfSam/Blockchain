// SPDX-License-Identifier: MIT
const { expect } = require("chai");

describe("SushiBar", () => {
  let sushiBar;
  let sushiToken;
  let owner;
  let alice;

  beforeEach(async () => {
    const SushiBar = await ethers.getContractFactory("SushiBar");
    sushiToken = await ethers.getContractFactory("SushiToken");
    [owner, alice] = await ethers.getSigners();

    sushiToken = await sushiToken.deploy();
    sushiBar = await SushiBar.deploy(sushiToken.address);
  });

  it("should allow staking and unstaking", async () => {
    const amount = ethers.utils.parseEther("100");

    await sushiToken.transfer(alice.address, amount);
    await sushiToken.connect(alice).approve(sushiBar.address, amount);

    await sushiBar.connect(alice).stake(amount);
    expect(await sushiToken.balanceOf(sushiBar.address)).to.equal(amount);

    await sushiBar.connect(alice).unstake();
    expect(await sushiToken.balanceOf(sushiBar.address)).to.equal(0);
    expect(await sushiToken.balanceOf(alice.address)).to.equal(amount);
  });

  it("should calculate unstake amounts correctly based on time lock", async () => {
    const amount = ethers.utils.parseEther("100");

    await sushiToken.transfer(alice.address, amount);
    await sushiToken.connect(alice).approve(sushiBar.address, amount);

    await sushiBar.connect(alice).stake(amount);

    await ethers.provider.send("evm_increaseTime", [3600]); // Advance 1 hour
    await ethers.provider.send("evm_mine"); // Mine a new block

    await expect(sushiBar.connect(alice).unstake()).to.be.revertedWith(
      "No staking found"
    );

    await ethers.provider.send("evm_increaseTime", [2 * 24 * 3600]); // Advance 2 days
    await ethers.provider.send("evm_mine"); // Mine a new block

    await sushiBar.connect(alice).unstake();
    expect(await sushiToken.balanceOf(alice.address)).to.equal(amount);

  });
});
