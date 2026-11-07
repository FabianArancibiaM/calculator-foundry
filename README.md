# Calculator — Solidity + Foundry

[![CI](https://github.com/FabianArancibiaM/calculator-foundry/actions/workflows/test.yml/badge.svg)](https://github.com/FabianArancibiaM/calculator-foundry/actions/workflows/test.yml)
![Solidity](https://img.shields.io/badge/Solidity-0.8.37-363636)
![License](https://img.shields.io/badge/license-MIT-blue)

My first [Foundry](https://book.getfoundry.sh/) project, built during the **BlockChain Accelerator** program. It is a small, deliberately simple smart contract used to practice the full Foundry workflow: access control, custom errors, events, unit tests, fuzz tests and CI.

> **Scope:** learning exercise. It is not deployed and has not been audited.

## The contract

`src/Calculator.sol` stores the result of the last operation in `result` and exposes four operations:

| Function | Caller | Behavior |
|---|---|---|
| `addition(a, b)` | Anyone | Stores `a + b`, emits `Addition`. Reverts on overflow. |
| `subtraction(a, b)` | Anyone | Stores `a - b`, emits `Subtraction`. Reverts if `b > a`. |
| `multiply(a, b)` | Anyone | Stores `a * b`, emits `Multiplication`. Reverts on overflow. |
| `division(a, b)` | `admin` only | Stores `a / b` (rounded down), emits `Division`. Reverts with `Unauthorized` or `DivisionByZero`. |

The `admin` and the initial `result` are set in the constructor.

## Design decisions

- **Custom errors** (`Unauthorized`, `DivisionByZero`) instead of `require` strings: cheaper in gas and easy to assert in tests.
- **Division by zero reverts.** Fuzzing found this edge case on its own (inputs `5, 0`). Returning `0` silently would hide the error and skip the event and state update, so the function reverts instead.
- **Arithmetic safety** comes from Solidity 0.8 checked math; the tests assert the panic on overflow and underflow.

## Tests

14 tests in `test/Calculator.t.sol` (10 unit, 4 fuzz):

- **Unit:** initial state, each operation, event emission (`vm.expectEmit`), overflow and underflow reverts, admin-only division (`vm.prank`), division by zero.
- **Fuzz:** addition never loses precision (`uint128` inputs), subtraction always reverts when `a < b`, division matches `a / b` for any non-zero divisor, and any caller other than `admin` is rejected.

## Getting started

Requires [Foundry](https://book.getfoundry.sh/getting-started/installation).

```bash
git clone --recurse-submodules https://github.com/FabianArancibiaM/calculator-foundry.git
cd calculator-foundry

forge build
forge test
forge test --match-test test_Addition -vvvv   # one test, with traces
forge coverage                                # coverage report
forge fmt --check                             # formatting check (also runs in CI)
```

## Project structure

```
├── src/Calculator.sol            # Contract
├── test/Calculator.t.sol         # Unit and fuzz tests
├── lib/forge-std                 # Dependency (git submodule)
├── foundry.toml
└── .github/workflows/test.yml    # CI: fmt check, build, tests
```

## Known limitations

- `result` is shared state: any address can overwrite it by calling `addition`, `subtraction` or `multiply`. Fine for an exercise, not for a real application.
- `admin` cannot be changed after deployment.

## What I learned

- Writing unit tests with cheatcodes (`vm.prank`, `vm.expectRevert`, `vm.expectEmit`) and asserting exact custom errors.
- Using fuzzing to find edge cases I had not thought of, and fixing the contract instead of silencing the test.
- Setting up CI so formatting, build and tests run on every push.

## Author

**Fabian Arancibia** — full-stack developer moving into smart contract development and security.
[GitHub](https://github.com/FabianArancibiaM)

## License

[MIT](LICENSE)
