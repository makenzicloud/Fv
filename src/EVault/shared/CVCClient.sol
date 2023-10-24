// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity ^0.8.0;

import {Storage} from "./Storage.sol";
import {Events} from "./Events.sol";
import {Errors} from "./Errors.sol";

import {IERC20} from "../IEVault.sol";
import {ICVC} from "euler-cvc/interfaces/ICreditVaultConnector.sol";

abstract contract CVCClient is Storage, Events, Errors {
    ICVC immutable cvc;
    uint8 constant BATCH_DEPTH_INIT = 1;

    constructor(address _cvc) {
        cvc = ICVC(_cvc);
    }

    function CVCAuthenticate() internal view returns (address) {
        if (msg.sender == address(cvc)) {
            (address onBehalfOfAccount,) = cvc.getExecutionContext(address(0));
            return onBehalfOfAccount;
        }

        return msg.sender;
    }

    function checkAccountAndMarketStatus(address account) internal {
        if (account == address(0)) {
            cvc.requireVaultStatusCheck();
        } else {
            cvc.requireAccountAndVaultStatusCheck(account);
        }
    }

    function revertBytes(bytes memory) internal pure virtual;
}
