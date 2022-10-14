pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract JaxToken is ERC20, Ownable {
    constructor() ERC20("Jax Token", "JAX") {
        _mint(
            0x3f15B8c6F9939879Cb030D6dd935348E57109637,
            1000000000000000000000000
        );
        transferOwnership(0x3f15B8c6F9939879Cb030D6dd935348E57109637);
    }

    // more to come...
}
