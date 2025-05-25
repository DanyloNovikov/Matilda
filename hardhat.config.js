require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
const NetworkDefinitor = require("./lib/NetworkDefinitor");

module.exports = {
  solidity: process.env.SOLIDITY_VERSION || "0.8.28",
  networks: new NetworkDefinitor().allNetworks(),
  etherscan: { apiKey: process.env.ETHERSCAN_API_KEY }
};
