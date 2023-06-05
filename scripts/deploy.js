const { ethers } = require("hardhat");
const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
  const flashLoan = await FlashLoan.deploy('0xC911B590248d127aD18546B186cC6B324e99F02c'); // form Aave website https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses

  await flashLoan.deployed();
  console.log("FlashLoan deployed to:", flashLoan.address)

  const data = {
    address: flashLoan.address,
    abi: JSON.parse(flashLoan.interface.format('json'))
  }

  //This writes the ABI and address to the FlashLoan.json
  fs.writeFileSync('./client/src/contract/FlashLoan.json', JSON.stringify(data))
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
