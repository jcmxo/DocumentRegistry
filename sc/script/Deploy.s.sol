// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script, console2} from "forge-std/Script.sol";
import {DocumentRegistry} from "../src/DocumentRegistry.sol";

/**
 * @title Deploy
 * @notice Deployment script for DocumentRegistry contract
 * @dev To deploy, run:
 *      forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast --private-key <PRIVATE_KEY>
 *
 *      For Anvil (local development):
 *      forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
 *
 *      For verification on Etherscan:
 *      forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast --verify --etherscan-api-key <API_KEY>
 */
contract Deploy is Script {
    function run() external returns (DocumentRegistry) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        console2.log("Deploying DocumentRegistry...");
        console2.log("Deployer address:", vm.addr(deployerPrivateKey));
        console2.log("Chain ID:", block.chainid);

        DocumentRegistry registry = new DocumentRegistry();

        console2.log("DocumentRegistry deployed at:", address(registry));

        vm.stopBroadcast();

        return registry;
    }
}

/**
 * @notice Alternative deployment function for Anvil (uses default account)
 */
contract DeployAnvil is Script {
    function run() external returns (DocumentRegistry) {
        // Use default Anvil account (first account)
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        vm.startBroadcast(deployerPrivateKey);

        console2.log("Deploying DocumentRegistry to Anvil...");
        console2.log("Deployer address:", vm.addr(deployerPrivateKey));
        console2.log("Chain ID:", block.chainid);

        DocumentRegistry registry = new DocumentRegistry();

        console2.log("DocumentRegistry deployed at:", address(registry));

        vm.stopBroadcast();

        return registry;
    }
}

