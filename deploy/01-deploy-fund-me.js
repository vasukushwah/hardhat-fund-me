// function deployFun() {
//     console.log("Hello!!")
// }
// module.exports.default = deployFun

const { network } = require("hardhat")
const {
    networkConfig,
    developementChains,
} = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

// const ethUsdPriceFeedAddress = networkConfig["chainId"]["ethUsdPriceFeed"]

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    // console.log(deployer)
    const chainId = network.config.chainId

    let ethUsdPriceFeedAddress
    if (developementChains.includes(network.name)) {
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    const args = [ethUsdPriceFeedAddress]

    const fundMe = await deploy("FundMe", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (
        !developementChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, args)
    }
    log("--------------------------------------------------------")
}

module.exports.tags = ["all", "fundme"]
