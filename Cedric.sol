// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CedricLegacy is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address nonToken = 0x3A4f3CB61E868df8EBF2B5d929928Af43A892608;
    address stamp = 0x92984B1bE341f0317E70d5743DAF37a630dF8501;
    address appearence = 0xaF340029C67C3DE40cdB5E20c2691f56998b86a7;
    address voidPass = 0x709C591c7A7BE93B0F0020C82667f1eCeaBf2792;
    address goldenKnuckleDuster = 0xc3ECC683b57a3219187A2994BD96fE7aFBf6d92C;

    mapping(address => uint) public addressToTokenId;

    struct Cedric {
        uint id;
        uint missionNumber;
        uint missionActivated;
        uint gameStartTime;
        uint missionStartTime;
    }
    Cedric [] public cedric;

    constructor() ERC721("Cedric Legacy", "Cedric") {}

    function mintCedric() nonReentrant payable external returns (uint){
        require(msg.value >= 2 ether, "Payment required");
        uint256 newId = _tokenIds.current();
        require(newId < 1000, "Sold Out");
        cedric.push(Cedric(newId, 0, 0, 0, 0));
        _safeMint(msg.sender, newId);
        addressToTokenId[msg.sender] = newId;
        _tokenIds.increment();
        return newId;
    }

    function startMission0(uint _id) nonReentrant external returns (bool) {
        require(addressToTokenId[msg.sender] == _id, "You are not the owner");
        require(cedric[_id].missionNumber == 0, "Already done!");
        INonToken(nonToken).transferFrom(msg.sender, address(this), 500000 * 10 ** 18);
        cedric[_id].missionStartTime = block.timestamp;
        cedric[_id].gameStartTime = block.timestamp;
        cedric[_id].missionActivated = 1;
        return true;
    }

    function startMission(uint _id) nonReentrant external returns (bool) {
        require(addressToTokenId[msg.sender] == _id, "You are not the owner");
        require(cedric[_id].missionNumber != 0, "First thing first!");
        if(cedric[_id].missionNumber % 2 == 0) {
            require((block.timestamp - cedric[_id].gameStartTime) >= 300 * (cedric[_id].missionNumber / 2), "Day!");
            INonToken(nonToken).transferFrom(msg.sender, address(this), 500000 * 10 ** 18);
            cedric[_id].missionStartTime = block.timestamp;
            cedric[_id].missionActivated = 1;
        } else {
            INonToken(nonToken).transferFrom(msg.sender, address(this), 500000 * 10 ** 18);
            cedric[_id].missionStartTime = block.timestamp;
            cedric[_id].missionActivated = 1;
        }
        return true;
    }

    function endMission(uint _id) nonReentrant external returns (bool) {
        require(addressToTokenId[msg.sender] == _id, "You are not the owner");
        require(cedric[_id].missionActivated == 1, "Not on active mission");
        require((block.timestamp - cedric[_id].missionStartTime) >= 30, "Time!"  );
        if(cedric[_id].missionNumber == 1){
            cedric[_id].missionNumber += 1;
            SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, 502500 * 10 ** 18);
            IStamp(stamp).mintStamp(msg.sender);
            cedric[_id].missionActivated = 0;
        }else if (cedric[_id].missionNumber == 24) {
            cedric[_id].missionNumber += 1;
            SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, 502500 * 10 ** 18);
            IAppearence(appearence).mintAppearence(msg.sender);
            cedric[_id].missionActivated = 0;
        }else if (cedric[_id].missionNumber == 39) {
            cedric[_id].missionNumber += 1;
            SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, 502500 * 10 ** 18);
            IVoidPass(voidPass).mintVoidPass(msg.sender);
            cedric[_id].missionActivated = 0;
        }else if (cedric[_id].missionNumber == 47) {
            cedric[_id].missionNumber += 1;
            SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, 502500 * 10 ** 18);
            IGoldenKnuckleDuster(goldenKnuckleDuster).mintGoldenKnuckleDuster(msg.sender);
            cedric[_id].missionActivated = 0;
        }else {
            cedric[_id].missionNumber += 1;
            SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, 502500 * 10 ** 18);
            cedric[_id].missionActivated = 0;
        }
        return true;
    }

    function setAddress(address non, address _stamp, address _appearence, address _voidPass, address _goldenKnuckleDuster) onlyOwner public returns(bool) {
        nonToken = non;
        stamp = _stamp;
        appearence = _appearence;
        voidPass = _voidPass;
        goldenKnuckleDuster = _goldenKnuckleDuster;
        return true;
    }

    function withdraw() onlyOwner public returns (bool) {
        payable(msg.sender).transfer(address(this).balance);
        return true;
    }

    function withdrawNonToken(uint amount) onlyOwner public returns (bool) {
        SafeERC20.safeTransfer(IERC20(nonToken), msg.sender, amount);
        return true;
    }

}

    interface INonToken {
        function transferFrom(address from, address to, uint256 amount) external returns (bool);
    }
    interface IStamp {
        function mintStamp(address to) external returns (uint);
    }
    interface IAppearence {
        function mintAppearence(address to) external returns (uint);
    }
    interface IVoidPass {
        function mintVoidPass(address to) external returns (uint);
    }
    interface IGoldenKnuckleDuster {
        function mintGoldenKnuckleDuster(address to) external returns (uint);
    }