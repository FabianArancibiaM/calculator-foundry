// SPDX-License-Identifier: MIT

pragma solidity 0.8.37;

import "../src/Calculadora.sol";
import "forge-std/Test.sol";

contract CalculadoraTest is Test {
    Calculadora calculadora;
    uint256 public firstResultado = 100;
    address public admin = vm.addr(1);
    address public randomUser = vm.addr(2);

    function setUp() public {
        calculadora = new Calculadora(firstResultado, admin);
    }
    /*
    Ejecutar test en general: forge test
    Ejecutar un test especifico: forge test --match-test testCheckFirsResultado
    Ejecutar un test especifico + paso a paso : forge test --match-test testCheckFirsResultado -vvvv
 */
    function testCheckFirsResultado() public view {
        uint256 firsResult_ = calculadora.resultado();
        assert(firsResult_ == firstResultado);
    }

    function testAddition() public {
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        uint256 restult_ = calculadora.addition(firstNumber_, secondNumber_);

        assert(restult_ == firstNumber_ + secondNumber_);
    }

    function testSubstraction() public {
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        uint256 restult_ = calculadora.substraction(
            firstNumber_,
            secondNumber_
        );

        assert(restult_ == firstNumber_ - secondNumber_);
    }

    function testMultiplier() public {
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        uint256 restult_ = calculadora.multiplier(firstNumber_, secondNumber_);

        assert(restult_ == firstNumber_ * secondNumber_);
    }

    function testCanNotMultiply2LargeNumbers() public {
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 115792089237316195423570985008687907853269984665640564039457584007913129639934;

        vm.expectRevert();
        calculadora.multiplier(firstNumber_, secondNumber_);
    }

    function testIfNotAdminCallsDivisionReverts() public {
        vm.startPrank(randomUser);
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        vm.expectRevert();
        calculadora.division(firstNumber_, secondNumber_);

        vm.stopPrank();
    }

    function testAdminCallsDivisionCorrectly() public {
        vm.startPrank(admin);
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        calculadora.division(firstNumber_, secondNumber_);

        vm.stopPrank();
    }

    function testDefaultCanNotCallDivisionCorrectly() public {
        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 2;
        vm.expectRevert();
        calculadora.division(firstNumber_, secondNumber_);
    }

    function testDivisionExecutesCorrectly() public {
        vm.startPrank(admin);

        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 5;
        uint256 restult_ = calculadora.division(firstNumber_, secondNumber_);

        assert(restult_ == firstNumber_ / secondNumber_);
        vm.stopPrank();
    }

    function testCanNotDivisionZero() public {
        vm.startPrank(admin);

        uint256 firstNumber_ = 5;
        uint256 secondNumber_ = 0;

        vm.expectRevert();
        calculadora.division(firstNumber_, secondNumber_);

        vm.stopPrank();
    }
}
