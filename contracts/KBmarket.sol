//SPDX-License-Identifier: MIT
pragma Solidity ^0.7.3;

import '@openzepplin/contract/token/ERC721/ERC721.sol';
import '@openzepplin/contracts/security/ReentrancyGuard.sol';
import '@openzepplin/contracts/utils/Counters.sol';

//security against transactions for multiple requests 

import 'hardhat/console.sol';

contract KBmarket is ReentrancyGuard {
    using Counters for Counters.Counters;

    // number of items, number of transactions, tokens that have not been sold
    //keep trck of total numbers -- tolen id 
    // keep track of tokens 
    // arrays need to know the length - help to keep travk for arrays

    Counters.Counters private _tokenIds;
    Counters.Counters private _tokenSold;

    // determine who is the owner of the contrct
    // charging a listing fee for the market

    address payable owner; // var_data_type var_funcType var_name
    //listing in eth 
    uint256 listingPrice = 0.045 ether;

    //setting the owner of the contract

    constructor(){
        //set the owner
        owner = payable(msg.sender);
        }

    //setting up an objects in the form of a struct

    struct MarketToken {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    //tokenId to return which market token (TokenItem)

    mapping(uint256 => MarketToken) private idToMarketToken;

   // events --- emitt blockcain info can be used in the client side app dor somethig 

    event MarketTokenMinted(
        unit indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    // funx to show the listing price 

    function getListingPrice() public view returns(uint256){
        return listingPrice;
    }

    // creating 2 funx to interact with the smartcontract
    //1. creating a market item to put up for sale 
    //2. create a market sale for buyinf and selling between parties

    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint price
    )
    public payable nonReentrant{
        //reenterering of smart contract can favor attackers and drain the contract of ether
        // it is a modifier to prevent reenty atck
        require(price>0, 'Price must be above 1 Wei');
        require(msg.value == listingPrice, 'Price must be equal to the listing price');

        _tokenIds.increment();
        uint itemId = _tokenIds.current();

        // putting up for sale 
        // changing the bool flag to false and initialisi g a market token object
        idToMarketToken[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender), //seller is the person who minted
            payable(address(0)),
            price,
            false
        );
        // nft transfer function -  used to transfer tokens that u own to some other address 
        // transfer from function is used to transfer tokens that u dont own 
        // but have authority to spend to address 
        // format is (sneder address, wher sendingn, token id)
        IERC72(nftContract).transferFrom(msg.sender, address(this), tokenId);

        // emit comes after event now the event emits

        emit MarketTokenMinted(
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address(0), // used when minting 
        price,
        false
        );

        // function to conduct transactions and market sales

        // function to fetchMarketItems
    } 
    function createMarketSale(
        address nftContd = idToMarketToken[itemId].price;
            require(msg.value == price,'Please submit asking price');

            // transfer amount to seller kesh
            idToMarketToken[itemId].seller.transfer(msg.value);

            // transfer the token from the contract address to the buyer 
            IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
ract,
        uint itemId) public payable nonReentrant {
            uint price = idToMarketToken[itemId].price;
            uint tokenI
            // chaging the property to true 

            idToMarketToken[itemId].owner = payable(msg.sender);
            idToMarketToken[itemId].sold = true;
            _tokenSold.increment();

            payable(owner).transfer(listingPrice);
            
        }
       
}