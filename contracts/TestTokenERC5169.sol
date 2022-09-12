// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

library AddressUtil {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

interface IERC5169 {
    /// @dev This event emits when the scriptURI is updated, 
    /// so wallets implementing this interface can update a cached script
    event ScriptUpdate(string newScriptURI);

    /// @notice Get the scriptURI for the contract
    /// @return The scriptURI
    function scriptURI() external view returns(string memory);
	
    /// @notice Update the scriptURI
    /// emits event ScriptUpdate(string memory newScriptURI);
    function updateScriptURI(string memory newScriptURI) external;
}

contract STLDoor is ERC721, ERC721Enumerable, Ownable, IERC5169 {
    using AddressUtil for address;
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter public _tokenIdCounter;

    string private _scriptURI;
    string private _tokenURI = "ipfs://QmZfmPu4riw9BqmUe8SejhJRKw5xRu78JhvYEDuYqBqeFu";

    constructor() ERC721("Message Token", "MSG") {
        _tokenIdCounter.increment();
        mintUsingSequentialTokenId(); 
    }

    function contractURI() public pure returns (string memory) {
        return "ipfs://QmV1tKJFLrx3Rxe7U4aYuHxwBTx8gurQUwaCro5tCJFJv8"; 
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "tokenURI: URI query for nonexistent token");
        return _tokenURI;
    }

    function scriptURI() public view override returns (string memory) {
        return _scriptURI;
    }

    function updateScriptURI(string memory newScriptURI) public override onlyOwner {
        _scriptURI = newScriptURI;
        emit ScriptUpdate(newScriptURI);
    }

    function setTokenURI(string memory newTokenURI) public onlyOwner {
        _tokenURI = newTokenURI;
    }
    
    function mintUsingSequentialTokenId() public onlyOwner returns (uint256 tokenId) {
        tokenId = _tokenIdCounter.current();
        _mint(msg.sender, tokenId);
        _tokenIdCounter.increment();
    }

    function burnToken(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "burn: nonexistent token");
        _burn(tokenId);
    }

    // Only allow owners to transfer tokens
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override(ERC721, IERC721) onlyOwner {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyOwner {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function selfDestruct() public payable onlyOwner {
        selfdestruct(payable(owner()));
    }
}
