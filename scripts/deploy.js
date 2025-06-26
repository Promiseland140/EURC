// scripts/deploy.js
async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying EURC with account:", deployer.address);

  const EURC = await ethers.getContractFactory("EURC");
  const eurc = await EURC.deploy();
  await eurc.deployed();

  console.log("EURC deployed to:", eurc.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
