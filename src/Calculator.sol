// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

/// @title Calculator
/// @notice Learning exercise: basic arithmetic that stores the last result on-chain.
/// @dev Anyone can overwrite `result` (it is shared state). Only `admin` can call `division`.
contract Calculator {
    /// @notice Result of the last operation executed.
    uint256 public result;

    /// @notice Address allowed to call `division`.
    address public admin;

    // Errors
    error Unauthorized();
    error DivisionByZero();

    // Events
    event Addition(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Subtraction(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Multiplication(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);
    event Division(uint256 firstNumber_, uint256 secondNumber_, uint256 result_);

    // Modifiers
    modifier onlyAdmin() {
        if (msg.sender != admin) revert Unauthorized();
        _;
    }

    constructor(uint256 initialResult_, address admin_) {
        result = initialResult_;
        admin = admin_;
    }

    /// @notice Adds two numbers and stores the result. Reverts on overflow.
    function addition(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 result_) {
        result_ = firstNumber_ + secondNumber_;
        result = result_;
        emit Addition(firstNumber_, secondNumber_, result_);
    }

    /// @notice Subtracts two numbers and stores the result. Reverts if `secondNumber_ > firstNumber_`.
    function subtraction(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 result_) {
        result_ = firstNumber_ - secondNumber_;
        result = result_;
        emit Subtraction(firstNumber_, secondNumber_, result_);
    }

    /// @notice Multiplies two numbers and stores the result. Reverts on overflow.
    function multiply(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 result_) {
        result_ = firstNumber_ * secondNumber_;
        result = result_;
        emit Multiplication(firstNumber_, secondNumber_, result_);
    }

    /// @notice Divides two numbers (rounding down) and stores the result.
    /// @dev Only `admin`. Reverts with `DivisionByZero` instead of failing silently.
    function division(uint256 firstNumber_, uint256 secondNumber_) external onlyAdmin returns (uint256 result_) {
        if (secondNumber_ == 0) revert DivisionByZero();

        result_ = firstNumber_ / secondNumber_;
        result = result_;
        emit Division(firstNumber_, secondNumber_, result_);
    }
}
