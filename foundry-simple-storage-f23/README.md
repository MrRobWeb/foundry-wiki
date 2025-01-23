## Work with foundry
```shell
# initialize foundry
forge --init
# run local blockchain
anvil
# interact with blockchain
cast ...
```


## Encrypt reusable private key in ERC-2335

### Create Key
```shell
cast wallet import defaultKey --interactive
```
### List Key
```shell
cast wallet list
```

### Deploy without .env
```shell
# local deployment
forge script script/DeploySimpleStorage.s.sol --rpc-url 127.0.0.1:8545 --account defaultKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast -vvvv
```

### Deploy with .env
```shell
# add environment variables
source .env
# deploy contract locally
forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --account defaultKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast -vvvv
# deployment to sepolia
forge script script/DeploySimpleStorage.s.sol --rpc-url $SEPOLIA_RPC_URL --account metaMaskKey --sender 0x2EB2dF65be28FAbDA062548a7Dedc81626bA4bf5 --broadcast -vvvv
```

## Interact with Smart Contract
```shell
cast send 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 "store(uint256)" 123 --rpc-url $RPC_URL --account defaultKey 
cast call 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0 "retreive()" --rpc-url $RPC_URL --account defaultKey 
```

## Zksync

### install zksync
```shell
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
#use foundryup-zksync
foundryup-zksync
#check version
forge --version
```
### build with zksync
```shell
forge build --zksync
```

### using anvil-zksync
```shell
anvil-zksync
```


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

