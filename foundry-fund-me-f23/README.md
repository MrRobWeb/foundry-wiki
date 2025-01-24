## Install chainlink
```shell
forge install smartcontractkit/chainlink --no-commit
```
## Testing
```shell
forge test
# log level: -v, -vv, -vvv, -vvvv
forge test -vv
# run only one test
forge test --mt testPriceFeedVersionIsAccurate
# fork blockchain
forge test --fork-url $SEPOLIA_RPC_URL
forge test --mt testPriceFeedVersionIsAccurate --fork-url $SEPOLIA_RPC_URL
# calculate the coverage of your code - How much of your code is covered by tests?
forge coverage --fork-url $SEPOLIA_RPC_URL
```

## Calculate gas consumption
```shell
forge snapshot --mt testWithdrawFromASingleFunder
```

## Script deploying
```shell
forge script script/DeployFundMe.s.sol
```