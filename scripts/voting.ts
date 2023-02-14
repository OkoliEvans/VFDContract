import { ethers } from "hardhat";

async function main() {
    const [owner, acct1] = await ethers.getSigners();

    const VotingSystem = await ethers.getContractFactory("VotingDAO");

    const votingSystem = await VotingSystem.deploy("RoxDAO", "RXS");
    // console.log("Hello world");
    await votingSystem.deployed();
    console.log(`Contract address for VotingDAO is ${votingSystem.address}`);


    const minter = await votingSystem.mint(1000000);
    
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  