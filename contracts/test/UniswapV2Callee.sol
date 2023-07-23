// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IUniswapV2Callee.sol";
import "../interfaces/IUniswapV2Pair.sol";
import "../interfaces/IUniswapV2Factory.sol";

import "solady/src/utils/SafeTransferLib.sol";

contract UniswapV2Callee is IUniswapV2Callee {
    address public factoryV2;

    constructor(address factoryV2_) {
        factoryV2 = factoryV2_;
    }

    function uniswapV2Call(address, uint amount0, uint amount1, bytes calldata) external {
        address token0 = IUniswapV2Pair(msg.sender).token0(); // fetch the address of token0
        address token1 = IUniswapV2Pair(msg.sender).token1(); // fetch the address of token1
        require(msg.sender == IUniswapV2Factory(factoryV2).getPair(token0, token1),
            "UniswapV2Callee: invalid sender"); // ensure that msg.sender is a V2 pair

        SafeTransferLib.safeTransfer(token0, address(msg.sender), amount0 == 0 ? 0 : amount0 * 1000 / 997 + 1);
        SafeTransferLib.safeTransfer(token1, address(msg.sender), amount1 == 0 ? 0 : amount1 * 1000 / 997 + 1);
    }
}
