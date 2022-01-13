from brownie import Lottery, accounts, config, network
from web3 import Web3

def test_get_entrance_fee():
    account = accounts[0]
    print(f"Network Active: {network.show_active()}")
    lottery = Lottery.deploy(config["networks"][network.show_active()]["eth_usd_price_feed"],{"from": account})
    print(f"Entrance Fee: {lottery.getEntranceFee()}") 
    assert lottery.getEntranceFee() > Web3.toWei(0.015, "ether"), f"Entrance Fee: {lottery.getEntranceFee()}"
    assert lottery.getEntranceFee() < Web3.toWei(0.031, "ether"), f"Entrance Fee: {lottery.getEntranceFee()}"
