# Marketplace_NFT
Buy NFT with ERC20 token

Deploy-
1. npm install
2. npx hardhat clean
3. npx hardhat compile
4. npx hardhat run scripts/deploy.js --network kovan

You have two deployments, one being ERC20 token and other is NFT Marketplace.

To be able to trade on NFT marketplace make sure
1. The owner calls the flipSale() function
2. The buyer would have to approve() the NFT marketplace contract from the ERC20 contract to be the spender

Testing-
1. npm install
2. npx hardhat clean
3. npx hardhat compile
4. npx hardhat test


