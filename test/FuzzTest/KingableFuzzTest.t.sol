// SPDX-License-Identifier: MIT

/// @title KingableFuzzTest.
/// @author Michealking (@BuildsWithKing)
/**
 * @notice Created on the 13th of Sept, 2025.
 *
 *      Kingable fuzz test contract, verifying all features works as intended.
 */
pragma solidity ^0.8.30;

/// @notice Imports KingableUnitTest, and Kingable.
import {KingableUnitTest} from "../UnitTest/KingableUnitTest.t.sol";
import {Kingable} from "../../src/Kingable.sol";

contract KingableFuzzTest is KingableUnitTest {
    // ------------------------------------------------- Fuzz test: transferKingship --------------------------------
    /// @notice Fuzz test Only valid EOAs can become king.
    /// @param _randomKingAddress The random king's address.
    function testFuzz_TransferKingshipOnlyEOA(address _randomKingAddress) external {
        // Assume: must be a valid address and not a contract.
        vm.assume(
            _randomKingAddress != address(0) && _randomKingAddress != _king && _randomKingAddress != address(kingable)
                && _randomKingAddress.code.length == 0
        );

        // Prank as _king.
        vm.prank(_king);
        vm.expectEmit(true, true, false, false);
        emit Kingable.KingshipTransferred(_king, _randomKingAddress);
        kingable.transferKingship(_randomKingAddress);

        // Assert new king is set correctly.
        assertEq(kingable.currentKing(), _randomKingAddress);
    }

    /// @notice Fuzz test invalid addresses revert.
    /// @param _randomKingAddress The random king's address
    function testFuzz_InvalidAddressesRevert(address _randomKingAddress) external {
        // If random king address is address zero, _king, kingable or contract address.
        if (
            _randomKingAddress == address(0) || _randomKingAddress == _king || _randomKingAddress == address(kingable)
                || _randomKingAddress.code.length > 0
        ) {
            // Revert InvalidAddress.
            vm.expectRevert(Kingable.InvalidAddress.selector);
            vm.prank(_king);
            kingable.transferKingship(_randomKingAddress);
        }
    }

    // ------------------------------------------------- Fuzz test: renounceKingship --------------------------------
    /// @notice Fuzz test RenounceKingship reverts Unauthorized.
    /// @param _randomUserAddress The random users address.
    function testFuzz_RenounceKingshipRevertsUnauthorized(address _randomUserAddress) external {
        // Revert Unauthorized(_randomUserAddress, _king)
        vm.expectRevert(abi.encodeWithSelector(Kingable.Unauthorized.selector, _randomUserAddress, _king));

        // Prank as random users.
        vm.prank(_randomUserAddress);
        kingable.renounceKingship();
    }

    /// @notice Fuzz test: King can renounce successfully.
    function testFuzz_RenounceKingshipByKing() external {
        // Prank as king.
        vm.prank(_king);
        vm.expectEmit(true, true, false, false);
        emit Kingable.KingshipRenounced(_king, address(0));
        kingable.renounceKingship();

        // Assert no king afferwards
        assertEq(kingable.currentKing(), address(0));
    }

    // ------------------------------------------------ Fuzz test: isKing ----------------------------------
    /// @notice Fuzz testing isKing. 
    /// @param _randomUserAddress The random users address.
    function testFuzz_IsKing(address _randomUserAddress) external {
        // Prank as _random user. 
        vm.prank(_randomUserAddress);
        bool state = kingable.isKing(_king);

        // Assert _king is true. 
        assertEq(state, true);
    }
}
