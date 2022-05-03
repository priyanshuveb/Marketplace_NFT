// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

//import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol';


contract HumanNFT is ERC721Holder, ERC721URIStorage, Ownable {

    IERC20 public erc20Token;

    bool public saleIsActive;

    uint public MAX_HUMAN_NFT = 1000;

    uint private _floorPrice = 20*1e18;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string[] private _tokenURI;

    mapping(uint => uint) private _tokenToAmount;

    constructor(IERC20 _erc20Token) ERC721("HUMAN","HMN") {
        erc20Token = _erc20Token;
    }


    function getFloorPrice() view public returns(uint) {
        return _floorPrice;
    }

    function updateFloorPrice(uint newPrice) public onlyOwner returns(uint){
        _floorPrice = newPrice;
        return _floorPrice;
    }

    function setURI(string[] memory tokenURI_) public onlyOwner {
        _tokenURI  = tokenURI_;
    }


    function buyNftWithToken() public {
        require(saleIsActive,'NFT sale is on hold');
        require(_tokenIds.current()<MAX_HUMAN_NFT, 'Maximum NFT minting limit has reached');
        require(erc20Token.balanceOf(msg.sender)>=_floorPrice, 'Not enough tokens');
        erc20Token.transferFrom(msg.sender,address(this), _floorPrice);
        mintNFT(msg.sender);
    }

    // function setBaseURI(string uri) public onlyOwner{
    //     super
    // }

    function mintNFT(address recipient) internal returns(uint){
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, _tokenURI[newItemId-1]);
        _tokenToAmount[newItemId] = _floorPrice;
        return newItemId;
    }

    function flipSale() public onlyOwner returns(bool){
        saleIsActive= !saleIsActive;
        return saleIsActive;
    }

    function sellNFT(uint id) public {
        uint amount = _tokenToAmount[id];
        _tokenToAmount[id]=0;
        erc20Token.transfer(msg.sender,amount);
        safeTransferFrom(msg.sender, address(this), id);
    }

    function claim(address recipient) public onlyOwner{
        uint amount = erc20Token.balanceOf(address(this));
        erc20Token.transfer(recipient, amount);
    }

}
