const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Token = await ethers.getContractFactory("MToken");
    const token = await Token.deploy();
  
    console.log("Token address:", token.address);

    const HumanNFT = await ethers.getContractFactory("HumanNFT");
    const humanNFT = await HumanNFT.deploy(token.address);

    console.log("NFT address:", humanNFT.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });