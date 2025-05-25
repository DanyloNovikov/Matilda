const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("ShopifyPaymentProcessorModule", (m) => {
  const shopifyPaymentProcessor = m.contract("ShopifyPaymentProcessor");

  return { shopifyPaymentProcessor };
});
