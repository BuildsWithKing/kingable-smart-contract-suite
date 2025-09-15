[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Foundry](https://img.shields.io/badge/Built%20With-Foundry-blue)](https://book.getfoundry.sh/)
[![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen)](Screenshot/image.png)
# 👑 Kingable Smart Contract Suite

**Author**: Michealking (@BuildsWithKing)  
**Created**: September 13, 2025  
**License**: MIT

---

## 📜 Overview

**Kingable** is a modular Solidity contract designed to enforce king-based access control. It allows a designated king to perform privileged operations, transfer kingship to a valid external address, or renounce kingship entirely, leaving the contract kingless.

This repository includes:
- ✅ `Kingable.sol`: The abstract contract with core logic
- ✅ `KingableMockTest.t.sol`: A concrete mock for testing constructor
- ✅ `DummyContract.t.sol`: A dummy contract used to simulate error "InvalidAddress". 
- ✅ `KingableUnitTest.t.sol`: A full unit test suite with 100% coverage
- ✅ `KingableFuzzTest.t.sol`: A fuzz test suite validating edge cases and randomized inputs

---

## 🔐 Features

- **Access Control**: Restricts sensitive functions to the current king via the `onlyKing` modifier  
- **Kingship Transfer**: Allows the king to transfer authority to a valid Externally Owned Account (EOA)  
- **Renunciation**: Enables the king to relinquish control, setting the king to `address(0)`  
- **Custom Errors**: Gas-efficient error handling with descriptive errors (`Unauthorized`, `SameKing`, `InvalidAddress`)  
- **Virtual Functions**: External functions are marked `virtual`, allowing child contracts to override and customize behavior  
- **Event Emissions**: Emits `KingshipTransferred` and `KingshipRenounced` for transparent state changes  
- **Reentrancy Protection**: Secured with `ReentrancyGuard` to prevent reentrancy attacks



---

## 📽 Kingable in Action 

### [WATCH VIDEO](https://1drv.ms/v/c/4292b05ee508e173/EThWwoYNSCFMrNU4HfaWtYcBdnAvKRJ9Tcop-M6pqEmgPw?e=QjucGU)

---

## 🧪 Testing

### ✅ Unit Tests (`KingableTest.t.sol`)
- Constructor logic and event emission
- Kingship transfer and renunciation
- Revert conditions for invalid inputs
- Access control enforcement
- Read function validation (`isKing`, `currentKing`)

### 🔁 Fuzz Tests (`KingableFuzzTest.t.sol`)
- Randomized kingship transfers to valid EOAs
- Reverts for zero, contract, and duplicate addresses
- Access control fuzzing for unauthorized renunciation

### 🧪 Coverage
- **Lines**: 100%
- **Statements**: 100%
- **Branches**: 100%
- **Functions**: 100%

---

## ⚡Installation: 

Install this package into your Foundry/Hardhat project by adding it as a Git submodule or using forge install:

```solidity
forge install BuildsWithKing/buildswithking-security
```
Then import module with:

```solidity
import {Kingable} from "lib/buildswithking-security/contracts/access/Kingable.sol";
```
---

## 🛠️ Usage

To inherit `Kingable` in your contract:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Kingable} from "lib/buildswithking-security/contracts/access/Kingable.sol";

contract MyDapp is Kingable {
    constructor(address _kingAddress) Kingable(_kingAddress) {}

    function doKingStuff() external onlyKing {
        // only the King can call this
    }
}
```

## 📁 Directory Structure

```
├── src/
│   └── Kingable.sol
├── test/
|       ├── UnitTest
│       |       ├── KingableMockTest.t.sol
│       |       ├── KingableUnitTest.t.sol
|       |       └── DummyContract.t.sol
|       ├──FuzzTest
│               ├── KingableFuzzTest.t.sol
│   
```

---

## 🧠 Author's Note

This contract was built with extensibility, security, and audit-readiness in mind. Whether you're building a governance module, royalty manager, or role-based system, `Kingable` provides a clean foundation for king-based access control.

---

## 📜 License

This project is licensed under the MIT License.
