require("dotenv").config({ path: ".env" });
require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  /*networks:{
  alfajores: {
  url: "https://alfajores-forno.celo-testnet.org",
  accounts: [process.env.PRIVATE_KEY],
  chainId: 44787,
  }
}*/
};

