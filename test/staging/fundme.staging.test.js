const { assert, expect } = require("chai")
const { deployments, ethers, getNamedAccounts, network } = require("hardhat")
const { developementChains } = require("../../helper-hardhat-config")

developementChains.includes(network.name)
    ? describe.skip
    : describe("Fundme", async () => {
          let fundMe, deployer
          const sendValue = ethers.utils.parseEther("0.1") // 1ETh
          beforeEach(async () => {
              deployer = (await getNamedAccounts()).deployer
              fundMe = await ethers.getContract("FundMe", deployer)
          })
          it("allows people to fund and withdraw", async () => {
              await fundMe.fund({ value: sendValue })
              await fundMe.withdraw()
              const endingBalance = await fundMe.provider.getBalance(
                  fundMe.address
              )
              assert.equal(endingBalance.toString(), "0")
          })
      })
