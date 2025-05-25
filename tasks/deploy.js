require("dotenv").config();

task("deploy-to", "Deploy contract to specific network")
  .addParam("network", "Network to deploy to (sepolia, mainnet, etc)")
  .addParam("contract", "Contract name to deploy")
  .addOptionalVariadicPositionalParam(
    "constructorArgs",
    "Constructor arguments for the contract",
    []
  )
  .setAction(async (taskArgs, hre) => {
    const networkName = taskArgs.network;
    console.log(`Deploying to ${networkName} network...`);
    
    if (!hre.config.networks[networkName]) {
      console.error(`Network ${networkName} not defined in your configuration`);

      return;
    }
    
    await hre.changeNetwork(networkName);
    await hre.run("compile");

    const ContractFactory = await hre.ethers.getContractFactory(taskArgs.contract);
    const constructorArgs = taskArgs.constructorArgs.map(arg => {
      if (/^\d+$/.test(arg)) return BigInt(arg);
      return arg;
    });
    
    console.log(`Deploying ${taskArgs.contract} with arguments:`, constructorArgs);
    
    const contract = await ContractFactory.deploy(...constructorArgs);
    await contract.waitForDeployment();
    
    const deployedAddress = await contract.getAddress();
    console.log(`Contract deployed to ${deployedAddress} on ${networkName}`);
    
    if (['sepolia', 'mainnet', 'goerli'].includes(networkName)) {
      console.log('Waiting for block confirmations...');
      await contract.deploymentTransaction().wait(5);
      
      console.log('Verifying contract...');
      try {
        await hre.run("verify:verify", {
          address: deployedAddress,
          constructorArguments: constructorArgs,
        });
        console.log("Contract verified successfully");
      } catch (error) {
        console.log("Verification failed:", error);
      }
    }
  }
);
