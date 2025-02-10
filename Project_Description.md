# Final Exam: Project + Course Questions

The final project of this course is to create your own dApp. You may use any library, extension and support tool of your choice. If you need idea inspirations, please refer to the [Syllabus](https://github.com/Dauphine-Digital-Economics/Lectures/blob/main/week1/Overview%20and%20Syllabus.pdf).

You must deliver both an oral presentation as well as submit your slides.

### Final Project
##### Technical Requirements

Imagine that you will be presenting your dApp to some investors and your dApp has the potential to be the next startup in the Web3 space. You can create something entirely original and never seen before in the industry or you may take an existing use case and make some improvements. Do some market research which will help you understand your project's differentiating factor and shape the functionalities of your dApp.

Once you have decided on your project idea and functionalities, please build a working MVP (minimally viable product) using Forge. To control the minimum complexity standard, your project must consist of:

1. At least 3 Solidity files - Logical division of functionality per file and good coding practices to keep technical debt to a minimum (eg. refactor your code, not excessively large contracts). Reminder, you can have multiple contracts in a file if it makes sense.
2. At least 2 main functions in each file. Any number of helper functions.
3. At least 1 function in each file must contain in-line assembly. See Lecture 11.
4. At least 1 unit test for each of the main functions. 1 special test per file (Fuzz, Invariance).
5. Scalability, gas snapshots and code scanning encouraged but not mandatory. These will support your written submission and oral presentation.

You must be able to successfully deploy your code to the Sepolia testnet. Remember to stock up on testnet tokens!

##### Oral Presentation

The presentation should be maximum 25min with 5min for questions. Please respect the time limit and structure your presentation as follows:

* Elevator pitch of dApp (Idea description, market analysis, target audience)
* Technical overview with competitive analysis
  * General architecture / technical specification of the functionalities of each Solidity file and how they interact with each other
  * Technical features which make your dApp different from standard ones in the market (faster, cheaper, more secure, better user experience)
* Code quality practices
  * Gas Reports and Optimization techniques
  * Reasons why you chose the specific test cases for your code (example: is it a frequently called function and required a scalability test?)
  * Steps taken to ensure clean, readable code. Did you follow any coding conventions?
* Product demo on Etherscan using Metamask, Scripts, Cast, any tool of your choice.

### Oral exam of course content

The oral exam covers content on any lecture slide. You may chose to answer as a team or individually. As a team, question may be answered by any member but all members will receive the same grade. For the individual option, each team member will be asked to answer 1 or 2 questions and grades are individually assigned. The oral examination will last 20min.