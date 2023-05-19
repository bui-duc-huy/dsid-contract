const { ethers } = require("hardhat")
const args = require("../constructor-args")

const main = async (hre) => {
    const provider = ethers.provider
    const from = await provider.getSigner().getAddress()

    const profileResponse = await hre.deployments.deploy('Profile', {
        from,
        args
    })


    console.log("Profile address", profileResponse.address)
}

module.exports = main
