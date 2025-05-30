// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract ManualToken {
    mapping(address => uint256) private _balances;

    function name() public pure returns (string memory) {
        return "TokenName";
    }

    function supply() public pure returns (uint256) {
        return 100 ether; // 100 * 10^18
    }

    function decimal() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        uint256 initialBalance = balanceOf(msg.sender) + _value;
        _balances[_to] += _value;
        _balances[msg.sender] = initialBalance - _value;
        return true;
    }
}
