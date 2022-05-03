const { expect, config } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require('@ethersproject/bignumber')



describe("Deployment of contracts", async ()=>{
    let mToken, humanNFT, floorPrice=200
    let uri = 'https://gateway.pinata.cloud/ipfs/QmQsSBFheoL1waMskRPqS1etqbGPA9pXukupJMKbDpTqG3'


    it('MToken Deploy', async ()=>{
        const MToken = await ethers.getContractFactory("MToken")
        mToken = await MToken.deploy()
        await mToken.deployed()
    })


    it('Market Deploy', async()=>{
        const HumanNFT = await ethers.getContractFactory('HumanNFT')
        humanNFT = await HumanNFT.deploy(mToken.address)
        await humanNFT.deployed()
    })


    it('Set URI', async()=>{
        await humanNFT.setURI(['https://gateway.pinata.cloud/ipfs/QmQsSBFheoL1waMskRPqS1etqbGPA9pXukupJMKbDpTqG3','https://gateway.pinata.cloud/ipfs/Qmc7nRRArAGM5VChVJ3n6QdigvPz5MAABaNGPZ6uz1a1fv'])
    })


    it('Approve market contract to transfer tokens', async()=>{
        const [addr1,addr2] = await ethers.getSigners()
        await mToken.approve(humanNFT.address, floorPrice)
        expect(await mToken.allowance(addr1.address, humanNFT.address)).to.equal(floorPrice)
    })


    it('Send Token & Mint NFT', async()=>{
        const [addr1, addr2, addr3] = await ethers.getSigners()
        await humanNFT.flipSale()
        await humanNFT.buyNftWithToken()
        expect(await humanNFT.balanceOf(addr1.address)).to.equal(1)

    })


    it('Check minted NFT URI mapping', async()=>{
        expect(await humanNFT.tokenURI(1)).to.equal(uri)
    })


    it('Sell NFT', async()=>{
        const [addr1, addr2, addr3] = await ethers.getSigners()
        await humanNFT.sellNFT(1)
        expect(await humanNFT.ownerOf(1)).to.equal(humanNFT.address)
    })


})