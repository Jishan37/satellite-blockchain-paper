# Satellite Blockchain Implementation
Repository for paper: "[Enhancing Security and Transparency in Satellite Data
 Transactions using Ethereum-Based Blockchain]"

## Contents
- `contracts/`: Solidity smart contracts (ERC1155 tokenization)
- `scripts/`: Deployment scripts
- `test/`: Hardhat test cases

## Setup
1. Install dependencies:
```bash
npm install --save-dev hardhat @openzeppelin/contracts
npx hardhat test


2. **Basic Hardhat Test** (`test/SatelliteERC1155.test.js`):
```javascript
const { expect } = require("chai");

describe("SatelliteERC1155", function() {
  it("Should only allow validators to tokenize data", async function() {
    const [owner, validator, nonValidator] = await ethers.getSigners();
    const Contract = await ethers.getContractFactory("SatelliteERC1155");
    const contract = await Contract.deploy([validator.address]);
    
    await expect(
      contract.connect(nonValidator).tokenizeData([], 0, "")
    ).to.be.revertedWith("Caller is not a validator");
  });
});
