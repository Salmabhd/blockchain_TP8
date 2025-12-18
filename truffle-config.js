module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",  // Match any network id
    },
  },

  // Où placer les fichiers compilés (.json)
  contracts_build_directory: "./src/artifacts/",

  // Configuration du compilateur Solidity
  compilers: {
    solc: {
      version: "0.5.9",  // Version récente compatible Node 22
      settings: {
        optimizer: {
          enabled: false,
          runs: 200
        },
        evmVersion: "petersburg" // Compatible avec 0.8.x
      }
    }
  }
};