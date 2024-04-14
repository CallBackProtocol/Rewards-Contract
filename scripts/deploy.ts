import { ethers } from "hardhat";

async function main() {
  const RewardTokenFactory = await ethers.deployContract(
    "RewardTokenFactory",
    []
  );

  await RewardTokenFactory.waitForDeployment();

  console.log(
    `Reward Token Factory is deployed to ${RewardTokenFactory.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
