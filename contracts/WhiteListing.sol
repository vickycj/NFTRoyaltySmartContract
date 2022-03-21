//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;



abstract contract WhiteListing  {

    bool private _onlyWhitelistedAllowed = false;
    address[] private whitelistedAddresses;

    /** Update sale status : stop or start*/
    function _whitelistUsers(address[] calldata _users) internal {
        delete whitelistedAddresses;
        whitelistedAddresses = _users;
    }

    function _setOnlyWhitelisted(bool _state) internal {
        _onlyWhitelistedAllowed = _state;
    }

    function _isOnlyWhitelisted() internal view returns (bool) {
        return _onlyWhitelistedAllowed;
    }

     /** Check if the sender is whitelisted */
    function isWhitelisted(address _user) public view returns (bool) {
        for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _user) {
                return true;
            }
        }
        return false;
    }


}