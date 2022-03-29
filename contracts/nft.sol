//SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;

// bringing the ERC721 NFT CONTRACT

import '@openzepplin/contracts/token/ERC721/ERC721.sol';
import '@openzepplin/contracts/token/ERC721/extensions/ERC721URISTORAGE.sol';
import '@openzepplin/contracts/utils/Counters.sol';
 
contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counters private _tokenIds;

    // counters used for tracking all token ids

    // address of the marketplace
    address contractAddress;

    // to-do give the market place to transcat with tokens or change ownership
    // setApproval for all -> ERC 721 func that lets us do all

    // constructor set up our address

    //below constructor is our, the ERC721 is constructor of erc multipe inheritance 
    constructor(address marketpalceAddress) ERC721('LedZepellin','LEDZEP'){
        contractAddress = marketpalceAddress;
    }

    function mintToken(string memory tokenURI) public returns(uint) {
        _tokenIds.increment();
        unit256 newItemId = tokenIds.current();
        _mint(msg.sender, newitemId);
        //setting imge URI
        _setTokenURI(newItemId, tokenURI);
        //giving marketplace the approval to transact between users
        setApprovlForAll(contractAddress, true);
        //tokrn mined and set]for sale on marketplace
        return newItemId;
    }
    
}
