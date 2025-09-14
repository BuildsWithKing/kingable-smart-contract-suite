// SPDX-License-Identifier: MIT

/// @title KingableUnitTest.
/// @author Michealking (@BuildsWithKing)
/**
 * @notice Created on the 13th of Sept, 2025.
 *
 *     Kingable unit test contract, verifying all features works as intended.
 */
pragma solidity ^0.8.30;

/// @notice Imports Test from forge standard library, Kingable, KingableMockTest and Dummy contract.
import {Test} from "forge-std/Test.sol";
import {Kingable} from "../../src/Kingable.sol";
import {KingableMockTest} from "./KingableMockTest.t.sol";
import {DummyContract} from "./DummyContract.t.sol";

contract KingableUnitTest is Test {
    // ------------------------------------------ Variable assignment -----------------------------------

    /// @notice Assigns kingable.
    KingableMockTest internal kingable;

    /// @notice Assigns king, zero and new king.
    address internal _king = address(0x5);
    address internal constant _zero = address(0);
    address internal _newKing = address(0x10);

    // --------------------------------------------- SetUp function. --------------------------------------------

    /// @notice This function runs before every other function.
    function setUp() external {
        // Create a new instance of KingableMockTest.
        kingable = new KingableMockTest(_king);

        // Label king, zero and newKing.
        vm.label(_king, "KING");
        vm.label(_zero, "ZERO");
        vm.label(_newKing, "NEWKING");
    }

    // ------------------------------------------------- Constructor test functions. -----------------------------

    /// @notice Test to ensure constructor sets initial king at deployment.
    function testConstructor_SetsKingAtDeployment() external {
        // Assign _contractKing.
        address _contractKing = kingable.currentKing();

        // Assert both are equal.
        assertEq(_king, _contractKing);
    }

    /// @notice Test to ensure constructor emits event.
    function testConstructor_EmitsEvent() external {
        // Emit "KingshipTransferred".
        vm.expectEmit(true, true, false, false);
        emit Kingable.KingshipTransferred(_zero, _king);
        kingable = new KingableMockTest(_king);
    }

    /// @notice Test to ensure address zero reverts.
    function testZeroAddress_RevertsIfSetAsInitialKing() external {
        // Revert InvalidAddress, if address zero is set as initial king.
        vm.expectRevert(Kingable.InvalidAddress.selector);
        kingable = new KingableMockTest(_zero);
    }

    /// @notice Test to ensure contract addresses reverts.
    function testContractAddress_RevertsIfSetAsInitialKing() external {
        // Assign dummy.
        DummyContract dummy = new DummyContract();

        // Revert InvalidAddress, if a contract address is set as initial king.
        vm.expectRevert(Kingable.InvalidAddress.selector);
        kingable = new KingableMockTest(address(dummy));
    }

    // ----------------------------------------------------- King's test write functions. -----------------------------

    /// @notice Test to ensure king can transfer kingship.
    function testTransferKingship_Succeeds() external {
        // Prank as king.
        vm.prank(_king);
        vm.expectEmit(true, true, false, false);
        emit Kingable.KingshipTransferred(_king, _newKing);
        kingable.transferKingship(_newKing);

        // Revert "Unauthorized(_king, _newKing)".
        vm.expectRevert(abi.encodeWithSelector(Kingable.Unauthorized.selector, _king, _newKing));
        vm.prank(_king);
        kingable.transferKingship(_newKing);
    }

    /// @notice Test to ensure king can't transfer kingship to self.
    function testTransferKingship_RevertsIfSelf() external {
        // Revert with "SameKing(_king)".
        vm.expectRevert(abi.encodeWithSelector(Kingable.SameKing.selector, _king));
        vm.prank(_king);
        kingable.transferKingship(_king);

        // Assert current king is still _king.
        assertEq(kingable.currentKing(), _king);
    }

    /// @notice Test to ensure king can't transfer kingship to contract address.
    function testTransferKingship_RevertIfContractAddress() external {
        // Assign dummy.
        DummyContract dummy = new DummyContract();

        // Revert with "InvalidAddress".
        vm.expectRevert(Kingable.InvalidAddress.selector);
        vm.prank(_king);
        kingable.transferKingship(address(dummy));

        // Assert current king is still _king.
        assertEq(kingable.currentKing(), _king);
    }

    /// @notice Test to ensure only king can transfer kingship.
    function testTransferKingship_RevertIfNotKing() external {
        // Revert "Unauthorized(_zero, _king)".
        vm.expectRevert(abi.encodeWithSelector(Kingable.Unauthorized.selector, _zero, _king));
        vm.prank(_zero);
        kingable.transferKingship(_newKing);

        // Assert current king is still _king.
        assertEq(kingable.currentKing(), _king);
    }

    /// @notice Test to ensure king can renounce kingship.
    function testRenounceKingship_Succeeds() external {
        // Prank as king.
        vm.prank(_king);
        vm.expectEmit(true, true, false, false);
        emit Kingable.KingshipRenounced(_king, _zero);
        kingable.renounceKingship();

        // Revert "Unauthorized(_king, _zero)".
        vm.expectRevert(abi.encodeWithSelector(Kingable.Unauthorized.selector, _king, _zero));
        vm.prank(_king);
        kingable.renounceKingship();
    }

    // --------------------------------------------------- User's test read functions. --------------------------------------

    /// @notice Test to ensure isKing returns true or false.
    function testIsKing() external {
        // Assign isKing.
        bool isKing = kingable.isKing(_zero);

        // Assert both are equal.
        assertEq(isKing, false);
    }
}
