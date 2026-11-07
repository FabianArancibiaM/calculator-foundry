// SPDX-License-Identifier: MIT

pragma solidity 0.8.37;

contract Calculadora {
    uint256 public resultado;
    address public admin;

    // Events
    event Addition(uint256 firstNumber_, uint256 secondNumber_, uint256 resultado_);
    event Substraction(uint256 firstNumber_, uint256 secondNumber_, uint256 resultado_);
    event Multiplier(uint256 firstNumber_, uint256 secondNumber_, uint256 resultado_);
    event Division(uint256 firstNumber_, uint256 secondNumber_, uint256 resultado_);

    // Modifiers
    modifier OnlyAdmin() {
        require(msg.sender == admin, "No autorizado");
        _;
    }

    constructor(uint256 firsResultado_, address admin_) {
        resultado = firsResultado_;
        admin = admin_;
    }

    // Functions

    // Addition
    function addition(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 resultado_) {
        resultado_ = firstNumber_ + secondNumber_;
        resultado = resultado_;
        emit Addition(firstNumber_, secondNumber_, resultado_);
    }

    // Substraction
    function substraction(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 resultado_) {
        resultado_ = firstNumber_ - secondNumber_;
        resultado = resultado_;
        emit Substraction(firstNumber_, secondNumber_, resultado_);
    }

    // Multiplier
    function multiplier(uint256 firstNumber_, uint256 secondNumber_) external returns (uint256 resultado_) {
        resultado_ = firstNumber_ * secondNumber_;
        resultado = resultado_;
        emit Multiplier(firstNumber_, secondNumber_, resultado_);
    }

    // Division
    function division(uint256 firstNumber_, uint256 secondNumber_)
        external
        OnlyAdmin
        returns (uint256 resultado_)
    {
        if (secondNumber_ == 0) {
            return 0;
        }   
        resultado_ = firstNumber_ / secondNumber_;
        resultado = resultado_;
        emit Division(firstNumber_, secondNumber_, resultado_);
    }
}
