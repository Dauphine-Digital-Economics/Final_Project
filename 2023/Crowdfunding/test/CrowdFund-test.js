const { expect } = require("chai");
const { ethers } = require("hardhat");
const { parseEther } = ethers.utils;
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("CrowdFund", function () {
  let crowdFund;
  let cUSDToken;

  beforeEach(async function () {
    const CrowdFund = await ethers.getContractFactory("Crowdfund");
    crowdFund = await CrowdFund.deploy();
    await crowdFund.deployed();

    const CUSDToken = await ethers.getContractFactory("CUSDToken");
    cUSDToken = await CUSDToken.deploy();
    await cUSDToken.deployed();
  });

  it("should create a new project and return it", async function () {
    const creatorName = "Dauphine";
    const title = "New Project";
    const description = "A new project for testing";
    const imageLink = "https://github.com/aizhan-zhak/Dauphine-Digital-Economics/blob/main/img/MetaMask_Fox.svg";
    const durationInDays = 30;
    const amountToRaise = parseEther("100");

    const tx = await crowdFund.startProject(
      cUSDToken.address,
      creatorName,
      title,
      description,
      imageLink,
      durationInDays,
      amountToRaise
    );

    const receipt = await tx.wait();
    const projectAddress = receipt.events[0].args.contractAddress;

    const projects = await crowdFund.returnProjects();

    expect(projects.length).to.equal(1);
    expect(projects[0]).to.equal(projectAddress);

    const project = await ethers.getContractAt("Project", projectAddress);

    expect(await project.creatorName()).to.equal(creatorName);
    expect(await project.title()).to.equal(title);
    expect(await project.description()).to.equal(description);
    expect(await project.imageLink()).to.equal(imageLink);
    expect(await project.goalAmount()).to.equal(amountToRaise);
  });

  it("should fund a project and update balances", async function () {
    const creatorName = "Dauphine";
    const title = "New Project";
    const description = "A new project for testing";
    const imageLink = "https://github.com/aizhan-zhak/Dauphine-Digital-Economics/blob/main/img/MetaMask_Fox.svg";
    const durationInDays = 30;
    const amountToRaise = 100;

    await crowdFund.startProject(
      cUSDToken.address,
      creatorName,
      title,
      description,
      imageLink,
      durationInDays,
      amountToRaise
    );

    const projects = await crowdFund.returnProjects();
    const projectAddress = projects[0];
    const project = await ethers.getContractAt("Project", projectAddress);
    const [owner, funder] = await ethers.getSigners();
    const funder_addr = funder.address;
    const amountToFund = ethers.BigNumber.from("50");
    
    //give 100 tokens to funder
    await cUSDToken.transfer(funder_addr, 100);

    //funder approves project as spender
    await cUSDToken.connect(funder).approve(projectAddress, 100);

    const initialBalance = await cUSDToken.balanceOf(funder_addr);
    const projectBalance = await cUSDToken.balanceOf(projectAddress);

    // Contribute to fundraiser
    await project.connect(funder).contribute(amountToFund);
    
    const finalBalance = await cUSDToken.balanceOf(funder_addr);
    expect(finalBalance).to.equal(initialBalance.sub(amountToFund));

    const currentProject = await project.getDetails();
    expect(currentProject.currentAmount).to.equal(projectBalance.add(amountToFund));
  });

  it("should not allow funding after deadline", async function () {
  const creatorName = "Dauphine";
  const title = "New Project";
  const description = "A new project for testing";
  const imageLink = "https://github.com/aizhan-zhak/Dauphine-Digital-Economics/blob/main/img/MetaMask_Fox.svg";
  const durationInDays = 1;
  const amountToRaise = parseEther("100");
  await crowdFund.startProject(
    cUSDToken.address,
    creatorName,
    title,
    description,
    imageLink,
    durationInDays,
    amountToRaise
  );
  
  const projects = await crowdFund.returnProjects();
  const projectAddress = projects[0];
  const project = await ethers.getContractAt("Project", projectAddress);
  
  const funder = await ethers.getSigner(1);
  const amountToFund = ethers.BigNumber.from("50");

  await cUSDToken.transfer(funder.address, 100);
  await cUSDToken.connect(funder).approve(projectAddress, 100);

  // Move time forward to end of funding duration and mine a block
  await time.increase(durationInDays*24*60*60);
  
  await expect(project.connect(funder).contribute(amountToFund)).to.be.revertedWith(
    "Deadline has passed"
  );
});

it("should not allow funding below minimum amount", async function () {
  const creatorName = "Dauphine";
  const title = "New Project";
  const description = "A new project for testing";
  const imageLink = "https://github.com/aizhan-zhak/Dauphine-Digital-Economics/blob/main/img/MetaMask_Fox.svg";
  const durationInDays = 30;
  const amountToRaise = parseEther("100");
  const minimumAmount = parseEther("10");
  await crowdFund.startProject(
    cUSDToken.address,
    creatorName,
    title,
    description,
    imageLink,
    durationInDays,
    amountToRaise
  );

  const projects = await crowdFund.returnProjects();
  const projectAddress = projects[0];
  const project = await ethers.getContractAt("Project", projectAddress);

  const funder = await ethers.getSigner(1);

  await cUSDToken.transfer(funder.address, 100);
  await cUSDToken.connect(funder).approve(projectAddress, 100);


  await expect(project.connect(funder).contribute(4)).to.be.revertedWith("Amount is below minimum required");
});

it("should transfer raised funds to the project creator after deadline", async function () {
  const creatorName = "Dauphine";
  const title = "New Project";
  const description = "A new project for testing";
  const imageLink = "https://github.com/aizhan-zhak/Dauphine-Digital-Economics/blob/main/img/MetaMask_Fox.svg";
  const durationInDays = 1;
  const amountToRaise = parseEther("100");

  await crowdFund.startProject(
  cUSDToken.address,
  creatorName,
  title,
  description,
  imageLink,
  durationInDays,
  amountToRaise
  );

  const projects = await crowdFund.returnProjects();
  const projectAddress = projects[0];
  const project = await ethers.getContractAt("Project", projectAddress);

  const [creator, funder1, funder2] = await ethers.getSigners();

  const amountToFund1 = 50;
  const amountToFund2 = 30;

  // Give funders some tokens
  await cUSDToken.transfer(funder1.address, 100);
  await cUSDToken.transfer(funder2.address, 100);

  // Approve funders transferring into project contract & contract paying to creator
  await cUSDToken.connect(funder1).approve(projectAddress, amountToFund1);
  await cUSDToken.connect(funder2).approve(projectAddress, amountToFund2);

  await project.connect(funder1).contribute(amountToFund1);
  await project.connect(funder2).contribute(amountToFund2);

  // Advance time by duration of Crowdfunding
  await time.increase(durationInDays*24*60*60);

  // Check project balance is correct
  expect(await project.currentBalance()).to.equal(amountToFund1 + amountToFund2);

  // Check project creator balance is correct
  const creatorBalanceBefore = await cUSDToken.balanceOf(creator.address);
  await project.payOut();
  const creatorBalanceAfter = await cUSDToken.balanceOf(creator.address);
  expect(creatorBalanceAfter.sub(creatorBalanceBefore)).to.equal(amountToFund1 + amountToFund2);
  });
})