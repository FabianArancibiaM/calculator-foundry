// SPDX-License-Identifier: MIT
pragma solidity 0.8.37;

import {Test, stdError} from "forge-std/Test.sol";
import {Calculator} from "../src/Calculator.sol";

contract CalculatorTest is Test {
    Calculator calculator;
    uint256 initialResult = 100;
    address admin = makeAddr("admin");
    address randomUser = makeAddr("randomUser");

    function setUp() public {
        calculator = new Calculator(initialResult, admin);
    }

    // Run all tests:          forge test
    // Run one test:           forge test --match-test test_Addition
    // Run one test + traces:  forge test --match-test test_Addition -vvvv

    // ---------------------------------------------------------------
    // Unit tests: fixed inputs, known expected outputs
    // ---------------------------------------------------------------

    function test_InitialState() public view {
        assertEq(calculator.result(), initialResult);
        assertEq(calculator.admin(), admin);
    }

    function test_Addition() public {
        uint256 result_ = calculator.addition(5, 7);

        assertEq(result_, 12);
        assertEq(calculator.result(), 12);
    }

    function test_AdditionEmitsEvent() public {
        vm.expectEmit();
        emit Calculator.Addition(5, 7, 12);

        calculator.addition(5, 7);
    }

    function test_Subtraction() public {
        uint256 result_ = calculator.subtraction(10, 4);

        assertEq(result_, 6);
        assertEq(calculator.result(), 6);
    }

    function test_SubtractionRevertsOnUnderflow() public {
        vm.expectRevert(stdError.arithmeticError);
        calculator.subtraction(4, 10);
    }

    function test_Multiplication() public {
        uint256 result_ = calculator.multiply(6, 7);

        assertEq(result_, 42);
        assertEq(calculator.result(), 42);
    }

    function test_MultiplicationRevertsOnOverflow() public {
        vm.expectRevert(stdError.arithmeticError);
        calculator.multiply(type(uint256).max, 2);
    }

    function test_DivisionAsAdmin() public {
        vm.prank(admin);
        uint256 result_ = calculator.division(20, 5);

        assertEq(result_, 4);
        assertEq(calculator.result(), 4);
    }

    function test_DivisionRevertsIfNotAdmin() public {
        vm.expectRevert(Calculator.Unauthorized.selector);
        vm.prank(randomUser);
        calculator.division(20, 5);
    }

    function test_DivisionRevertsOnZero() public {
        vm.expectRevert(Calculator.DivisionByZero.selector);
        vm.prank(admin);
        calculator.division(5, 0);
    }

    // ---------------------------------------------------------------
    // Fuzz tests: forge generates the inputs, we assert properties
    // ---------------------------------------------------------------

    function testFuzz_Addition(uint128 firstNumber_, uint128 secondNumber_) public {
        // uint128 inputs can never overflow a uint256 sum
        uint256 result_ = calculator.addition(firstNumber_, secondNumber_);

        assertEq(result_, uint256(firstNumber_) + uint256(secondNumber_));
    }

    function testFuzz_SubtractionRevertsOnUnderflow(uint256 firstNumber_, uint256 secondNumber_) public {
        vm.assume(firstNumber_ < secondNumber_);

        vm.expectRevert(stdError.arithmeticError);
        calculator.subtraction(firstNumber_, secondNumber_);
    }

    function testFuzz_Division(uint256 firstNumber_, uint256 secondNumber_) public {
        vm.assume(secondNumber_ != 0);

        vm.prank(admin);
        uint256 result_ = calculator.division(firstNumber_, secondNumber_);

        assertEq(result_, firstNumber_ / secondNumber_);
        assertEq(calculator.result(), firstNumber_ / secondNumber_);
    }

    function testFuzz_DivisionRevertsIfNotAdmin(address caller_, uint256 firstNumber_, uint256 secondNumber_) public {
        vm.assume(caller_ != admin);

        vm.expectRevert(Calculator.Unauthorized.selector);
        vm.prank(caller_);
        calculator.division(firstNumber_, secondNumber_);
    }
}
