# Final Project Description and Details

The final project of this course is to create your own dApp. You may chose to create any app, using any development framework, library, or other code support tool of your choice. If you need idea inspirations, please refer to [Lecture 1](https://github.com/Dauphine-Digital-Economics/Lectures/blob/main/week1/Lecture1.pdf).

You will deliver both an oral presentation as well as submit a written document. Please see the Deliverables section for more details of what is expected. The groups for the final project is the same as presented in Lecture 1, but here they are again:

* Group 1 - Laetitia, Jiawei, Cédric
* Group 2 - Yichen, Margot, Aizhan
* Group 3 - Valentin, Léa, Yanming

### Business and Technical Requirements

Imagine that you will be presenting your dApp to some investors and your dApp has the potential to be the next startup in the Web3 space shooting for the moon. You can create something entirely original and never seen before in the industry or you may take an existing use case and make some improvements. Do some market research which will help you shape the functionalities of your dApp.

Once you have decided on your dApp idea and functionalities, please build your dApp in Hardhat. Your dApp must consist of:

1. At least 3 Solidity files - Logical division of functionality per file and good coding practices to keep technical debt to a minimum (eg. refactor your code, files not over 300 lines of code long).
2. At least 2 functions in each file and at least 1 test for each file.
3. At least 1 function in each file must contain in-line assembly.
4. At least 1 custom configuration in the hardhat.config.js file

You must be able to successfully deploy your dApp to the Celo Alfajores testnet. Remember to get some testnet tokens! See Homework 4 if you need a refresh on the process.

### Deliverables
##### Oral Presentation

On 12 April, each group will deliver a (maximum) 30min oral presentation of their dApp. The time breakdown are as follows:

* 5pm - 5:30pm | Group 1 presents
* 5:30pm - 5:40pm | Break
* 5:40pm - 6:10pm | Group 2 presents
* 6:10pm - 6:20pm | Break
* 6:20pm - 6:50pm | Group 3 presents

The presentation should be maximum 25min with 5min for questions. Please structure your presentation as follows:

* Elevator pitch of dApp (Idea description, market analysis, target audience)
* Technical walkthrough of your code
  * General architecture of the functionalities of each Solidity file and how they interact with each other
  * Technical features which make your dApp different from standard ones in the market (faster, cheaper, more secure, better user experience)
* Coding practices
  * Gas Optimization techniques
  * Gas reports which show these reductions
  * Reasons why you chose the specific test cases for your code (example: is it a frequently called function?)
  * Steps taken to ensure clean, readable code 

##### Written Submission
Imagine you are promoting your dApp to a DAO which, if the proposal succeeds, will give you a huge grant to implement your idea. Please produce a proposal of any length, 500 words is recommended, which contains the following sections:

* Short description of your dApp idea (similar to the oral elevator pitch)
* List team members in bullet points
* A description of current technical functionalities and interesting technical points
* A description of the SDLC process milestones/actions from what you have now until the point where you are ready to release your dApp to the market (ie. add a new feature, user testing, security auditing and CI/CD setup)
* A timeline (Gantt charts preferred) of the previously described steps with how much funding you are requesting for each step (Some examples, You can hire a developer to make new features for you or you can say you want to do it yourself and be paid for your time or hire a Smart Contract auditing company, etc).
