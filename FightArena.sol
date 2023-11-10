// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract FightArena is ERC721, ReentrancyGuard, VRFConsumerBaseV2, ConfirmedOwner {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled;
        bool exists;
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests;
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId;
    uint256[] public requestIds;
    uint256 public lastRequestId;

    bytes32 keyHash =
        0x354d2f95da55398f44b7cff77da56283d9c6c829a4bdf1bbcaf2ad6a4d081f61;
    uint32 callbackGasLimit = 100000;

    uint16 requestConfirmations = 3;

    uint32 numWords = 3;

    constructor(
        uint64 subscriptionId
    ) ERC721("Fight Arena", "Fighter")
        VRFConsumerBaseV2(0x2eD832Ba664535e5886b75D64C46EB9a228C2610)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(
            0x2eD832Ba664535e5886b75D64C46EB9a228C2610
        );
        s_subscriptionId = subscriptionId;

        weather[0] = [12, 11, 8];
        weather[1] = [8, 12, 10];
        weather[2] = [7, 10, 12];
        weather[3] = [10, 14, 12];

        area[0] = [12, 8, 10];
        area[1] = [10, 13, 12];
        area[2] = [12, 11, 8];

        floor[0] = [14, 11, 8];
        floor[1] = [12, 14, 7];
        floor[2] = [10, 12, 14];
    }

    
    function requestRandomWords()
        internal
        returns (uint256 requestId)
    {
        
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(
        uint256 _requestId
    ) public view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    mapping(address => bool) public alreadyMinted;
    mapping(address => uint) public addressToTokenId;

    mapping(uint => uint[]) public weather;
    mapping(uint => uint[]) public area;
    mapping(uint => uint[]) public floor;

    mapping(uint => bool) public activeFight;

    uint ownerBalance;

    struct Fighter {
        uint id;
        string name;
        uint fightCounter;
        uint winCounter;
    }
    Fighter [] public fighter;

    struct Fight {
        uint id;
        uint fightValue;
        bool isActive;
        uint[3] fighter1Moves;
        uint[3] fighter2Moves;
        address fighter1;        
        address fighter2;
    }
    Fight[] public fight;
    
    function mintFighter(string memory name) nonReentrant payable external returns (uint){
        require(alreadyMinted[msg.sender] == false, "Already Minted");
        alreadyMinted[msg.sender] = true;
        uint256 newId = _tokenIds.current();
        fighter.push(Fighter(newId, name, 0, 0));
        _safeMint(msg.sender, newId);
        addressToTokenId[msg.sender] = newId;
        _tokenIds.increment();
        return newId;
    }

    mapping(uint => uint) public reqId;

    function createFight(address _fighter1, uint move1, uint move2, uint move3) payable external returns (bool) {
        require(ownerOf(addressToTokenId[_fighter1]) == msg.sender, "NO");
        require(msg.value > 0.01 ether, "Fight Value Required");
        require((move1 + move2 + move3) == 100, "Must be 100");
        reqId[fight.length] = requestRandomWords();
        activeFight[fight.length] = true;
        fight.push(Fight(fight.length, msg.value, true, [move1, move2, move3], [move1, move2, move3], _fighter1, 0x0000000000000000000000000000000000000000));
        return true;
    }

    uint F1agiW;
    uint F1conW;
    uint F1strW;
    
    uint F1agiA;
    uint F1conA;
    uint F1strA;
              
    uint F1agiF;
    uint F1conF;
    uint F1strF;
              
    uint F2agiW;
    uint F2conW;
    uint F2strW;
              
    uint F2agiA;
    uint F2conA;
    uint F2strA;
              
    uint F2agiF;
    uint F2conF;
    uint F2strF;

    uint F1RoundWin;
    uint F2RoundWin;

    function joinAndFight(uint fightId, uint move1, uint move2, uint move3) nonReentrant payable external returns(address winner) {
        require(balanceOf(msg.sender)  > 0, "NO");
        require(msg.value == fight[fightId].fightValue);
        require(fight[fightId].isActive == true);
        require((move1 + move2 + move3) == 100, "Must be 100");
        ownerBalance += (msg.value * 10) / 100;
        fight[fightId].fighter2 = msg.sender;
        fight[fightId].fighter2Moves = [move1, move2, move3];
        fight[fightId].isActive = false;
        activeFight[fight.length] = false;
        uint F1Move1 = fight[fightId].fighter1Moves[0];
        uint F1Move2 = fight[fightId].fighter1Moves[1];
        uint F1Move3 = fight[fightId].fighter1Moves[2];
        
        (bool fulfilled, uint256[] memory randomWords) = getRequestStatus(reqId[fightId]);
        if (fulfilled == true) {
            uint W = randomWords[0] % 4;
            uint A = randomWords[1] % 3;
            uint F = randomWords[2] % 3;

            F1agiW = weather[W][0] * F1Move1;
            F1conW = weather[W][1] * F1Move2;
            F1strW = weather[W][2] * F1Move3;
            
            F1agiA = area[A][0] * F1Move1;
            F1conA = area[A][1] * F1Move2;
            F1strA = area[A][2] * F1Move3;

            F1agiF = floor[F][0] * F1Move1;
            F1conF = floor[F][1] * F1Move2;
            F1strF = floor[F][2] * F1Move3;

            F2agiW = weather[W][0] * move1;
            F2conW = weather[W][1] * move2;
            F2strW = weather[W][2] * move3;
            
            F2agiA = area[A][0] * move1;
            F2conA = area[A][1] * move2;
            F2strA = area[A][2] * move3;

            F2agiF = floor[F][0] * move1;
            F2conF = floor[F][1] * move2;
            F2strF = floor[F][2] * move3;

            if(F1agiW + F1conW + F1strW >= F2agiW + F2conW + F2strW) {
                F1RoundWin += 1;
            } else {F2RoundWin + 1;}
            if(F1agiA + F1conA + F1strA >= F2agiA + F2conA + F2strA) {
                F1RoundWin += 1;
            } else {F2RoundWin += 1;}
            if(F1agiF + F1conF + F1strF >= F2agiF + F2conF + F2strF) {
                F1RoundWin += 1;
            } else {F2RoundWin += 1;}
        }

            if(F1RoundWin > F2RoundWin) {
                fighter[addressToTokenId[fight[fightId].fighter1]].winCounter += 1;
                winner = fight[fightId].fighter1;
            } else {
                fighter[addressToTokenId[fight[fightId].fighter2]].winCounter += 1;
                winner = fight[fightId].fighter2;}

        fighter[addressToTokenId[fight[fightId].fighter1]].fightCounter += 1;
        fighter[addressToTokenId[fight[fightId].fighter2]].fightCounter += 1;
        payable(winner).transfer((fight[fightId].fightValue * 19) / 10);
        return winner;
    }

    function getActiveFight(uint _fightId) public view returns (bool) {
        bool active = activeFight[_fightId];
        return active;
    }

    function withdraw() onlyOwner public returns (bool) {
      payable(msg.sender).transfer(ownerBalance);
      return true;
    }
}