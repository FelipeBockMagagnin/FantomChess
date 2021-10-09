pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FantomChess is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address payable public depositAddress = payable(0xFc3778f4b877B25A2A6B501a6Bd987bB6B43F7e0);
    uint256 public maxMintable = 500;

    constructor() ERC721("FantomChess", "CHESS") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/";
    }

    function setDepositAddress(address payable to) public onlyOwner {
        depositAddress = to;
    }

    function claim(string memory metadataURI) public payable {
        uint256 id = _tokenIdCounter.current();
        uint256 price = 25 ether;

        require(msg.value == price, "Invalid amount");
        require(id < (maxMintable - 1), "No more Chess Games are available");

        // transfer amount to owner
        depositAddress.transfer(price);

        _safeMint(msg.sender, id);
        _setTokenURI(id, metadataURI);

        _tokenIdCounter.increment();
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}