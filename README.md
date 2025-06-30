
# FUND-IT (Foundry Version)

FundIt - Decentralized Crowdfunding Smart Contract using Foundry

[![Contributors](https://img.shields.io/github/contributors/gittyShiv/Fund-Me-Foundary.svg?style=for-the-badge)](https://github.com/gittyShiv/Fund-Me-Foundary/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/gittyShiv/Fund-Me-Foundary.svg?style=for-the-badge)](https://github.com/gittyShiv/Fund-Me-Foundary/network/members)
[![Stargazers](https://img.shields.io/github/stars/gittyShiv/Fund-Me-Foundary.svg?style=for-the-badge)](https://github.com/gittyShiv/Fund-Me-Foundary/stargazers)
[![Issues](https://img.shields.io/github/issues/gittyShiv/Fund-Me-Foundary.svg?style=for-the-badge)](https://github.com/gittyShiv/Fund-Me-Foundary/issues)
[![License](https://img.shields.io/github/license/gittyShiv/Fund-Me-Foundary.svg?style=for-the-badge)](https://github.com/gittyShiv/Fund-Me-Foundary/blob/main/LICENSE)

---

## 📖 About The Project

FundIt is a decentralized crowdfunding smart contract built using **Solidity** and the **Foundry framework**. It allows users to contribute ETH to the contract, with a minimum USD amount enforced through **Chainlink Price Feeds**. Only the contract owner can withdraw funds, ensuring secure and transparent fundraising.

### 🚀 Features

- Accepts ETH contributions from any wallet  
- Enforces minimum funding amount in **USD** using **Chainlink Oracle**  
- Records contributor addresses and amounts  
- Restricts withdrawals to the contract owner  
- Optimized for gas using `immutable`, `constant`, and custom errors  

---

## 🧰 Built With

- Solidity  
- Foundry (Forge, Cast, Anvil, Chisel)  
- Chainlink Price Feeds  
- Ethereum Sepolia Testnet  
- GitHub Actions (for CI testing)

---

## 🛠️ Getting Started

### Prerequisites

Ensure the following are installed:

- [Foundry](https://book.getfoundry.sh/getting-started/installation)  
- Node.js & npm (optional if you're using frontend integration)

### 📥 Installation

```bash
git clone https://github.com/gittyShiv/Fund-Me-Foundary.git
cd Fund-Me-Foundary
forge install
```

---

## ⚙️ Usage

### 🧪 Run Tests

```bash
forge test -vv
```

### ⛽ Gas Reports

```bash
forge test --gas-report
```

> Outputs gas usage per function to the terminal.

### 🔍 Local Deployment

Start a local Anvil node:

```bash
anvil
```

In another terminal:

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://127.0.0.1:8545 --private-key <PRIVATE_KEY> --broadcast
```

---

## 🌐 Deployment to Sepolia Testnet

### Set up `.env`

Create a `.env` file in the root directory:

```ini
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
PRIVATE_KEY=your_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

### Deploy

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe   --rpc-url $SEPOLIA_RPC_URL   --private-key $PRIVATE_KEY   --broadcast   --verify
```

> `--verify` will automatically verify the contract on Etherscan using your API key.

---

## 🛣️ Roadmap

- [ ] Frontend DApp integration using Ethers.js or Viem  
- [ ] Allow multiple fundraising campaigns  
- [ ] Implement refund mechanism  
- [ ] Add individual donation history  

See [issues](https://github.com/gittyShiv/Fund-Me-Foundary/issues) for more ideas or to contribute.

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository  
2. Create a new branch:
```bash
git checkout -b feature/AmazingFeature
```
3. Commit your changes:
```bash
git commit -m "Add some AmazingFeature"
```
4. Push to GitHub:
```bash
git push origin feature/AmazingFeature
```
5. Open a pull request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 📬 Contact

**Shivam Maurya**  
📧 shivamvision07@gmail.com  
🔗 [Project Repository](https://github.com/gittyShiv/Fund-Me-Foundary)

