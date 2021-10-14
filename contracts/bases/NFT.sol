pragma solidity ^0.5.4;
import "../libraries/ERC721.sol";

contract NFT is ERC721, ERC721Enumerable, ERC721Metadata {
    event NewERC721Info(string Name, string Symbol);
    event NewERC721TokenInfo(string Name, string Symbol, uint256 Id, string Uri, address Creator);
    event RemoveSmallFile(uint256 TokenId, address Owner, address RemovedBy);
    event LinkTokenWithTree(uint256 TokenId, address Tree);
    event CreateNewTree(bytes32 InitalRoot, address Tree);

    mapping(uint256 => address) private _treeOfToken;

    constructor (string memory _name, string memory _symbol) public ERC721Metadata(_name, _symbol) {
        emit NewERC721Info(_name, _symbol);
    }

    function createNewERC721Token(string memory _uri) public returns(uint256) {
        uint256 id = totalSupply();
        super._mint(tx.origin, id);
        super._setTokenURI(id, _uri);

        string memory _name = name();
        string memory _symbol = symbol();

        emit NewERC721TokenInfo(_name, _symbol, id, _uri, tx.origin);
        return id;
	
    }
    
    function removeAsset(uint256 tokenId) public {
        require(tx.origin == ownerOf(tokenId) || tx.origin == getApproved(tokenId));
        super._burn(tokenId);
        emit RemoveSmallFile(tokenId, ownerOf(tokenId), tx.origin);
    }
}