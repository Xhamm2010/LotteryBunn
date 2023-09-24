//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery{
    address payable [] public players;
    

    address public manager;

// The manage should be the only one that can deploy this contract
    constructor(){
        manager = msg.sender;
    }

// This allows the players to buy in to the Lottery by Stalking 0.1 ether
    receive()payable external{
        require(msg.value == 0.1 ether);

        players.push(payable(msg.sender));

    }

// This gets th Balance in the contract and only the manager can call this function
    function getBalance() public view returns (uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

// This function is used to select random player in the array of players
function random() internal view returns (uint){
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
}
   
// This fuction allows the Manager of the Lottery to pick the winner
function pickWinner() public{
    require(msg.sender == manager);
    require(players.length >= 3);

    uint rand = random();

    address payable winner;

    uint index = rand % players.length;

    winner = players[index];
     
     // manager takes 10% of the winnings
    uint managerFee =(getBalance()*10)/100;

    // The winner gets 90%
     uint winnersPrice =(getBalance()*90)/100;

     winner.transfer(winnersPrice);

     payable(manager). transfer(managerFee);

    // resetting the lottery for the next round
     players = new address payable[](0);
   
}

}