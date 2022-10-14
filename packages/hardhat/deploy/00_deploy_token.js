// deploy/00_deploy_token.js

const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // commented out for verification
  // await deploy("JaxToken", {
  //   from: deployer,
  //   log: true,
  //   waitConfirmations: 5,
  // });

  // Getting a previously deployed contract
  const JaxToken = await ethers.getContract("JaxToken", deployer);
  /*
    await YourContract.transferOwnership(
      "ADDRESS_HERE"
    );
  */

  // Verify from the command line by running `yarn verify`

  // You can also Verify your contracts with Etherscan here...
  // You don't want to verify on localhost
  try {
    if (chainId !== localChainId) {
      await run("verify:verify", {
        address: JaxToken.address,
        contract: "contracts/JaxToken.sol:JaxToken",
        constructorArguments: [],
      });
    }
  } catch (error) {
    console.error(error);
  }
};
module.exports.tags = ["JaxToken"];
