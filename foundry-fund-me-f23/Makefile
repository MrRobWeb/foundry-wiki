-include .env

build:
	forge build

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --account metaMaskKey --sender 0x2EB2dF65be28FAbDA062548a7Dedc81626bA4bf5 --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv