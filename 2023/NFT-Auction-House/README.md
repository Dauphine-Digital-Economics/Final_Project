# NFTAuctionShop

The smart contract has been deployed on Celo Alfajores at this address: 0xcD0DB4237faDA594D412a2CE75d0230fa07f8e32

## Project Briefing

Since 2021, secondary transaction has been contributing more and more trading volume to the NFT market. Under this circumstance, user-friendly and reliable auction houses become a urge need for these Web3 participants. Although there has already been some mature companies providing NFT auction services in the market, most of them are centralized platforms, which results in some potential issues:

- Censorship from the platform firm or authorities: At any time, the firms are able to block merchants' accounts on their platforms, temporarily or permanently. In some cases, the firm has no choices but have to block the transaction if the regulators ask it to do that, especially in some countries where blockchain trading is not encouraged.
- Trust issues with unregulated trading houses: As the transactions with cryptocurrencies are limited in some countries, people may choose to use some unregulated trading houses. However, these centralized platform may compromise or even take the fund from users without providing corresponding services.
- Commission for exhibitions: Some platforms may charge fee from the sellers if they would like to exhibit their goods on the platform. Although charging an exhibition fee is not unethical as companies require fund to operate, sometimes they charges with a very high rate which would apply extra burden to buyers as well as sellers and deplete the activation of the market.
- Mismatched ownership of data: When people use centralized platform to trade their NFTs, the data is actually owned and controlled by the platform instead of users themselves. For example, if some merchants would like to change another vendor, it is very unlikely that they are able to retrieve their data from centralized platforms.

Under this situation, we believe that decentralized auction house is the answer to the problems mentioned above. However, traditional solutions with sole Ethereum have their own drawback: storing images and large text on Ethereum is very expensive, not to mention that sometimes doing so is impossible due to the technical limitations of EVM. Thus, we developed a brand new decentralized NFT auction house, with below advantages compared to other solutions in the market:

- Use IPFS to store NFTs with minimum costs.
- Multi-sig escrow contract providing custody service after the auction is closed.
- Vickrey auction is applied where the best strategy for all the bidders is to give the authentic bidding amount in their perception, as the winner has no influences on the final strike price.

## Development Team

- Yanming Zhang: Product architect and developer
- Valentin Loiret: Developer and data engineer
- Lea Viala: Data manager and business development

## Module of contracts

### 1. NFT

The NFT contract allows sellers to upload their NFT to IPFS and generate a CID as output.

### 2. Escrow

Once the auction is completed, all bidders reveal their respective bids, and a winner is born. What's next? The seller must send the goods to the buyer and the buyer must pay the seller. Several issues may arise at this time.

- How to ensure that the seller will deliver the goods as agreed? The seller can disappear with the money.
- What if the seller does deliver the goods, but the buyer does not acknowledge receipt of the goods?
- If the goods are damaged, the funds should be returned to the buyer, but what if the seller refuses?

To address all of these issues, we create a Multi Sign Escrow contract that stores the number of auctions won by the buyer, with the buyer, seller, and any third party as participants. The funds under custody can only be released to the seller or returned to the buyer, and at least two of the three participants' consent is required for execution. We will implement a hosting contract and add the ability to create an Ethereum hosting contract at runtime when the auction ends.

### 3. AuctionHouse

With this contract, several steps will be executed to complete the auction. First, the sellers will set up an auction, defining the parameters such as start time, end time and so on, as well as uploading product details and properties. Then the bidders are allowed to bid in the given time frame after which the winner will be revealed along with the bidding information. Finally, the payable amount will be sent based on the rules of Vickrey auction and the escrow contract will be called.

## SDLC milestone

- UX/UI: Visualize the interaction surface with delicate design to optimize the user experience.
- Web front-end: The web front-end is composed of a combination of HTML, CSS, and JavaScript (heavily using web3js). Users will interact with blockchain, IPFS, and NodeJS servers through this front-end application.
- Databases set up: Although products are stored on the blockchain, they are displayed by querying the blockchain and applying various filters (such as displaying only a certain type of product, displaying products that are about to expire, etc.). We will use the MongoDB database to store product information and display products by querying MongoDB.
- Compliance and contract auditing: Hire a specialist firm to audit our contract and legal counsellors to work on the legal structure as well as compliance construction.
- Deployment and marketing: Put forward the initial version of our Dapp and construct business development activities for marketing purposes.