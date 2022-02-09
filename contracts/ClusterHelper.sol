// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

import '@openzeppelin/contracts/access/Ownable.sol';

contract ClusterHelper is Ownable {

    address private _owner;
    address private _ctzn;
    address private _clstr;
    uint public AvgCSkills; 
    uint public AvgMSkills; 
    uint public AvgSSkills;

    struct ClusterProductivity {
        uint AggSkills;
        uint AggCSkills; uint AggMSkills; uint AggSSkills; 
        uint modifiedCSkill; uint avgmodifiedCSkill;
        uint modifiedMSkill; uint avgmodifiedMSkill;
        uint modifiedSSkill; uint avgmodifiedSSkill;
    }
    ClusterProductivity[] public clusterProductivity;

    constructor() {
        _owner = msg.sender;
    }
        
    function ProductivityOfCluster(uint _idCluster) external returns(uint) {
        uint AggSkill; uint AggCSkill; uint AggMSkill; uint AggSSkill; 

        for(uint i = 0; i < ICluster(_clstr).clusterPopulation(_idCluster); i++){
            (,,,AggSkill) = ICitizenH(_ctzn).getCitizenSkills(ICluster(_clstr).getCitizensOfCluster(_idCluster, i));
            clusterProductivity[_idCluster].AggSkills += AggSkill;
            (,,AggCSkill,) = ICitizenH(_ctzn).getCitizenSkills(ICluster(_clstr).getCitizensOfCluster(_idCluster, i));
            clusterProductivity[_idCluster].AggCSkills += AggCSkill;
            (,AggMSkill,,) = ICitizenH(_ctzn).getCitizenSkills(ICluster(_clstr).getCitizensOfCluster(_idCluster, i));
            clusterProductivity[_idCluster].AggMSkills += AggMSkill;
            (AggSSkill,,,) = ICitizenH(_ctzn).getCitizenSkills(ICluster(_clstr).getCitizensOfCluster(_idCluster, i));
            clusterProductivity[_idCluster].AggSSkills += AggSSkill;
        }

        clusterProductivity[_idCluster].modifiedCSkill = clusterProductivity[_idCluster].AggCSkills * 10000;
        clusterProductivity[_idCluster].modifiedMSkill = clusterProductivity[_idCluster].AggMSkills * 10000;
        clusterProductivity[_idCluster].modifiedSSkill = clusterProductivity[_idCluster].AggSSkills * 10000;

        clusterProductivity[_idCluster].avgmodifiedCSkill = clusterProductivity[_idCluster].modifiedCSkill / clusterProductivity[_idCluster].AggSkills;
        clusterProductivity[_idCluster].avgmodifiedMSkill = clusterProductivity[_idCluster].modifiedMSkill / clusterProductivity[_idCluster].AggSkills;
        clusterProductivity[_idCluster].avgmodifiedSSkill = clusterProductivity[_idCluster].modifiedSSkill / clusterProductivity[_idCluster].AggSkills;  

        AvgCSkills = clusterProductivity[_idCluster].avgmodifiedCSkill % 1000;
        AvgMSkills = clusterProductivity[_idCluster].avgmodifiedMSkill % 1000;
        AvgSSkills = clusterProductivity[_idCluster].avgmodifiedSSkill % 1000;

        uint diffC = AvgCSkills - 333;
        uint diffM = AvgMSkills - 333;
        uint diffS = AvgSSkills - 333;

        uint aggDiff = diffC + diffM + diffS;
        uint Productivity = 10000 - aggDiff;
        
        return Productivity;
    }
        function setAddresses(address AnyCluster, address AnyCitizen) onlyOwner public {
        _clstr = AnyCluster;
        _ctzn = AnyCitizen;
    }
}
    interface ICitizenH {
        function getCitizenSkills(uint _id) external view returns(uint sSkill, uint mSkill, uint cSkill, uint aggSkill);
    }
    interface ICluster {
        function getCitizensOfCluster(uint _idCluster, uint _idCitizen) external view returns(uint);
        function clusterPopulation(uint _idCluster) external view returns(uint);
    }