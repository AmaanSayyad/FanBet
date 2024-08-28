const hre = require('hardhat');
async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
const tokenAddress = '0xBFff78BB02925E4D8671D0d90B2a6330fcAedd87';
const userAddress = '0x8bffbd0C80b289aC038B8dF9280b16D7Bae08a29';

function getSecondsOfDays(day) {
  return day * 24 * 60 * 60;
}
async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  console.log('Deploying Betting Platform Token Contract...');

  const BettingPool = await hre.ethers.deployContract('BettingPool', [
    tokenAddress,
    userAddress,
  ]);

  await BettingPool.waitForDeployment();

  console.log(
    'BettingPool Deployed Successfully on Mentioned Network',
    BettingPool.target
  );

  console.log('Waiting for 30 Seconds to Verify the Contract on Etherscan');
  await sleep(30 * 1000);

  // // Verify the RektLock Contract
  await hre.run('verify:verify', {
    address: BettingPool.target,
    constructorArguments: [tokenAddress, userAddress],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
