# Fork SushiSwap’s SushiBar contract and implementing Time lock after staking
# SushiBar

SushiBar is a Solidity contract that implements staking functionality with a time lock feature. It allows users to stake Sushi tokens and lock them for a specific duration. Based on the duration, a percentage of the staked tokens can be unstaked. The contract applies a tax on unstaked tokens, which is collected in the rewards pool.

## Features

- Staking: Users can stake Sushi tokens in the SushiBar contract.
- Time Lock: Tokens staked in the SushiBar are subject to a time lock. The unstaking rules are as follows:
  - 0-2 days: Locked (cannot be unstaked).
  - 2-4 days: 25% can be unstaked.
  - 4-6 days: 50% can be unstaked.
  - 6-8 days: 75% can be unstaked.
  - After 8 days: 100% can be unstaked (high tax applies).
- Tax: The unstaking of tokens incurs a tax. The tax rates are as follows:
  - 0-2 days: 0% tax.
  - 2-4 days: 75% tax.
  - 4-6 days: 50% tax.
  - 6-8 days: 25% tax.
  - After 8 days: 0% tax.
- Rewards Pool: The tax collected from unstaked Sushi tokens is added to the rewards pool.

## Tech Stack

- Solidity: The smart contract is implemented in Solidity, a programming language for Ethereum smart contracts.
- Hardhat: Hardhat is used as the development environment, providing testing and deployment capabilities.
- TypeScript: TypeScript is used for writing type-safe and structured code.
- Mocha: Mocha is used as the testing framework.

## Installation

1. Clone the repository:

git clone <repository-url>

2. Install dependencies:


npm install


## Usage

1. Run tests:

npx hardhat test


This will execute the unit tests for the SushiBar contract and ensure its functionality.

## License

Test-net ( Not- Applicable )

## Disclaimer

This code is a personal project and implemented in a testnet.




