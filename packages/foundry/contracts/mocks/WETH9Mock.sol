// SPDX-License-Identifier: BUSL-1.1
import "@yield-protocol/utils-v2/contracts/token/ERC20.sol";
pragma solidity 0.8.14;


contract WETH9Mock is ERC20 {
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    constructor () ERC20("Wrapped Ether", "WETH", 18) { }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint wad) public {
        require(_balanceOf[msg.sender] >= wad, "WETH9: Insufficient balance");
        _balanceOf[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view override returns (uint) {
        return address(this).balance;
    }

    /// @dev Give tokens to whoever asks for them.
    function mint(address to, uint256 amount) public virtual {
        _mint(to, amount);
    }
}