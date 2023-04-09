// SPDX-License-Identifier: GNU
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Profile is ERC721Enumerable, Ownable, EIP712 {
    string private _baseUri;
    mapping(uint256 => bytes32) public merkleRoots;

    bytes32 constant UPDATE_MERKLE_ROOT_TYPES_HASH = keccak256("Update(uint256 tokenId, bytes32 merkleRoot)");

    constructor(string memory baseUri, string memory name, string memory symbol) ERC721(name, symbol) EIP712("Profile", "0.0.1") {
        _baseUri = baseUri;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    function _beforeTokenTransfer(address from, address, uint256, uint256) internal pure override {
        require(from == address(0), "Transfer is not allowance");
    }

    function mint(address[] memory users, uint256[] memory tokenIds, bytes32[] memory initMerkleRoots) external onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            require(balanceOf(users[i]) == 0, "Only one NFT per user");
            merkleRoots[tokenIds[i]] = initMerkleRoots[i];
            _safeMint(users[i], tokenIds[i]);
        }
    } 

    function getSignMessage(uint256 tokenId, bytes32 merkleRoot) public view returns(bytes32) {
        return _hashTypedDataV4(
            keccak256(abi.encode(
                UPDATE_MERKLE_ROOT_TYPES_HASH,
                tokenId,
                merkleRoot
            ))
        );
    }

    function updateMerkleRoot(uint256 tokenId, bytes32 merkleRoot, bytes memory signature) external {
        bytes32 digest = getSignMessage(tokenId, merkleRoot);
        require(ownerOf(tokenId) == ECDSA.recover(digest, signature), "Invalid Signature");

        merkleRoots[tokenId] = merkleRoot;
    }

    function verifyData(uint256 tokenId, bytes32 data, bytes32[] memory proof) external view returns(bool) {
        return MerkleProof.verify(proof, merkleRoots[tokenId], data);
    }
}
