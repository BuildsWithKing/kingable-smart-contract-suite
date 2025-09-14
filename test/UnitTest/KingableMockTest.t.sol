// SPDX-License-Identifier: MIT

/// @title KingableMockTest.
/// @author Michealking (@BuildsWithKing)
/**
 * @notice Created on the 13th of Sept, 2025.
 *
 *  Creating mock for abtract contracts is the best and professional method.
 */
pragma solidity ^0.8.30;

/// @notice Imports kingable contract.
import {Kingable} from "../../src/Kingable.sol";

contract KingableMockTest is Kingable {
    // --------------------------------------- Constructor -----------------------------------------------

    /// @dev Sets initial king.
    /// @param _kingAddress The initial king's address.
    constructor(address _kingAddress) Kingable(_kingAddress) {}
}
