const { getNamedAccounts, ethers } = require("hardhat")

async function main() {
    const { deplyoer } = await getNamedAccounts()
    const fundMe = await ethers.getContract("FundMe", deplyoer)
    console.log("Funding contract...")
    const transactionResponse = await fundMe.fund({
        value: ethers.utils.parseEther("0.1")
    })
    await transactionResponse.wait(1)
    console.log("Amount Funded!")
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error)
        process.exit(1)
    })
