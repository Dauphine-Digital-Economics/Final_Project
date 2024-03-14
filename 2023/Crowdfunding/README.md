## Crowdfunding dApp: Revolutionizing Project Funding on the Blockchain
### Team members: 
 - Margot Monge
 - Yichen Cheng
 - Aizhan Zhakupova
### Introduction:
Traditional crowdfunding platforms have been around for quite some time now, but with the advent of blockchain technology, we can take crowdfunding to a whole new level of transparency and decentralization. Our Crowdfunding dApp aims to provide a platform for project creators to raise funds directly from investors without the need for intermediaries. This decentralized approach enables efficient, secure, and transparent funding for projects of all types and sizes.

**Value Proposition:**
The Crowdfunding dApp addresses several problems in traditional crowdfunding platforms, such as high fees, lack of transparency, and a centralized decision-making process. Our dApp offers the following benefits:

**1. Transparency:** All transactions on the blockchain are publicly visible, enabling stakeholders to track project funding in real-time.

**2. Lower Fees:** The dApp utilizes smart contracts to eliminate the need for intermediaries, significantly reducing fees.

**3. Decentralization:** The platform is decentralized, eliminating the need for centralized intermediaries that control the decision-making process.

### Project Demo:
Our Crowdfunding dApp enables project creators to easily create a funding campaign, set a funding goal, and specify a deadline. Investors can then contribute to the project using stablecoins, such as USDC or DAI, via the blockchain. Once the funding goal is reached, project creators can withdraw their funds directly to their wallet.

### Solidity Code Considerations:
Our dApp is built using Solidity, a programming language used to create smart contracts on the Ethereum blockchain. 
When coding the dApp, we made several considerations to optimize gas usage and ensure the efficient execution of the smart contracts.
The Crowdfund smart contract, built on Solidity version 0.8.17, employs the OpenZeppelin SafeMath library to prevent potential integer overflow errors that could compromise the integrity of the contract. The library is a highly regarded solution within the Ethereum ecosystem for secure arithmetic operations on unsigned integers in Solidity. The SafeMath library is imported and utilized within the contract for all arithmetic operations, from addition to division, demonstrating a commitment to safeguarding the contract against potential security threats. The use of SafeMath instills investor confidence that the contract's computations are accurate and secure, two essential factors in any financial application.
Using the Hardhat development environment, we successfully deployed our smart contract, which resulted in the acquisition of a contract address (0x7b00830e338Fb65ae392b54c0052F85768E96f08). This address can now be utilized to perform interactions with our contract on the Ethereum blockchain.
``` 
npx hardhat run deploy/00-deploy.js --network alfajores
```
https://alfajores.celoscan.io/address/0x7b00830e338fb65ae392b54c0052f85768e96f08

### Project Structure:
Our project consists of two smart contracts: the Crowdfund contract and the Project contract. The Crowdfund contract is responsible for managing all the projects on the platform, including starting new projects and returning all the active projects. The Project contract represents individual funding campaigns and is responsible for accepting contributions, tracking the total raised amount, and managing the project's state. 
The Crowdfund smart contract is a reliable way to raise funds for projects on the Ethereum blockchain. This contract allows project creators to create new campaigns and receive contributions in the form of ERC20 tokens. The contract implements OpenZeppelin's SafeMath library for secure arithmetic operations, ensuring that all calculations are performed correctly.

One key feature of the contract is the ProjectStarted event, which emits information about the new project, including the project creator's address, name, project title, description, image link, fundraising deadline, and goal amount. This provides transparency and accountability for all stakeholders, as they can easily verify project details.

The contract also includes a Project state enumeration, which enables the contract to track the state of each project. The state transitions from Fundraising to Expired or Successful based on the status of the fundraising campaign. This feature ensures that project creators cannot withdraw funds until the fundraising deadline has passed, and the project has met its goal.

In addition, the contract's getDetails function allows users to retrieve project details, including the project creator's name and address, the project title, description, image link, fundraising deadline, current state, goal amount, current balance, and total amount raised. This function provides transparency and allows stakeholders to track the progress of each project.

### Gas Optimization:
We made several considerations to optimize gas usage in the dApp. For example, we used the transferFrom function instead of the approve and transfer functions in the contribute function to reduce gas usage. Additionally, we used a mapping to store the contributions made by investors, rather than an array, to reduce gas usage when iterating over contributions. To make the contract even more gas-efficient, we use the view modifier instead of external when possible to indicate that a function does not modify the contract state and use memory instead of storage for function arguments. Additionally, we tried to avoid unnecessary storage reads/writes and removed redundant code to reduce gas costs and improve the overall efficiency of the contract.

### Conclusion:
Our Crowdfunding dApp offers a decentralized, transparent, and cost-effective approach to project funding that is not possible with traditional crowdfunding platforms. By leveraging the benefits of blockchain technology, we can enable efficient and secure funding for projects of all types and sizes. With the dApp's transparent and decentralized nature, investors can have greater trust in the projects they fund, while project creators can reach their funding goals more easily and at a lower cost. We believe that our Crowdfunding dApp has the potential to revolutionize project funding, and we are excited to see its impact on the crowdfunding industry.