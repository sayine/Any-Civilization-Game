// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";
import '../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract XenJacket is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address => bool) public alreadyMinted;
    mapping(address => bool) public whitelisted;

    uint256 private maxSupply1 = 49;
    uint256 private maxSupply2 = 99;
    uint256 private maxSupply3 = 149;
    uint256 private maxSupply4 = 199;
    uint256 private maxSupply5 = 249;
    uint256 private maxSupply6 = 299;
    uint256 private maxSupply7 = 349;
    uint256 private maxSupply8 = 399;
    uint256 private maxSupply9 = 449;
    uint256 private maxSupply10 = 499;
    uint256 private maxSupply11 = 549;
    uint256 private maxSupply12 = 599;
    uint256 private maxSupply13 = 649;
    uint256 private maxSupply14 = 699;
    uint256 private maxSupply15 = 749;
    uint256 private maxSupply16 = 799;
    uint256 private maxSupply17 = 849;
    uint256 private maxSupply18 = 899;
    uint256 private maxSupply19 = 949;
    uint256 private maxSupply20 = 999;
    uint256 private maxSupply21 = 1049;
 
    uint256 public tokenId1 = 0;
    uint256 public tokenId2 = 50;
    uint256 public tokenId3 = 100;
    uint256 public tokenId4 = 150;
    uint256 public tokenId5 = 200;
    uint256 public tokenId6 = 250;
    uint256 public tokenId7 = 300;
    uint256 public tokenId8 = 350;
    uint256 public tokenId9 = 400;
    uint256 public tokenId10 = 450;
    uint256 public tokenId11 = 500;
    uint256 public tokenId12 = 550;
    uint256 public tokenId13 = 600;
    uint256 public tokenId14 = 650;
    uint256 public tokenId15 = 700;
    uint256 public tokenId16 = 750;
    uint256 public tokenId17 = 800;
    uint256 public tokenId18 = 850;
    uint256 public tokenId19 = 900;
    uint256 public tokenId20 = 950;
    uint256 public tokenId21 = 1000;

    bool public isLaunched = false;

    constructor() ERC721("Assemble Series", "XEN") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://anycivilization.com/asnm/";
    }

    function safeGMint1(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId1 <= maxSupply1, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId1);
        _setTokenURI(tokenId1, uri);
        tokenId1 +=1;
    }

    function safeGMint2(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId2 <= maxSupply2, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId2);
        _setTokenURI(tokenId2, uri);
        tokenId2 +=1;
    }

    function safeGMint3(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId3 <= maxSupply3, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId3);
        _setTokenURI(tokenId3, uri);
        tokenId3 +=1;
    }

    function safeGMint4(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId4 <= maxSupply4, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId4);
        _setTokenURI(tokenId4, uri);
        tokenId4 +=1;
    }

    function safeGMint5(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId5 <= maxSupply5, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId5);
        _setTokenURI(tokenId5, uri);
        tokenId5 +=1;
    }

    function safeGMint6(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId6 <= maxSupply6, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId6);
        _setTokenURI(tokenId6, uri);
        tokenId6 +=1;
    }

    function safeGMint7(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId7 <= maxSupply7, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId7);
        _setTokenURI(tokenId7, uri);
        tokenId7 +=1;
    }

    function safeGMint8(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId8 <= maxSupply8, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId8);
        _setTokenURI(tokenId8, uri);
        tokenId8 +=1;
    }

    function safeGMint9(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId9 <= maxSupply9, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId9);
        _setTokenURI(tokenId9, uri);
        tokenId9 +=1;
    }

    function safeGMint10(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId10 <= maxSupply10, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId10);
        _setTokenURI(tokenId10, uri);
        tokenId10 +=1;
    }

    function safeGMint11(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId11 <= maxSupply11, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId11);
        _setTokenURI(tokenId11, uri);
        tokenId11 +=1;
    }

    function safeGMint12(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId12 <= maxSupply12, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId12);
        _setTokenURI(tokenId12, uri);
        tokenId12 +=1;
    }

    function safeGMint13(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId13 <= maxSupply13, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId13);
        _setTokenURI(tokenId13, uri);
        tokenId13 +=1;
    }

    function safeGMint14(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId14 <= maxSupply14, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId14);
        _setTokenURI(tokenId14, uri);
        tokenId14 +=1;
    }

    function safeGMint15(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId15 <= maxSupply15, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId15);
        _setTokenURI(tokenId15, uri);
        tokenId15 +=1;
    }

    function safeGMint16(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId16 <= maxSupply16, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId16);
        _setTokenURI(tokenId16, uri);
        tokenId16 +=1;
    }

    function safeGMint17(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId17 <= maxSupply17, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId17);
        _setTokenURI(tokenId17, uri);
        tokenId17 +=1;
    }

    function safeGMint18(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId18 <= maxSupply18, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId18);
        _setTokenURI(tokenId18, uri);
        tokenId18 +=1;
    }

    function safeGMint19(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId19 <= maxSupply19, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId19);
        _setTokenURI(tokenId19, uri);
        tokenId19 +=1;
    }

    function safeGMint20(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId20 <= maxSupply20, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId20);
        _setTokenURI(tokenId20, uri);
        tokenId20 +=1;
    }    

    function safeGMint21(string memory uri) payable public whenLaunched nonReentrant {
        require(msg.value == (0.05 ether), "Wrong Fee");
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        require(tokenId21 <= maxSupply21, "Sold Out");
        alreadyMinted[msg.sender] = true;
        _safeMint(msg.sender, tokenId21);
        _setTokenURI(tokenId21, uri);
        tokenId21 +=1;
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

  function tokenURI(uint256 _tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
    require(_exists(_tokenId), "Non-existent token given!");

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), ".json"))
        : "";
  }

    function withdraw() onlyOwner public returns (bool) {
      payable(msg.sender).transfer(address(this).balance);
      return true;
    }

    function setLaunched() onlyOwner public {
        isLaunched = true;
    }
    modifier whenLaunched() {
      require(isLaunched == true);
      _;
    }
}