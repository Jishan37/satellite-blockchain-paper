// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract SatelliteERC1155 is ERC1155 {
    address[] public validators; // PoA validators (e.g., ground stations/satellites)
    mapping(uint256 => string) private _tokenURIs; // Stores encrypted ECIES metadata

    modifier onlyValidator() {
        bool isValidator = false;
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == msg.sender) {
                isValidator = true;
                break;
            }
        }
        require(isValidator, "Caller is not a validator");
        _;
    }

    constructor(address[] memory _validators) ERC1155("") {
        validators = _validators;
    }

    /
    function tokenizeData(
        bytes[] calldata encryptedChunks,
        uint256 tokenId,
        string calldata metadataURI
    ) external onlyValidator {
        for (uint i = 0; i < encryptedChunks.length; i++) {
            _mint(msg.sender, tokenId + i, 1, ""); // Mint 1 token per chunk
            _tokenURIs[tokenId + i] = string(abi.encodePacked(metadataURI, "#chunk=", Strings.toString(i)));
        }
    }


    function uri(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }
}
