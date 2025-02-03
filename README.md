# Foundry Development
## **System Variables in Solidity**

In Solidity, **system variables** (also known as **global variables**) are special variables that provide information about the blockchain, transaction, and execution environment. These variables are globally accessible in Solidity smart contracts.

### **Common System Variables in Solidity**

#### **1. Block Information**
These variables provide details about the current block.

| Variable | Description |
|----------|-------------|
| `block.number` | The current block number. |
| `block.timestamp` | The timestamp of the current block (seconds since Unix epoch). |
| `block.difficulty` | The difficulty level of the current block. |
| `block.gaslimit` | The gas limit of the current block. |
| `block.coinbase` | Address of the miner (validator) who mined the block. |

#### **2. Transaction Information**
These variables provide details about the transaction.

| Variable | Description |
|----------|-------------|
| `tx.origin` | The original sender of the transaction (EOA address). |
| `tx.gasprice` | The gas price of the transaction. |

#### **3. Message Information**
These variables provide details about the message call.

| Variable | Description |
|----------|-------------|
| `msg.sender` | The address of the caller (EOA or contract). |
| `msg.value` | The amount of Ether sent with the message (in wei). |
| `msg.data` | The complete calldata of the function call. |
| `msg.sig` | The first 4 bytes of `msg.data` (function selector). |

#### **4. Gas and Execution Information**
These variables relate to gas usage and contract execution.

| Variable | Description |
|----------|-------------|
| `gasleft()` | Returns the remaining gas. |
| `block.basefee` | Base fee per gas for the current block (introduced in EIP-1559). |

#### **5. Address-related Information**
These functions and variables provide details about contract addresses.

| Variable / Function | Description |
|---------------------|-------------|
| `address(this).balance` | Returns the balance of the contract. |
| `address.call{value: amount}("")` | Sends Ether to another address using low-level call. |


## Style Guide

### Contract elements should be laid out in the following order:
- Pragma statements
- Import statements
- Events
- Errors
- Interfaces
- Libraries
- Contracts
### Inside each contract, library or interface, use the following order:
- Type declarations
- State variables
- Events
- Errors
- Modifiers
- Functions
### Layout of Functions:
- constructor
- receive function (if exists)
- fallback function (if exists)
- external
- public
- internal
- private
- internal & private view & pure functions
- external & public view & pure functions


### The CEI Pattern in Solidity (Check-Effects-Interactions)
The Check-Effects-Interactions (CEI) pattern is a best practice in Solidity that helps prevent reentrancy attacks and ensures safe execution of smart contracts. It structures functions in a way that minimizes security risks by following three sequential steps:

1. Check: Validate inputs and conditions before proceeding.
2. Effects: Update the contract's state.
3. Interactions: Interact with external contracts (e.g., sending ETH or calling external functions) at the end.
##### Why Use the CEI Pattern?
- Prevents Reentrancy Attacks: By updating the contract state before external calls, an attacker cannot re-enter the contract and manipulate state inconsistencies.
- Reduces Unexpected State Changes: Ensures that all necessary state changes are made before interacting with external contracts.
- Enhances Gas Efficiency: Reduces unnecessary computations if a function fails early in the process.
```solidity
function coolFunction() public {
    // Checks
    checkX();
    checkY();
    // Effects
    updateStateM();
    // Interactions
    sendA();
    callB();
}
```


## Testing

### What is vm in Solidity?
- vm is a Foundry cheatcode interface for testing Solidity smart contracts.
- It allows blockchain state manipulation, making testing easier and faster.
- It does not exist in production contracts—only in Foundry test environments.

#### What Does vm Do?
In Foundry, vm is used inside Solidity test contracts to:

- Manipulate state (e.g., change block timestamps, fork mainnet)
- Mock contract behavior (e.g., prank users, deal ETH)
- Control EVM execution (e.g., snapshot/revert state)
This is only available during testing and does not exist in production Solidity contracts.

#### **Common `vm` Cheatcodes in Foundry**
Foundry provides a set of cheatcodes under the `vm` interface. Here are some commonly used ones:

#### **1. Changing Blockchain State**
```solidity
vm.warp(1700000000);  // Set block.timestamp
vm.roll(15000000);    // Set block.number
vm.fee(100 gwei);     // Set base fee for transactions
```
#### **2. Mocking Users and Transactions**
```solidity
vm.prank(alice);       // Set `msg.sender` to Alice for next call
vm.startPrank(bob);    // Start persistent prank as Bob
contract.call();       // Now, msg.sender = Bob
vm.stopPrank();        // Stop prank

```
#### **3. Handling ETH and Storage**
```solidity
vm.deal(alice, 100 ether);  // Give Alice 100 ETH
vm.store(address(this), slot, value);  // Directly modify storage slot
```

#### **4. Forking the Blockchain**
```solidity
vm.createFork("https://eth-mainnet.alchemyapi.io/v2/YOUR_API_KEY");
vm.selectFork(forkId);  // Switch to a forked state
```
#### **5. Debugging and Logging**
```solidity
vm.expectRevert();  // Expect a revert in the next transaction
vm.recordLogs();    // Start recording logs
logs = vm.getRecordedLogs();  // Retrieve logs
```

### Mock Tests in Foundry Solidity

#### What Are Mock Tests?

Mock tests in Foundry (a Solidity testing framework) are used to create fake or simulated contracts that help in unit testing. These mocks allow developers to isolate the functionality of a contract by replacing external dependencies with controlled implementations.

#### Why Use Mocks?

- **Isolation**: Test contracts without relying on real external dependencies.
- **Control**: Simulate different return values or behaviors to test various scenarios.
- **Efficiency**: Speed up testing by avoiding expensive operations like interacting with the blockchain.

#### How to Create Mocks in Foundry

Foundry uses Solidity-based unit tests, and you can create mock contracts directly in Solidity or use `vm.mockCall` to mock external contract responses.

#### 1. Creating a Mock Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockERC20 {
    function balanceOf(address account) external pure returns (uint256) {
        return 1000 * 1e18; // Mock returning a fixed balance
    }
}
```

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";

contract ExampleTest is Test {
    address mockToken;

    function setUp() public {
        mockToken = address(new MockERC20());
    }

    function testMockBalance() public {
        vm.mockCall(
            mockToken, 
            abi.encodeWithSignature("balanceOf(address)"), 
            abi.encode(500 * 1e18)
        );

        (bool success, bytes memory data) = mockToken.call(
            abi.encodeWithSignature("balanceOf(address)", address(this))
        );
        uint256 balance = abi.decode(data, (uint256));

        assertEq(balance, 500 * 1e18, "Mock balance should be 500 tokens");
    }
}

```

### Unit Testing

#### **Arrange-Act-Assert (AAA) in Solidity Testing**  
The **Arrange-Act-Assert (AAA) pattern** is a widely used testing pattern in Solidity (and general software testing) to structure tests clearly and make them more readable and maintainable.

##### Why Use AAA in Solidity Testing?
✅ Improves Readability – Clearly separates test setup, execution, and verification.
✅ Easier Debugging – Failures are easier to trace when each step is distinct.
✅ More Maintainable – Changes in business logic require only updating specific sections.

##### **Understanding AAA in Solidity Testing**  
1. **Arrange:** Set up the necessary environment, variables, and contracts.  
2. **Act:** Execute the function or transaction being tested.  
3. **Assert:** Verify that the expected outcome matches the actual result.  

This structure helps separate concerns in tests, improving readability and debugging.


#### Fuzz Testing - fuzzing

Generally, fuzz testing, also known as fuzzing, is an automated software testing technique that involves injecting invalid, malformed, or unexpected inputs into a system to identify software defects and vulnerabilities. This method helps in revealing issues that may lead to crashes, security breaches, or performance problems. Fuzz testing operates by feeding a program with large volumes of random data (referred to as "fuzz") to observe how the system handles such inputs. If the system crashes or exhibits abnormal behavior, it indicates a potential vulnerability or defect that needs to be addressed.

##### foundry.toml
```toml
[fuzz]
runs = 256
```


##### Stateful fuzz

##### Stateless fuzz



### Integration Tests in Foundry (Solidity)

#### What Are Integration Tests?
Integration tests in Foundry (a Solidity testing framework) ensure that multiple smart contracts and their interactions work as expected in a realistic environment. Unlike unit tests, which focus on isolated functions or contracts, integration tests verify how contracts interact with each other.

#### Why Use Integration Tests?
- Validate **cross-contract interactions**.
- Ensure that **complex workflows** function correctly.
- Detect issues that unit tests might **overlook**.
- Simulate **real-world contract interactions**.

#### How to Write Integration Tests in Foundry
Foundry uses the `forge test` command to execute tests written in Solidity. You typically:
1. Deploy multiple contracts.
2. Simulate interactions between them.
3. Assert expected behaviors.

##### Example
Below is a simple integration test using Foundry's `forge test`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/Staking.sol";

contract IntegrationTest is Test {
    Token token;
    Staking staking;
    address user = address(1);

    function setUp() public {
        token = new Token();
        staking = new Staking(address(token));
        token.mint(user, 1000 * 1e18);
    }

    function testUserCanStakeTokens() public {
        vm.startPrank(user);
        token.approve(address(staking), 500 * 1e18);
        staking.stake(500 * 1e18);
        vm.stopPrank();

        assertEq(staking.balanceOf(user), 500 * 1e18);
    }
}
```
#### Conclusion
Integration tests in Foundry help ensure that multiple smart contracts work together correctly. By leveraging Foundry’s powerful debugging and testing tools, developers can build robust, secure, and reliable Solidity applications.


### Fork Testing - Kind of staging

Fork testing in Solidity refers to testing smart contracts in a simulated environment that mirrors the current state of a live blockchain network, such as Ethereum. This process is commonly used to test smart contracts against real-world blockchain data without deploying them to the actual network.

#### How Fork Testing Works
1. Forking the Blockchain: A local test environment is created by "forking" a live blockchain (e.g., Ethereum mainnet or testnets like Goerli) using tools like Hardhat, Foundry, or Ganache.
2. Using Real-World Data: The forked state contains real contract states, balances, and historical transactions, allowing developers to interact with actual deployed contracts.
3. Testing Locally: Developers execute transactions and test their smart contracts against this forked state, ensuring compatibility with live conditions.
4. No Real Gas Fees: Unlike deploying to a real network, fork testing does not require spending real ETH for gas fees.
#### Benefits of Fork Testing
- Realistic Testing: Tests run against actual blockchain conditions.
- No Deployment Costs: Avoids gas fees while simulating mainnet interactions.
Debugging Before Deployment: Helps identify issues before deploying on the real network.
- Interacting with Existing Contracts: Enables testing with live DeFi protocols, ERC-20 tokens, oracles, and more.

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### Staging Testing
