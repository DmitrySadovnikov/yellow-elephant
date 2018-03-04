var SimpleStorage  = artifacts.require("./SimpleStorage.sol");
var TutorialToken  = artifacts.require("./TutorialToken.sol");
var ComplexStorage = artifacts.require("./ComplexStorage.sol");
var HashStore      = artifacts.require("./HashStore.sol");
var Ethnote        = artifacts.require("./Ethnote.sol");

const Web3 = require('web3');

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(TutorialToken);
  deployer.deploy(ComplexStorage);

  const web3 = new Web3(deployer.provider);
  const price = web3.toWei(0.001, "ether");
  console.log("Deployment Price", price);
  deployer.deploy(HashStore, price);
  deployer.deploy(Ethnote, price);
};
