var Marriage = artifacts.require("./Marriage.sol");

module.exports = function(deployer) {
  return deployer.deploy(Marriage);
};
