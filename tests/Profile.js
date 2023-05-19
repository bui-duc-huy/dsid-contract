const hardhat = require("hardhat")

describe("Profile", () => {
  let profile

  before(async () => {
    const Profile = await hardhat.ethers.getContractFactory("Profile")
    profile = await Profile.deploy("", "Digital Profile Identity", "DSID")
  })

  it("Only admin can create profile", async () => {
    const data_address = []
    const data_id = []
    const data_root = []

    const newWallet = hardhat.ethers.Wallet.createRandom()
    data_address.push(newWallet.address)
    data_id.push(1)
    data_root.push("0x76dd03b49e9255297ff2bdf8296a95e685c267d8fd53eed410afad5d0e3b495b")

    await profile.mint(data_address, data_id, data_root)
  })

  it("Only profile's owner can update profile", async() => {
    const data_address = []
    const data_id = []
    const data_root = []

    const [_adminWallet, userWallet] = await ethers.getSigners()

    data_address.push(userWallet.address)
    data_id.push(2)
    data_root.push("0x76dd03b49e9255297ff2bdf8296a95e685c267d8fd53eed410afad5d0e3b495b")

    await profile.mint(data_address, data_id, data_root)
  })
  it("Only admin can remove profile", async () => {
    await profile.burn([2])
  })
  it("Verify profile with true data", () => {
    // verify in offchain 
  })
  it("Verify profile with wrong data, should return fail", () => {
    // verify in offchain 
  })

  it("Test 100 address", async () => {

    const data_address = []
    const data_id = []
    const data_root = []

    for (let i = 100; i < 200; i++) {
      const newWallet = hardhat.ethers.Wallet.createRandom()
      data_address.push(newWallet.address)
      data_id.push(i + 1)
      data_root.push("0x76dd03b49e9255297ff2bdf8296a95e685c267d8fd53eed410afad5d0e3b495b")
    }

    await profile.mint(data_address, data_id, data_root)
  })
})
